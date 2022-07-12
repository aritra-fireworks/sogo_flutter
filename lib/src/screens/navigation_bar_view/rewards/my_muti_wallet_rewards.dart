import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/rewards_manager/rewards_manager.dart';
import 'package:sogo_flutter/src/managers/ui_manager/nav_bar_manager.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/models/rewards/my_multi_wallet_list_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/my_reward_details.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/my_multi_reward_card_view.dart';

class MyMultiWalletView extends StatefulWidget {
  final String id;
  final String type;
  final String condition;
  final List<Mall> malls;
  const MyMultiWalletView({Key? key, required this.id, required this.type, required this.condition, required this.malls}) : super(key: key);

  @override
  State<MyMultiWalletView> createState() => _MyMultiWalletViewState();
}

class _MyMultiWalletViewState extends State<MyMultiWalletView> {

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    rewardsManager.getMyMultiRewardsList(start: 0, offset: 0, id: widget.id, condition: widget.condition, type: widget.type);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text("My Rewards", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
          ),
          body: StreamBuilder<ApiResponse<MyMultiWalletListModel>?>(
              stream: rewardsManager.myMultiRewardsList,
              builder: (BuildContext context, AsyncSnapshot<ApiResponse<MyMultiWalletListModel>?> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      debugPrint('Loading');
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                        ),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(color: AppColors.primaryRed,),
                      );
                    case Status.COMPLETED:
                      debugPrint('Dashboard Loaded');
                      return eventsListBody(snapshot.data?.data, context);
                    case Status.NODATAFOUND:
                      debugPrint('Not found');
                      return const SizedBox();
                    case Status.ERROR:
                      debugPrint('Error');
                      return const SizedBox();
                  }
                }
                return Container();
              }),
        ),
      ],
    );
  }

  Widget eventsListBody(MyMultiWalletListModel? rewards, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        itemCount: rewards?.wallet?.length??0,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyRewardDetails(rewardId: rewards!.wallet![index].id!, rewardType: rewards.wallet![index].type!),));
            },
            child: Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: MyMultiRewardCardView(malls: widget.malls, wallet: rewards!.wallet![index]),
            ),
          );
        },
      ),
    );
  }
}