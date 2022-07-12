import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/constants/preferences.dart';
import 'package:sogo_flutter/src/managers/auth_manager/social_auth_manager.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/auth/check_migrate_user_response.dart';
import 'package:sogo_flutter/src/models/auth/checkout_session_model.dart';
import 'package:sogo_flutter/src/models/auth/migration_data_model.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/models/auth/login_profile_model.dart';
import 'package:sogo_flutter/src/models/auth/points_details_model.dart';
import 'package:sogo_flutter/src/models/auth/register_response.dart';
import 'package:sogo_flutter/src/models/auth/states_model.dart';
import 'package:sogo_flutter/src/screens/auth/auth_screen.dart';
import 'package:sogo_flutter/src/services/auth_service/auth_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class AuthManager {

  final _profileController = BehaviorSubject<ApiResponse<LoginProfileModel>?>();
  Stream<ApiResponse<LoginProfileModel>?> get profileData => _profileController.stream;

  final _pointsDetailsController = BehaviorSubject<ApiResponse<PointsDetailsModel>?>();
  Stream<ApiResponse<PointsDetailsModel>?> get pointsDetails => _pointsDetailsController.stream;

  final _statesListController = BehaviorSubject<ApiResponse<StatesModel>?>();
  Stream<ApiResponse<StatesModel>?> get statesList => _statesListController.stream;

  final _migratedUserDataController = BehaviorSubject<ApiResponse<MigrationDataModel>?>();
  Stream<ApiResponse<MigrationDataModel>?> get migratedUserData => _migratedUserDataController.stream;

  Future<LoginProfileModel?> login({required String email, required String password}) async {
    _profileController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "email": email,
        "password": password,
        "phone": "",
        "phone_country": "",
        "nric": "",
        "socialmediatype": "",
        "socialmediatoken": "",
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
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _profileController.sink.add(null);
    }
    if (result != null) {
      debugPrint(result.toString());
      LoginProfileModel loginResponse = LoginProfileModel.fromJson(result);
      _profileController.sink.add(ApiResponse.completed(loginResponse));
      ApplicationGlobal.profile = loginResponse;
      ApplicationGlobal.bearerToken = loginResponse.token??"";
      if(loginResponse.token != null) {
        preferences.setValueByKey(preferences.accessToken, loginResponse.token!);
      }
      preferences.setValueByKey(preferences.profile, jsonEncode(loginResponse.toJson()));
      return loginResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _profileController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<PointsDetailsModel?> getPointsDetails() async {
    _pointsDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
      };
      result = await AuthService.pointsDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _pointsDetailsController.sink.add(null);
    }
    if (result != null) {
      debugPrint(result.toString());
      PointsDetailsModel checkEmailResponse = PointsDetailsModel.fromJson(result);
      _pointsDetailsController.sink.add(ApiResponse.completed(checkEmailResponse));
      return checkEmailResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _pointsDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<CommonResponseModel?> checkEmail({required String email}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "email": email,
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
      };
      result = await AuthService.checkEmail(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CommonResponseModel checkEmailResponse = CommonResponseModel.fromJson(result);
      return checkEmailResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<StatesModel?> getStatesList({bool withoutToken = false}) async {
    _statesListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "sectoken": ApplicationGlobal.bearerToken,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
      };
      if(withoutToken){
        params = {
          "date": SecretCode.getDate(),
          "vc": SecretCode.getVCKey(),
          "os": DeviceInfo.deviceOS,
          "phonename": DeviceInfo.deviceMake,
          "phonetype": "Phone",
          "lang": "en",
          "deviceid": DeviceInfo.deviceUid,
          "devicetype": DeviceInfo.deviceType,
        };
      }
      result = await AuthService.statesList(params, withoutToken);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _statesListController.sink.add(null);
    }
    if (result != null) {
      debugPrint(result.toString());
      StatesModel statesListResponse = StatesModel.fromJson(result);
      _statesListController.sink.add(ApiResponse.completed(statesListResponse));
      return statesListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _statesListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<CheckSessionResponse?> checkSession({required String password}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "custid": ApplicationGlobal.profile?.custid??"",
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
      result = await AuthService.checkSession(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CheckSessionResponse loginResponse = CheckSessionResponse.fromJson(result);
      return loginResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<CommonResponseModel?> sendOtp({required PhoneNumber number}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "phone": number.phoneNumber?.replaceAll(number.dialCode ?? "+", ""),
        "phone_country": number.dialCode?.replaceAll("+", ""),
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
      result = await AuthService.sendOtp(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CommonResponseModel sendOtpResponse = CommonResponseModel.fromJson(result);
      return sendOtpResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<CommonResponseModel?> verifyOtp({required PhoneNumber number, required String otp}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "custid": ApplicationGlobal.profile?.custid??"",
        "phone": number.phoneNumber?.replaceAll(number.dialCode ?? "+", ""),
        "phone_country": number.dialCode?.replaceAll("+", ""),
        "otp_pin": otp,
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
      result = await AuthService.verifyOtp(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CommonResponseModel verifyOtpResponse = CommonResponseModel.fromJson(result);
      return verifyOtpResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<RegisterResponseModel?> register() async {
    Map<String, dynamic>? result;
    Map params = {};
    try {
      if(ApplicationGlobal.phone == null){
        params = {
          "member_card_no":ApplicationGlobal.memberCardNo??"",
          "migrate": ApplicationGlobal.migrate.toString(),
          "referral_code": ApplicationGlobal.referralCode ?? "",
          "promo": ApplicationGlobal.newsSubscription.toString(),
          "email": ApplicationGlobal.email,
          "fname": ApplicationGlobal.firstName,
          "lname": ApplicationGlobal.lastName,
          "socialmediatype": ApplicationGlobal.socialType??"",
          "socialmediatoken": ApplicationGlobal.socialToken??"",
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
      } else {
        params = {
          "member_card_no":ApplicationGlobal.memberCardNo??"",
          "migrate": ApplicationGlobal.migrate.toString(),
          "referral_code": ApplicationGlobal.referralCode ?? "",
          "promo": ApplicationGlobal.newsSubscription.toString(),
          "email": ApplicationGlobal.email,
          "pass": ApplicationGlobal.password,
          "title": "",
          "fname": ApplicationGlobal.firstName,
          "lname": ApplicationGlobal.lastName,
          "phone": ApplicationGlobal.phone?.phoneNumber?.replaceAll(ApplicationGlobal.phone?.dialCode ?? "+", "") ?? "",
          "phone_country": ApplicationGlobal.phone?.dialCode?.replaceAll("+", "") ?? "",
          "socialmediatype": "",
          "socialmediatoken": "",
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
      }
      result = await AuthService.signUp(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      RegisterResponseModel registerResponse = RegisterResponseModel.fromJson(result);
      if(registerResponse.status == "success") {
        if(ApplicationGlobal.socialToken != null){
          socialAuthManager.googleSignIn();
        } else {
          login(email: ApplicationGlobal.email??"aritra@fireworks.my", password: ApplicationGlobal.password??"Aritra@2022");
        }
        ApplicationGlobal.custId = registerResponse.custid?.toString();
      }
      return registerResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<CheckMigrateUserModel?> checkMigrateUser({required String type, required String email}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "type": type,
        "email": email,
      };
      result = await AuthService.checkMigrateUser(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CheckMigrateUserModel registerResponse = CheckMigrateUserModel.fromJson(result);
      return registerResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<MigrationDataModel?> getMigratedUserData({required Map params}) async {
    _migratedUserDataController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      result = await AuthService.getMigratedUserData(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _migratedUserDataController.sink.add(null);
    }
    if (result != null) {
      debugPrint(result.toString());
      MigrationDataModel response = MigrationDataModel.fromJson(result);
      _migratedUserDataController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _migratedUserDataController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }


  Future<CommonResponseModel?> changePassword({required String oldPassword, required String newPassword}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "oldpass": oldPassword,
        "newpass": newPassword,
        "custid": ApplicationGlobal.profile?.custid??"",
        "mercid": "44",
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "sectoken": ApplicationGlobal.bearerToken,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
      };
      result = await AuthService.changePassword(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CommonResponseModel registerResponse = CommonResponseModel.fromJson(result);
      return registerResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<CommonResponseModel?> resetPassword({String? email, String? phone, String? phoneCountry}) async {
    Map<String, dynamic>? result;
    Map params = {};
    try {
      if(email != null && phone == null && phoneCountry == null){
        params = {
          "email": email,
          "date": SecretCode.getDate(),
          "vc": SecretCode.getVCKey(),
          "os": DeviceInfo.deviceOS,
          "sectoken": ApplicationGlobal.bearerToken,
          "phonename": DeviceInfo.deviceMake,
          "phonetype": "Phone",
          "lang": "en",
          "deviceid": DeviceInfo.deviceUid,
          "devicetype": DeviceInfo.deviceType,
        };
      } else if(phone != null && phoneCountry != null) {
        params = {
          "phone": phone,
          "phone_country": phoneCountry,
          "date": SecretCode.getDate(),
          "vc": SecretCode.getVCKey(),
          "os": DeviceInfo.deviceOS,
          "sectoken": ApplicationGlobal.bearerToken,
          "phonename": DeviceInfo.deviceMake,
          "phonetype": "Phone",
          "lang": "en",
          "deviceid": DeviceInfo.deviceUid,
          "devicetype": DeviceInfo.deviceType,
        };
      }
      result = await AuthService.resetPassword(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CommonResponseModel registerResponse = CommonResponseModel.fromJson(result);
      return registerResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<CommonResponseModel?> migrationResetPassword({required String email, required String type}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "email": email,
        "type": type,
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "sectoken": ApplicationGlobal.bearerToken,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
      };
      result = await AuthService.migrationResetPassword(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CommonResponseModel registerResponse = CommonResponseModel.fromJson(result);
      return registerResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }


  Future<CommonResponseModel?> addDeviceToken({required String token}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "token": token,
        "custid": ApplicationGlobal.profile?.custid??"",
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "sectoken": ApplicationGlobal.bearerToken,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
      };
      result = await AuthService.addDeviceToken(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      debugPrint(result.toString());
      CommonResponseModel registerResponse = CommonResponseModel.fromJson(result);
      return registerResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }
  
  List<IdType> idList = [
    IdType(1, "NRIC"),
    IdType(0, "Passport"),
    IdType(2, "Police/Military ID"),
  ];
  
  List<GenderType> genderList = [
    GenderType(1, "Male"),
    GenderType(2, "Female"),
  ];


  logout(BuildContext context) {
    preferences.deleteAllValues();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
  }
}

final AuthManager authManager = AuthManager();


class IdType {
  final int id;
  final String type;

  IdType(this.id, this.type);
}

class GenderType {
  final int id;
  final String name;

  GenderType(this.id, this.name);
}