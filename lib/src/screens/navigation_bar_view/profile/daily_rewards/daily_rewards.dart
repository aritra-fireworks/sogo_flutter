import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/daily_reward_manager/daily_reward_manager.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/models/rewards/daily_rewards_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/daily_rewards/daily_reward_popup.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';


class DailyRewardsView extends StatefulWidget {
  const DailyRewardsView({Key? key}) : super(key: key);

  @override
  State<DailyRewardsView> createState() => _DailyRewardsViewState();
}

class _DailyRewardsViewState extends State<DailyRewardsView> {

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dailyRewardManager.dailyRewardInfo();
  }


  @override
  Widget build(BuildContext buildContext) {
    return ModalProgressHUD(
      progressIndicator: LoadingIndicator(
        indicatorType: Indicator.ballScale,
        colors: [AppColors.primaryRed, AppColors.secondaryRed],
      ),
      inAsyncCall: isLoading,
      child: OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
          if (connectivity == ConnectivityResult.none) {
            return const Scaffold(
              body: Center(child: NetworkErrorPage()),
            );
          }
          return child;
        },
        child: Stack(
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
                    Navigator.pop(buildContext);
                  },
                ),
                centerTitle: true,
                title: Text("Daily Rewards", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
              ),
              body: StreamBuilder<ApiResponse<DailyRewardsModel>?>(
                  stream: dailyRewardManager.dailyReward,
                  builder: (BuildContext streamContext, AsyncSnapshot<ApiResponse<DailyRewardsModel>?> snapshot) {
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
                          debugPrint('Profile Loaded');
                          return dailyRewardsBody(buildContext, snapshot.data?.data);
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
        ),
      ),
    );
  }

  Widget dailyRewardsBody(BuildContext context, DailyRewardsModel? data) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15.h,),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Text("Check in for 1 more day get Extra Reward!", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: const Color(0xFF080808)),),
            ),
            if(data?.weeks != null)
              Padding(
                padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 20.h),
                child: Column(
                  children: data!.weeks!.map((e) => weekRow(e)).toList(),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: RoundButton(
                onPressed: () async {
                  if(!(data?.claimedToday??false)){
                    setState(() {
                      isLoading = true;
                    });
                    CommonResponseModel? updateResponse = await dailyRewardManager.checkIn();
                    setState(() {
                      isLoading = false;
                    });
                    if(updateResponse?.status == "success") {
                      AppUtils.showCustomDialog(context: context, withConfetti: true, dialogBox: DailyRewardPopup(onOkClicked: (){
                        dailyRewardManager.dailyRewardInfo();
                      },));
                    } else {
                      AppUtils.showMessage(context: context, title: "Error!", message: updateResponse?.message??"Failed to check in. Try again.");
                    }
                  } else {
                    AppUtils.showToast("Come back tomorrow!");
                  }
                },
                borderRadius: 9,
                color: (data?.claimedToday??false) ? const Color(0xFFCCCCCC) : AppColors.primaryRed,
                child: Text("Check In", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white),),
              ),
            ),
            SizedBox(height: 20.h,),
            checkInHistory(data?.checkInHistory),
          ],
        ),
      ),
    );
  }

  Widget weekRow(Week week) {
    return Row(
      children: week.days?.map((e) => Expanded(child: rewardBox(e))).toList() ?? [const SizedBox()],
    );
  }

  Widget rewardBox(Day day) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(day.dayReward??"", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamMedium", fontSize: 9.sp, color: const Color(0xFF080808)),),
              SizedBox(height: 6.h,),
              Stack(
                alignment: const Alignment(0, 0.6),
                fit: StackFit.loose,
                children: [
                  Image.asset("assets/images/${(day.dayCheckedIn??false) ? "ic_reward_grey.png" : "ic_reward_red.png"}", fit: BoxFit.fitWidth,),
                  Text("${day.day}", style: TextStyle(fontFamily: "GothamMedium", fontSize: 10.sp, color: (day.dayCheckedIn??false) ? const Color(0xFF666767) : const Color(0xFFB10023)),)
                ],
              ),
              SizedBox(height: 6.h,),
              Text(day.dayTitle??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 9.sp, color: const Color(0xFF080808)),),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: day.day != null && day.day == 7 ? Colors.transparent : ((day.dayCheckedIn??false) ? const Color(0xFF666767) : const Color(0xFFB10023)),
            borderRadius: BorderRadius.circular(2.h),
          ),
          width: 12.w,
          height: 4.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
        ),
      ],
    );
  }

  Widget checkInHistory(List<CheckInHistory>? checkInHistory) {
    if(checkInHistory != null && checkInHistory.isNotEmpty){
      return Padding(
        padding: EdgeInsets.all(20.sp),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(21), topRight: Radius.circular(21), bottomLeft: Radius.circular(11), bottomRight: Radius.circular(11)),
          child: Column(
            children: [
              Container(
                color: const Color(0xFFCCCCCC),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                alignment: Alignment.centerLeft,
                child: Text("Reward History", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
              ),
              ...checkInHistory.map((e) => checkInTile(e)).toList()
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }

  }

  Widget checkInTile(CheckInHistory checkInHistory) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        border: Border(top: BorderSide(color: Colors.white, width: 2.sp))
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(checkInHistory.date??"", style: const TextStyle(fontFamily: "GothamBold", fontSize: 12, color: Color(0xFF636363)),),
          Row(
            children: [
              Expanded(child: Text(checkInHistory.checkInAt??"", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: const Color(0xFF636363),),),),
              Text(checkInHistory.reward??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: const Color(0xFF44A356),),),
            ],
          ),
        ],
      ),
    );
  }
}
