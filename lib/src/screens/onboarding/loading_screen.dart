import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/constants/preferences.dart';
import 'package:sogo_flutter/src/models/auth/login_profile_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/nav_bar_view.dart';
import 'package:sogo_flutter/src/screens/onboarding/onboarding_views.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    DeviceInfo.getDeviceInfo();
    checkLoggedIn();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      FlutterNativeSplash.remove();
    });
  }

  checkLoggedIn() async {
    String? token = await preferences.getValueByKey(preferences.accessToken);
    String? profile = await preferences.getValueByKey(preferences.profile);
    if(token != null && profile != null){
      ApplicationGlobal.bearerToken = token;
      ApplicationGlobal.profile = LoginProfileModel.fromJson(jsonDecode(profile));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBarView(),));
    } else {
      Future.delayed(const Duration(milliseconds: 1000)).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(settings: const RouteSettings(name: "/Onboarding"), builder: (context) => const OnboardingViews(),)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/splash_screen.png", fit: BoxFit.cover);
  }
}
