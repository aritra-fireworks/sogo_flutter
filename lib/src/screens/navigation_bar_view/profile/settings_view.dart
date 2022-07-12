import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/models/profile/notification_settings_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/delete_account_view.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  String appVersion = "";

  bool? newsNotifications;
  bool? rightHereNotifications;
  bool? generalNotifications;

  @override
  void initState() {
    super.initState();
    profileManager.getNotificationSettings();
    PackageInfo.fromPlatform().then((packageInfo) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        setState(() {
          appVersion = "${packageInfo.version}-${packageInfo.buildNumber}";
        });
      });
    });
  }


  @override
  Widget build(BuildContext buildContext) {
    return KeyboardDismissWrapper(
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
                title: Text("Settings", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
              ),
              body: StreamBuilder<ApiResponse<NotificationSettingsModel>?>(
                  stream: profileManager.notificationSettings,
                  builder: (BuildContext streamContext, AsyncSnapshot<ApiResponse<NotificationSettingsModel>?> snapshot) {
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
                          return settingsBody(buildContext, snapshot.data?.data);
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

  Widget settingsBody(BuildContext context, NotificationSettingsModel? data) {
    Size size = MediaQuery.of(context).size;
    if(data != null){
      newsNotifications ??= data.news == "1" ? true : false;
      rightHereNotifications ??= data.rightHere == "1" ? true : false;
      generalNotifications ??= data.general == "1" ? true : false;
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: SizedBox(
          height: size.height - 85 - 30.h,
          child: Column(
            children: [
              switchTile(
                title: "Allow In-App Push Notifications",
                subtitle: "Update on Sales, Promotions, and Member Privileges",
                state: newsNotifications??true,
                onTap: (value) {
                  setState(() {
                    newsNotifications = value;
                  });
                  profileManager.updateNotificationSettings(setting: data?.setting??"", news: (newsNotifications??true) ? "1" : "0", general: (generalNotifications??true) ? "1" : "0", rightHere: (rightHereNotifications??true) ? "1" : "0").then((value) => profileManager.getNotificationSettings(withLoading: false));
                }
              ),
              switchTile(
                title: "Allow Proximity Messages",
                subtitle: "Receive real-time location based promotion info",
                state: rightHereNotifications??true,
                onTap: (value) {
                  setState(() {
                    rightHereNotifications = value;
                  });
                  profileManager.updateNotificationSettings(setting: data?.setting??"", news: (newsNotifications??true) ? "1" : "0", general: (generalNotifications??true) ? "1" : "0", rightHere: (rightHereNotifications??true) ? "1" : "0").then((value) => profileManager.getNotificationSettings(withLoading: false));
                }
              ),
              switchTile(
                title: "Allow General Notifications",
                subtitle: "App updates and what's new in store",
                state: generalNotifications??true,
                onTap: (value) {
                  setState(() {
                    generalNotifications = value;
                  });
                  profileManager.updateNotificationSettings(setting: data?.setting??"", news: (newsNotifications??true) ? "1" : "0", general: (generalNotifications??true) ? "1" : "0", rightHere: (rightHereNotifications??true) ? "1" : "0").then((value) => profileManager.getNotificationSettings(withLoading: false));
                }
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DeleteAccountView(),));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delete Account", style: TextStyle(color: AppColors.primaryRed, fontSize: 15.sp, fontFamily: "GothamMedium"),),
                      Icon(Icons.arrow_forward_ios, size: 18.sp,),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Text("Version: $appVersion", style: TextStyle(fontFamily: "GothamRegular", fontSize: 13.sp, color: AppColors.lightBlack),),
              SizedBox(height: 30.h,),
            ],
          ),
        ),
      ),
    );
  }

  Widget switchTile({required String title, required String subtitle, required bool state, required Function(bool) onTap}) {
    return InkWell(
      onTap: (){
        onTap(!state);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: const Color(0xFF636363)),),
                  Text(subtitle, style: TextStyle(fontFamily: "GothamRegular", fontSize: 13.sp, color: const Color(0xFF636363)),),
                ],
              ),
            ),
            SizedBox(width: 20.w,),
            IgnorePointer(
              child: FlutterSwitch(
                width: 50.w,
                height: 25.h,
                valueFontSize: 12.sp,
                activeTextFontWeight: FontWeight.w400,
                inactiveTextFontWeight: FontWeight.w400,
                toggleSize: 20.sp,
                activeIcon: Container(
                  color: Colors.white,
                  child: const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.menu),
                  ),
                ),
                inactiveIcon: Container(
                  color: Colors.white,
                  child: const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.menu),
                  ),
                ),
                value: state,
                borderRadius: 20.0,
                activeColor: AppColors.primaryRed,
                padding: 2.sp,
                showOnOff: true,
                onToggle: (val) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
