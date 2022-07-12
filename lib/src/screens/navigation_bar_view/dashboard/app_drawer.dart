import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/managers/ui_manager/nav_bar_manager.dart';
import 'package:sogo_flutter/src/screens/customer_support/customer_support_view.dart';
import 'package:sogo_flutter/src/screens/mall_list/directory/directory_view.dart';
import 'package:sogo_flutter/src/screens/mall_list/facilities_and_services/facilities_view.dart';
import 'package:sogo_flutter/src/screens/mall_list/mall_list_view.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/settings_view.dart';

class AppDrawer extends StatelessWidget {
  final bool notNavBarItem;
  final drawerListFontStyle = TextStyle(
    color: AppColors.textBlack, fontSize: 15.sp, fontFamily: "BaiRegular"
  );

  AppDrawer({Key? key, this.notNavBarItem = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(right: Radius.circular(13)),
      child: SizedBox(
        width: 300.w,
        child: Drawer(
          child: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        listItem(imagePath: "assets/images/menu_home.png", title: "Home", context: context, onTap: (){
                          navManager.updateNavIndex(0);
                        }),
                        listItem(imagePath: "assets/images/menu_profile.png", title: "My Profile", context: context, onTap: (){
                          navManager.updateNavIndex(4);
                        }),
                        listItem(imagePath: "assets/images/menu_rewards.png", title: "Rewards", context: context, onTap: (){
                          navManager.updateNavIndex(2);
                        }),
                        listItem(imagePath: "assets/images/menu_promotions.png", title: "Promotions", context: context, onTap: (){
                          navManager.updateNavIndex(1);
                        }),
                        listItem(imagePath: "assets/images/menu_events.png", title: "Sales & Events", context: context, onTap: (){
                          navManager.updateNavIndex(3);
                        }),
                        listItem(imagePath: "assets/images/menu_directory.png", title: "Directory", context: context, onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MallListView(title: "Select Outlet", type: MallType.directory),));
                        }),
                        listItem(imagePath: "assets/images/menu_facilities.png", title: "Facilities & Services", context: context, onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MallListView(title: "Facilities & Services", type: MallType.facility,),));
                        }),
                        // listItem(imagePath: "assets/images/menu_survey.png", title: "Survey", context: context, onTap: (){}),
                        listItem(imagePath: "assets/images/menu_support.png", title: "Customer Support", context: context, onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerSupportView(),));
                        }),
                        listItem(imagePath: "assets/images/menu_settings.png", title: "Setting", context: context, onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView(),));
                        }),
                      ],
                    ),
                  ),
                  listItem(context: context, title: "Log Out", imagePath: "assets/images/menu_logout.png", showDivider: false, onTap: (){
                    authManager.logout(context);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listItem({required BuildContext context, required String title, required String imagePath, bool showDivider = true, required VoidCallback onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(title, style: drawerListFontStyle,),
          leading: Image.asset(imagePath, width: 20.w, height: 20.w, fit: BoxFit.contain, alignment: Alignment.center,),
          onTap: () {
            Navigator.pop(context);
            // Update tab to correct index
            WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
              onTap();
            });
          },
          visualDensity: VisualDensity.compact,
        ),
        if(showDivider)
          Divider(height: 1.sp, thickness: 1.sp, color: AppColors.textGrey.withOpacity(0.5)),
      ],
    );
  }
}
