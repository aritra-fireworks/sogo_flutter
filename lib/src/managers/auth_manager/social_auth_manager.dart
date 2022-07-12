import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/constants/preferences.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/auth/login_profile_model.dart';
import 'package:sogo_flutter/src/services/auth_service/auth_service.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:http/http.dart' as http;

class SocialAuthManager {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],);

  Future<LoginProfileModel?> googleSignIn({bool newSignIn = false}) async {
    Map<String, dynamic>? result;
    try {
      if(newSignIn) {
        await _googleSignIn.signOut();
      }
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        log('Access token: ${googleSignInAuthentication.accessToken}');
        List<String> name = googleSignInAccount.displayName?.split(" ") ?? [];
        if(name.isNotEmpty){
          ApplicationGlobal.firstName = name.first;
          if(name.length > 1){
            name.removeAt(0);
            ApplicationGlobal.lastName = name.join(" ");
          }
        }
        ApplicationGlobal.email = googleSignInAccount.email;
        ApplicationGlobal.socialToken = googleSignInAccount.id;
        ApplicationGlobal.socialType = "google";
        Map params = {
          "email": googleSignInAccount.email,
          "socialmediatype": ApplicationGlobal.socialType,
          "socialmediatoken": ApplicationGlobal.socialToken,
          "mercid": "44",
          "date": SecretCode.getDate(),
          "vc": SecretCode.getVCKey(),
          "os": DeviceInfo.deviceOS,
          "phonename": DeviceInfo.deviceMake,
          "phonetype": "Phone",
          "lang": "en",
          "deviceid": DeviceInfo.deviceUid,
          "devicetype": DeviceInfo.deviceType,
        };
        result = await AuthService.login(params);

      } else {
        AppUtils.showToast('Error: Google login failed. Try again.');
      }
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      LoginProfileModel loginResponse = LoginProfileModel.fromJson(result);
      ApplicationGlobal.profile = loginResponse;
      ApplicationGlobal.bearerToken = loginResponse.token??"";
      if(loginResponse.token != null) {
        preferences.setValueByKey(preferences.accessToken, loginResponse.token!);
      }
      preferences.setValueByKey(preferences.profile, jsonEncode(loginResponse.toJson()));
      return loginResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<LoginProfileModel?> facebookSignIn({bool newSignIn = false}) async {
    dynamic result;
    try{
      if(newSignIn) {
        await FacebookAuth.instance.logOut();
      }
      final LoginResult fbrLoginResult = await FacebookAuth.instance.login(); // by default we request the email and the public profile
      if (fbrLoginResult.status == LoginStatus.success) {
        // you are logged
        final AccessToken? accessToken = fbrLoginResult.accessToken;
        debugPrint('https://graph.facebook.com/v13.0/me?fields=id,name,email&access_token=${accessToken?.token}');
        final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v13.0/me?fields=id,name,email&access_token=${accessToken?.token}'));
        final fbProfile = json.decode(graphResponse.body);
        debugPrint(fbProfile.toString());
        List<String> name = fbProfile['name']?.split(" ") ?? [];
        if(name.isNotEmpty){
          ApplicationGlobal.firstName = name.first;
          if(name.length > 1){
            name.removeAt(0);
            ApplicationGlobal.lastName = name.join(" ");
          }
        }
        ApplicationGlobal.email = fbProfile['email'];
        ApplicationGlobal.socialToken = accessToken?.token;
        ApplicationGlobal.socialType = "facebook";
        try{
          Map params = {
            "email": fbProfile['email'],
            "socialmediatype": "google",
            "socialmediatoken": accessToken?.token,
            "mercid": "44",
            "date": SecretCode.getDate(),
            "vc": SecretCode.getVCKey(),
            "os": DeviceInfo.deviceOS,
            "phonename": DeviceInfo.deviceMake,
            "phonetype": "Phone",
            "lang": "en",
            "deviceid": DeviceInfo.deviceUid,
            "devicetype": DeviceInfo.deviceType,
          };
          result = await AuthService.login(params);
        }catch(e){
          AppUtils.showToast('Error: $e');
          debugPrint('Error: $e');
        }
        if (result != null){
          debugPrint(result.toString());
          LoginProfileModel loginResponse = LoginProfileModel.fromJson(result);
          ApplicationGlobal.profile = loginResponse;
          ApplicationGlobal.bearerToken = loginResponse.token??"";
          if(loginResponse.token != null) {
            preferences.setValueByKey(preferences.accessToken, loginResponse.token!);
          }
          preferences.setValueByKey(preferences.profile, jsonEncode(loginResponse.toJson()));
          return loginResponse;
        }
      } else {
        debugPrint("${fbrLoginResult.status}");
        debugPrint("${fbrLoginResult.message}");
        AppUtils.showToast('Facebook login failed! Please try after sometime.');
      }
    } catch(e) {
      debugPrint('Facebook login failed! Please try after sometime. ${e.toString()}');
      AppUtils.showToast('Facebook login failed! Please try after sometime. ${e.toString()}');
    }

    return null;
  }
}

final SocialAuthManager socialAuthManager = SocialAuthManager();