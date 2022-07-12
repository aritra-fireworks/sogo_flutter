import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/managers/dashboard_manager/dashboard_manager.dart';
import 'package:sogo_flutter/src/managers/notifications_manager/push_notification_manager.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/managers/ui_manager/nav_bar_manager.dart';
import 'package:sogo_flutter/src/models/profile/dashboard_model.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/models/profile/user_profile_model.dart';
import 'package:sogo_flutter/src/screens/customer_support/about_us_view.dart';
import 'package:sogo_flutter/src/screens/customer_support/contact_us_view.dart';
import 'package:sogo_flutter/src/screens/customer_support/web_view_links.dart';
import 'package:sogo_flutter/src/screens/member_privileges/member_privileges_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/dashboard/qr_details.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/events/event_details.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/notifications/notifications_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/daily_rewards/daily_rewards.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/refer_friend_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/promotions/promotion_details.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/reward_details.dart';
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/carousel_view.dart';
import 'package:sogo_flutter/src/widgets/promotions_card_view.dart';
import 'package:sogo_flutter/src/widgets/rewards_card_view.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Mall? selectedMall;

  @override
  void initState() {
    super.initState();
    dashboardManager.getMallList().then((value) {
      if(value?.status == "success"){
        String mallId = value!.malls!.firstWhere((element) => element.defaultMall == true).id.toString();
        ApplicationGlobal.selectedMall ??= value.malls!.firstWhere((element) => element.defaultMall == true);
        selectedMall = ApplicationGlobal.selectedMall;
        dashboardManager.getDashboard(mallId: mallId).then((value) => profileManager.getProfile().then((value) {
          notificationManager.init(context);
        }));
        profileManager.getReferralInfo();
      } else if(value?.status == "fail" || value?.status == "Session expired, please get new token"){
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          authManager.logout(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            "assets/images/ic_menu.png",
            width: 25,
            fit: BoxFit.fitWidth,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
        ),
        centerTitle: true,
        title: StreamBuilder<ApiResponse<MallListModel>?>(
            stream: dashboardManager.mallList,
            builder: (BuildContext context, AsyncSnapshot<ApiResponse<MallListModel>?> mallListSnapshot) {
              if (mallListSnapshot.hasData) {
                switch (mallListSnapshot.data!.status) {
                  case Status.LOADING:
                    debugPrint('Loading');
                    return const SizedBox();
                  case Status.COMPLETED:
                    debugPrint('Mall List Loaded');

                    return InkWell(
                      onTap: (){
                        showDropdown(context: context, malls: mallListSnapshot.data?.data?.malls ?? [], onTap: (selected){
                          setState(() {
                            selectedMall = selected;
                            ApplicationGlobal.selectedMall = selected;
                            dashboardManager.getDashboard(mallId: selectedMall!.id!);
                          });
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(selectedMall!.mallLogoInverse!, width: 80.w, fit: BoxFit.fitWidth,),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    );
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
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsView(),));
            },
            icon: const Icon(Icons.notifications_none, color: Colors.white,),
          ),
        ],
      ),
      body: StreamBuilder<ApiResponse<DashboardModel>?>(
          stream: dashboardManager.dashboard,
          builder: (BuildContext context, AsyncSnapshot<ApiResponse<DashboardModel>?> dashboardSnapshot) {
            if (dashboardSnapshot.hasData) {
              switch (dashboardSnapshot.data!.status) {
                case Status.LOADING:
                  debugPrint('Loading');
                  return Center(child: CircularProgressIndicator(color: AppColors.primaryRed,));
                case Status.COMPLETED:
                  debugPrint('Dashboard Loaded');
                  return dashboardBody(dashboardSnapshot.data?.data, context);
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
    );
  }

  Widget dashboardBody(DashboardModel? dashboardData, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header welcome panel
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 15.h, bottom: 15.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome to SOGO", style: TextStyle(fontFamily: "GothamMedium", fontSize: 12.sp, height: 1.8, color: AppColors.textBlack.withOpacity(0.5)),),
                      Text(dashboardData?.custname??"User", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, ),),
                    ],
                  ),
                ),
                StreamBuilder<ApiResponse<UserProfileModel>?>(
                    stream: profileManager.profile,
                    builder: (BuildContext context, AsyncSnapshot<ApiResponse<UserProfileModel>?> profileSnapshot) {
                      if (profileSnapshot.hasData) {
                        switch (profileSnapshot.data!.status) {
                          case Status.LOADING:
                            debugPrint('Loading');
                            return Center(child: CircularProgressIndicator(color: AppColors.primaryRed,));
                          case Status.COMPLETED:
                            debugPrint('Dashboard Loaded');
                            if(profileSnapshot.data?.data?.status == "fail" || profileSnapshot.data?.data?.status == "Session expired, please get new token"){
                              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                                authManager.logout(context);
                              });
                            }
                            String qrImage = "assets/images/qr_button_silver.png";
                            switch(profileSnapshot.data?.data?.profile?.rank??"") {
                              case "Silver": {
                                qrImage = "assets/images/qr_button_silver.png";
                                break;
                              }
                              case "Gold": {
                                qrImage = "assets/images/qr_button_gold.png";
                                break;
                              }
                              case "Platinum": {
                                qrImage = "assets/images/qr_button_platinum.png";
                                break;
                              }
                              default: {
                                qrImage = "assets/images/qr_button_silver.png";
                                break;
                              }
                            }
                            return InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: (){
                                showQr(context: context);
                              },
                              child: Transform.translate(
                                offset: Offset(10.sp, 0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      qrImage, width: 120.w, fit: BoxFit.fitWidth,
                                      color: Colors.black.withOpacity(0.25),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.sp),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 6.0,
                                            sigmaY: 6.0,
                                          ),
                                          child: Image.asset(
                                            qrImage, width: 120.w, fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
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
              ],
            ),
          ),

          // Top Banners
          BannerCarouselView(slideItems: dashboardData?.bannerNews?.map((e) => InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PromotionDetails(promotionId: e.id??""),));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: BlurBgRoundedImage(imagePath: e.featuredImg!,),
            ),
          ),).toList() ?? []),


          // Important links
          StreamBuilder<ApiResponse<UserProfileModel>?>(
              stream: profileManager.profile,
              builder: (BuildContext context, AsyncSnapshot<ApiResponse<UserProfileModel>?> profileSnapshot) {
                if (profileSnapshot.hasData) {
                  switch (profileSnapshot.data!.status) {
                    case Status.LOADING:
                      debugPrint('Loading');
                      return Container(height: 260.h, alignment: Alignment.center, child: CircularProgressIndicator(color: AppColors.primaryRed,));
                    case Status.COMPLETED:
                      debugPrint('Dashboard Loaded');
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.w, top: 30.h, bottom: 10.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                iconTile(imagePath: "assets/images/dash_rewards.png", title: "Redeem\nRewards", onTap: (){
                                  navManager.updateNavIndex(2);
                                }),
                                iconTile(imagePath: "assets/images/dash_check_points.png", title: "Check\nPoints", onTap: (){
                                  navManager.updateNavIndex(4);
                                }),
                                iconTile(imagePath: "assets/images/dash_friend_rewards.png", title: "Friend\u00B2\nRewards", onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReferFriendView(referralCode: profileSnapshot.data?.data?.profile?.referralCode, referralLink: profileSnapshot.data?.data?.profile?.referralWebUrl),));
                                }),
                                iconTile(imagePath: "assets/images/dash_member_privilege.png", title: "Member\nPrivileges", onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MemberPrivilegesView()));
                                }),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.w, top: 10.h, bottom: 20.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                iconTile(imagePath: "assets/images/dash_game.png", title: "Play\nGame", onTap: (){}),
                                iconTile(imagePath: "assets/images/dash_daily_rewards.png", title: "Daily\nRewards", onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DailyRewardsView(),));
                                }),
                                iconTile(imagePath: "assets/images/dash_promotions.png", title: "In-Store\nPromo", onTap: (){
                                  navManager.updateNavIndex(1);
                                }),
                                iconTile(imagePath: "assets/images/dash_shop_online.png", title: "Shop\nOnline", onTap: () async {
                                  if (!await launchUrl(Uri.parse("https://www.sogo.com.my/"))) {
                                    AppUtils.showMessage(context: context, title: "Error!", message: "Could not launch https://www.sogo.com.my/");
                                  }
                                }),
                              ],
                            ),
                          ),
                        ],
                      );
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

          // Rewards
          rewards(dashboardData?.rewards),
          events(dashboardData?.events),
          promotions(dashboardData?.promotions),
          footerLinks(context),
        ],
      ),
    );
  }

  Widget iconTile({required String imagePath, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 94.w,
        child: Column(
          children: [
            Image.asset(imagePath, width: 53.sp, height: 53.sp,),
            const SizedBox(height: 10,),
            Text(title, textAlign: TextAlign.center, overflow: TextOverflow.visible, style: TextStyle(fontFamily: "GothamMedium", color: AppColors.primaryRed, fontSize: 10.sp),)
          ],
        ),
      ),
    );
  }

  Widget rewards(List<HotDeal>? rewards) {
    if(rewards != null && rewards.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Rewards", style: TextStyle(color: AppColors.primaryRed, fontSize: 18.sp, fontFamily: "GothamBold"),),
                InkWell(
                  onTap: (){
                    navManager.updateNavIndex(2);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("View All", style: TextStyle(color: Colors.black, fontSize: 10.sp, fontFamily: "GothamBook"),),
                      SizedBox(width: 5.w,),
                      Icon(Icons.arrow_forward_ios_outlined, color: Colors.black, size: 10.sp,),
                    ],
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rewards.length,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RewardDetails(rewardId: rewards[index].id??"0"),));
                  },
                  child: RewardsCard(reward: rewards[index], locationIcon: selectedMall?.mallIconWhite??""),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget events(List<EventItem>? events) {
    if(events != null && events.isNotEmpty) {
      return Container(
        height: 300.h,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/footer_bg.png"), fit: BoxFit.fill, alignment: Alignment.centerRight),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sales & Events", style: TextStyle(fontFamily: "GothamBold", color: Colors.white, fontSize: 18.sp),),
                  InkWell(
                    onTap: (){
                      navManager.updateNavIndex(3);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("View All", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontFamily: "GothamBook"),),
                        SizedBox(width: 5.w,),
                        Icon(Icons.arrow_forward_ios_outlined, color: Colors.white, size: 10.sp,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: events.length,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 7.w),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetails(eventId: events[index].id??"0"),));
                    },
                    child: SizedBox(
                      width: 280.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: BlurBgRoundedImage(imagePath: events[index].img??"")),
                          SizedBox(height: 10.h,),
                          Text(events[index].name??"", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GothamBold", fontSize: 12.sp, color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();

  }

  Widget promotions(List<Promotion>? promotions) {
    if(promotions != null && promotions.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Promotions", style: TextStyle(color: AppColors.primaryRed, fontSize: 18.sp, fontFamily: "GothamBold"),),
                InkWell(
                  onTap: (){
                    navManager.updateNavIndex(1);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("View All", style: TextStyle(color: Colors.black, fontSize: 10.sp, fontFamily: "GothamBook"),),
                      SizedBox(width: 5.w,),
                      Icon(Icons.arrow_forward_ios_outlined, color: Colors.black, size: 10.sp,),
                    ],
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: promotions.length,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PromotionDetails(promotionId: promotions[index].id??""),));
                  },
                  child: PromotionsCard(promotion: promotions[index]),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  List<UsefulLink> usefulLinks = [
    UsefulLink("assets/images/ic_about_us.png", "About Us", const AboutUsView()),
    UsefulLink("assets/images/ic_contact_us.png", "Contact Us", const ContactUsView()),
    UsefulLink("assets/images/ic_faqs.png", "FAQs", WebViewLinks(webViewUrl: "${UrlController.kUserBaseURL}/membership/faqs.php?app_view=1", title: "FAQs")),
    UsefulLink("assets/images/ic_terms_conditions.png", "Terms & Condition", WebViewLinks(webViewUrl: "${UrlController.kUserBaseURL}/membership/tnc.php?app_view=1", title: "Terms & Conditions")),
    UsefulLink("assets/images/ic_privacy_policy.png", "Privacy Policy", WebViewLinks(webViewUrl: "${UrlController.kUserBaseURL}/membership/privacy_policy.php?app_view=1", title: "Privacy Policy")),
  ];

  Widget footerLinks(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/footer_bg.png"), fit: BoxFit.fill, alignment: Alignment.centerRight),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h,),
          Text("Useful Links", style: TextStyle(fontFamily: "GothamBold", fontSize: 18.sp, color: Colors.white),),
          Divider(height: 40.h, thickness: 1.sp, color: Colors.white.withOpacity(0.29)),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 30.h),
            itemCount: usefulLinks.length,
            itemBuilder: (context, index) => footerTiles(iconPath: usefulLinks[index].iconPath, title: usefulLinks[index].title, onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => usefulLinks[index].page,));
            }),
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 40.h, thickness: 1.sp, color: Colors.white.withOpacity(0.29));
            },
          ),
        ],
      ),
    );
  }
  
  Widget footerTiles({required String iconPath, required String title, required VoidCallback onTap}){
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(iconPath, height: 15.5.sp, width: 17.sp, fit: BoxFit.contain, alignment: Alignment.center,),
          SizedBox(width: 10.w,),
          Text(title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 16.sp, color: const Color(0xFFFEFAFB)),),
        ],
      ),
    );
  }

  Widget dropdownView({required List<Mall> malls, required Function(Mall) onTap}) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          margin: const EdgeInsets.only(top: 55),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("Select Outlet", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamBold", fontSize: 18.sp, color: Colors.black),),
                  ),
                  ...malls.map((e) => InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      onTap(e);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(height: 1, thickness: 1, color: Colors.grey, indent: 20, endIndent: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(e.name!, textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamMedium", fontSize: 20.sp, color: AppColors.textBlack),),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
        ),
        ),
    );
  }

  void showDropdown({required BuildContext context, required List<Mall> malls, required Function(Mall) onTap}) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.topCenter,
          child: dropdownView(malls: malls, onTap: onTap),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void showQr({required BuildContext context}) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return const Align(
          alignment: Alignment.center,
          child: QrDetails(),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}

class BlurBgRoundedImage extends StatelessWidget {
  final String imagePath;
  const BlurBgRoundedImage({
    Key? key, required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Stack(
        children: [
          SizedBox.expand(
            child: CachedNetworkImage(
              imageUrl: imagePath, fit: BoxFit.cover,
              placeholder: (context, url) => LoadingIndicator(
                indicatorType: Indicator.ballScale,
                colors: [AppColors.primaryRed, AppColors.secondaryRed],
              ),
              errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", fit: BoxFit.cover,),
            ),
          ),
          ClipRRect( // Clip it cleanly.
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: imagePath, fit: BoxFit.fitHeight,
                  placeholder: (context, url) => LoadingIndicator(
                    indicatorType: Indicator.ballScale,
                    colors: [AppColors.primaryRed, AppColors.secondaryRed],
                  ),
                  errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class UsefulLink {
  final String iconPath;
  final String title;
  final Widget page;

  UsefulLink(this.iconPath, this.title, this.page);
}

