import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/models/profile/refer_friend_model.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';


class ReferFriendView extends StatefulWidget {
  final String? referralCode;
  final String? referralLink;
  const ReferFriendView({Key? key, required this.referralCode, required this.referralLink}) : super(key: key);

  @override
  State<ReferFriendView> createState() => _ReferFriendViewState();
}

class _ReferFriendViewState extends State<ReferFriendView> {

  bool copied = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext buildContext) {
    return OfflineBuilder(
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
              title: Text("Invite", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
            ),
            body: StreamBuilder<ApiResponse<ReferralInfoModel>?>(
                stream: profileManager.referralInfo,
                builder: (BuildContext streamContext, AsyncSnapshot<ApiResponse<ReferralInfoModel>?> snapshot) {
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
                        return referFriendBody(buildContext, snapshot.data?.data);
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
    );
  }

  Widget referFriendBody(BuildContext context, ReferralInfoModel? data) {
    String? points = data?.referee?.replaceAll(RegExp(r'[^0-9]'),'');
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          children: [
            Image.asset("assets/images/ic_invite_friends.png", fit: BoxFit.fitWidth,),
            SizedBox(height: 35.h,),
            Text(data?.referer??"", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: AppColors.lightBlack),),
            SizedBox(height: 35.h,),
            Text(data?.referee??"", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),),
            SizedBox(height: 40.h,),
            Text("Referral Code", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
            SizedBox(height: 25.h,),
            RoundOutlineButton(
              onPressed: (){
                Clipboard.setData(ClipboardData(text: widget.referralCode??""));
                setState(() {
                  copied = true;
                });
                AppUtils.showToast("Referral code copied to clipboard", color: Colors.green);
              },
              borderRadius: 9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.referralCode??"", style: TextStyle(fontFamily: "GothamBold", fontSize: 15.sp, color: AppColors.lightBlack)),
                  SizedBox(width: 15.w,),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 1000),
                    firstChild: Image.asset("assets/images/ic_copy.png", width: 24.sp, height: 24.sp, fit: BoxFit.contain, alignment: Alignment.center,),
                    secondChild: Icon(Icons.check_circle_outline_outlined, size: 24.sp, color: AppColors.lightBlack,),
                    crossFadeState: copied ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h,),
            RoundButton(
              onPressed: (){
                Share.share('Hi friend! Please sign up for the MySOGO App by using my referral code or the link below, and you will be rewarded with $points Pts and other rewards. \nMy referral code: ${widget.referralCode} \nLink: ${widget.referralLink}', subject: 'Look what I made!');
              },
              borderRadius: 9,
              child: Text("Invite Friends", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
