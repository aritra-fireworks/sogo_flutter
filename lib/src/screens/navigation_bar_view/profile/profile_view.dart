import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/managers/ui_manager/nav_bar_manager.dart';
import 'package:sogo_flutter/src/models/profile/user_profile_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/edit_profile.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/daily_rewards/daily_rewards.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/manage_password/manage_password.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/refer_friend_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/settings_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/transaction_history/transaction_history_view.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  SfRangeValues _values = const SfRangeValues(0.0, 6000.0);
  bool isLoading = false;
  List<ProfileLinkTile> links = [];

  @override
  void initState() {
    super.initState();
    profileManager.getProfile();
    profileManager.getReferralInfo();
  }
  

  @override
  Widget build(BuildContext context) {
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
                    navManager.updateNavIndex(0);
                  },
                ),
                centerTitle: true,
                title: Text("Profile", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
              ),
              body: StreamBuilder<ApiResponse<UserProfileModel>?>(
                  stream: profileManager.profile,
                  builder: (BuildContext streamContext, AsyncSnapshot<ApiResponse<UserProfileModel>?> profileSnapshot) {
                    if (profileSnapshot.hasData) {
                      switch (profileSnapshot.data!.status) {
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
                          if(profileSnapshot.data?.data?.status == "fail" || profileSnapshot.data?.data?.status == "Session expired, please get new token"){
                            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                              authManager.logout(context);
                            });
                          }
                          links = [
                            ProfileLinkTile("assets/images/ic_edit_profile.png", "Edit Profile", () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileView(),));
                            }),
                            ProfileLinkTile("assets/images/ic_manage_password.png", "Manage Password", () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ManagePasswordView(),));
                            }),
                            ProfileLinkTile("assets/images/ic_transaction_history.png", "Transaction History", () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistoryView(memberId: profileSnapshot.data?.data?.profile?.cardno??""),));
                            }),
                            ProfileLinkTile("assets/images/ic_rewards_profile.png", "Rewards", () {
                              navManager.updateNavIndex(2);
                            }),
                            ProfileLinkTile("assets/images/ic_friend_2_reward.png", "Friend\u00B2 Rewards", () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ReferFriendView(referralCode: profileSnapshot.data?.data?.profile?.referralCode, referralLink: profileSnapshot.data?.data?.profile?.referralWebUrl),));
                            }),
                            ProfileLinkTile("assets/images/ic_daily_rewards.png", "Daily Rewards", () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyRewardsView(),));
                            }),
                            ProfileLinkTile("assets/images/ic_game_profile.png", "Game", () { }),
                            ProfileLinkTile("assets/images/ic_settings_profile.png", "Setting", () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView(),));
                            }),
                          ];
                          return profileBody(profileSnapshot.data?.data);
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

  Widget profileBody(UserProfileModel? data) {
    _values = SfRangeValues(data?.profile?.nextLevelPercentage, 100);
    String? qrImage = "assets/images/qr_button_silver.png";
    String? currentThumbImage = "assets/images/ic_crown_silver.png";
    String? nextThumbImage = "assets/images/ic_crown_silver.png";
    qrImage = getThumbIcon(data?.profile?.rank??"")["qrImage"];
    currentThumbImage = getThumbIcon(data?.profile?.rank??"")["thumbImage"];
    nextThumbImage = getThumbIcon(data?.profile?.nextRank??"")["thumbImage"];
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.all(20.sp),
                child: Stack(
                  fit: StackFit.loose,
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: data?.profile?.memberCard??"", fit: BoxFit.contain,
                      placeholder: (context, url) => AspectRatio(
                        aspectRatio: 1.58,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballScale,
                          colors: [AppColors.primaryRed, AppColors.secondaryRed],
                        ),
                      ),
                      errorWidget: (context, url, error) => Image.asset("assets/images/sogo_platinum.png", fit: BoxFit.contain,),
                    ),
                    Positioned(
                      right: 0,
                      top: 30.sp,
                      child: Image.asset(qrImage??"", width: 92.w, fit: BoxFit.fitWidth,),
                    ),
                    Positioned(
                      bottom: 20.sp,
                      left: 20.sp,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data?.profile?.name??"", style: TextStyle(fontFamily: "GothamBold", color: Colors.white, fontSize: 17.sp),),
                          SizedBox(height: 10.h,),
                          Text(data?.profile?.qrcode??"", style: TextStyle(fontFamily: "GothamBook", color: Colors.white, fontSize: 21.sp),)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.sp),
              child: SfRangeSlider(
                min: 0.0,
                max: 100.0,
                interval: 1,
                showTicks: false,
                showLabels: false,
                inactiveColor: AppColors.primaryRed,
                activeColor: Colors.grey[300],
                values: _values,
                startThumbIcon: Image.asset(currentThumbImage??"assets/images/ic_thumb_silver.png"),
                endThumbIcon: Image.asset(nextThumbImage??"assets/images/ic_thumb_gold.png"),
                onChanged: (SfRangeValues newValues){
                  // setState(() {
                  //   _values = newValues;
                  // });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data?.profile?.nextLevel??"", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamRegular", fontSize: 12.sp, color: AppColors.textBlack.withOpacity(0.5)),),
                  SizedBox(height: 25.h,),
                  Row(
                    children: [
                      Image.asset(currentThumbImage??"assets/images/ic_thumb_silver.png", height: 25.sp, width: 25.sp,),
                      SizedBox(width: 15.w,),
                      Text(data?.profile?.rank??"", style: TextStyle(fontFamily: "GothamBold", fontSize: 14.sp, color: AppColors.lightBlack),)
                    ],
                  ),
                  Divider(
                    height: 40.sp, thickness: 1.sp, color: AppColors.grey.withOpacity(0.17),
                  ),
                  balanceCard(data),
                  SizedBox(height: 10.h,),
                  linksSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget balanceCard(UserProfileModel? data) {
    return Card(
      elevation: 0,
      color: const Color(0xFFEDEDED),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(height: 10.h,),
          cardTile("Point Balance", '${data?.profile?.points??""} Pts'),
          Divider(height: 20.h, color: Colors.white, thickness: 2.sp,),
          cardTile("Redeemable Points", '${data?.profile?.redeemablePoints??""} Pts'),
          Divider(height: 20.h, color: Colors.white, thickness: 2.sp,),
          cardTile("Point Value", data?.profile?.formattedPValue??""),
          Divider(height: 20.h, color: Colors.white, thickness: 2.sp,),
          cardTile("Month-End Expiring Points", '${data?.profile?.pointExpiryValue??""} Pts'),
          SizedBox(height: 10.h,),
        ],
      ),
    );
  }

  Widget cardTile(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(title, style: TextStyle(fontFamily: "GothamRegular", fontSize: 12.sp, color: const Color(0xFF3E3F3E)),),
          ),
          Expanded(
            flex: 1,
            child: Text(value, style: TextStyle(fontFamily: "GothamBold", fontSize: 12.sp, color: const Color(0xFF3E3F3E)),),
          ),
        ],
      ),
    );
  }



  Widget linksSection() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      itemBuilder: (context, index) => InkWell(
        onTap: links[index].onTap,
        child: linkTile(link: links[index]),
      ),
      separatorBuilder: (context, index) => Divider(color: const Color(0xFFEDEDED), height: 40.h, thickness: 1.sp,),
      itemCount: links.length,
    );
  }

  Widget linkTile({required ProfileLinkTile link}) {
    return Row(
      children: [
        Image.asset(link.imagePath, width: 22.sp, height: 22.sp, fit: BoxFit.contain, alignment: Alignment.center,),
        SizedBox(width: 15.w,),
        Flexible(flex: 0, child: Text(link.title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.textBlack),)),
        const Spacer(),
        Icon(Icons.arrow_forward_ios, color: AppColors.textBlack, size: 20.sp,),
      ],
    );
  }

  Map<String, String> getThumbIcon(String rank) {
    String qrImage = "";
    String thumbImage = "";
    switch(rank) {
      case "Silver": {
        qrImage = "assets/images/qr_button_silver.png";
        thumbImage = "assets/images/ic_thumb_silver.png";
        break;
      }
      case "Gold": {
        qrImage = "assets/images/qr_button_gold.png";
        thumbImage = "assets/images/ic_thumb_gold.png";
        break;
      }
      case "Platinum": {
        qrImage = "assets/images/qr_button_platinum.png";
        thumbImage = "assets/images/ic_crown_platinum.png";
        break;
      }
      default: {
        qrImage = "assets/images/qr_button_silver.png";
        thumbImage = "assets/images/ic_crown_silver.png";
        break;
      }
    }
    return {"qrImage": qrImage, "thumbImage": thumbImage};
  }
}

class ProfileLinkTile {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  ProfileLinkTile(this.imagePath, this.title, this.onTap);
}