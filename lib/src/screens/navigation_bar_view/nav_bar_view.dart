

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/ui_manager/nav_bar_manager.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/dashboard/app_drawer.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/dashboard/dashboard_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/profile_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/promotions/promotions_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/rewards_view.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/events/events_view.dart';

class NavBarView extends StatefulWidget {
  final int initialIndex;
  const NavBarView({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _NavBarViewState createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {

  int _tabIndex = 0;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    // getTokenFromLocalStorage();
    _tabIndex = widget.initialIndex;
    _children = const [
      DashboardView(),
      PromotionsView(),
      RewardsView(),
      EventsView(),
      ProfileView(),
    ];
  }

  // getTokenFromLocalStorage() async {
  //   // await preferences.deleteAllValues();
  //   String? token = await preferences.getValueByKey(preferences.bearerToken);
  //   if(token != null && token.isNotEmpty){
  //     ApplicationGlobal.bearerToken = token;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        progressIndicator: LoadingIndicator(
          indicatorType: Indicator.ballScale,
          colors: [AppColors.primaryRed, AppColors.secondaryRed],
        ),
        inAsyncCall: false,
        child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              onWillPop: () async => false,
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
                  child: bottomNavigation(context)),
            )));
  }

  Widget bottomNavigation(BuildContext context) {
    return StreamBuilder<int?>(
      stream: navManager.navIndexStream,
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null){
          _tabIndex = snapshot.data!;
          navManager.reset();
        }
        return Scaffold(
          drawer: AppDrawer(),
          body: _children[_tabIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _tabIndex,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.secondaryRed,
            iconSize: 24.sp,
            unselectedItemColor: AppColors.secondaryRed.withOpacity(0.5),
            selectedLabelStyle: TextStyle(color: Colors.red, fontSize: 11.sp, fontFamily: "GothamMedium"),
            unselectedLabelStyle: TextStyle(color: Colors.red, fontSize: 11.sp, fontFamily: "GothamMedium"),
            onTap: (value) async {
              setState(() {
                _tabIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: navIcon(index: 0, imagePath: 'assets/images/ic_home.png'),
              ),
              BottomNavigationBarItem(
                label: "Promotions",
                icon: navIcon(index: 1, imagePath: 'assets/images/ic_promotions.png'),
              ),
              BottomNavigationBarItem(
                label:"Rewards",
                icon: navIcon(index: 2, imagePath: 'assets/images/ic_rewards.png'),
              ),
              BottomNavigationBarItem(
                label: "Events",
                icon: navIcon(index: 3, imagePath: 'assets/images/ic_events.png'),
              ),
              BottomNavigationBarItem(
                label: "Profile",
                icon: navIcon(index: 4, imagePath: 'assets/images/ic_profile.png'),
              ),
            ],
          ),
        );
      }
    );
  }

  Container navIcon({required int index, required String imagePath}) {
    return Container(
            height: 34.sp,
            width: 38.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: _tabIndex == index ? AppColors.secondaryRed : Colors.transparent,
            ),
            margin: EdgeInsets.only(bottom: 5.sp),
            alignment: Alignment.center,
            child: Image.asset(imagePath, height: 34.sp, color: _tabIndex == index ? Colors.white : AppColors.secondaryRed.withOpacity(0.5),),
          );
  }
}
