import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/constants/preferences.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/models/profile/notification_settings_model.dart';
import 'package:sogo_flutter/src/models/profile/refer_friend_model.dart';
import 'package:sogo_flutter/src/models/profile/user_profile_model.dart';
import 'package:sogo_flutter/src/services/profile_service/profile_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class ProfileManager {

  final _profileController = BehaviorSubject<ApiResponse<UserProfileModel>?>();
  Stream<ApiResponse<UserProfileModel>?> get profile => _profileController.stream;

  final _referralInfoController = BehaviorSubject<ApiResponse<ReferralInfoModel>?>();
  Stream<ApiResponse<ReferralInfoModel>?> get referralInfo => _referralInfoController.stream;

  final _notificationSettingsController = BehaviorSubject<ApiResponse<NotificationSettingsModel>?>();
  Stream<ApiResponse<NotificationSettingsModel>?> get notificationSettings => _notificationSettingsController.stream;


  Future<UserProfileModel?> getProfile() async {
    _profileController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
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
        "appversion": DeviceInfo.deviceVersion,
        "deviceflavour": DeviceInfo.deviceVersion,
      };
      result = await ProfileService.profile(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _profileController.sink.add(null);
    }
    if (result != null) {
      log(result.toString());
      UserProfileModel dashboardResponse = UserProfileModel.fromJson(result);
      _profileController.sink.add(ApiResponse.completed(dashboardResponse));
      return dashboardResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _profileController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<CommonResponseModel?> updateProfile(Map params) async {
    Map<String, dynamic>? result;
    try {
      result = await ProfileService.updateProfile(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      log(result.toString());
      CommonResponseModel updateProfileResponse = CommonResponseModel.fromJson(result);
      return updateProfileResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<CommonResponseModel?> deleteProfile() async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "custid": ApplicationGlobal.profile?.custid??"",
        "sign": SecretCode.getDeleteAccountVCKey(),
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "sectoken": ApplicationGlobal.bearerToken,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
        "appversion": DeviceInfo.deviceVersion,
        "deviceflavour": DeviceInfo.deviceVersion,
      };
      result = await ProfileService.deleteProfile(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      CommonResponseModel deleteProfileResponse = CommonResponseModel.fromJson(result);
      preferences.deleteAllValues();
      return deleteProfileResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<ReferralInfoModel?> getReferralInfo() async {
    _referralInfoController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
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
        "appversion": DeviceInfo.deviceVersion,
        "deviceflavour": DeviceInfo.deviceVersion,
      };
      result = await ProfileService.getReferralInfo(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _referralInfoController.sink.add(null);
    }
    if (result != null) {
      log(result.toString());
      ReferralInfoModel dashboardResponse = ReferralInfoModel.fromJson(result);
      _referralInfoController.sink.add(ApiResponse.completed(dashboardResponse));
      return dashboardResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _referralInfoController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<NotificationSettingsModel?> getNotificationSettings({bool withLoading = true}) async {
    if(withLoading) {
      _notificationSettingsController.sink.add(ApiResponse.loading("In Progress"));
    }
    Map<String, dynamic>? result;
    try {
      Map params = {
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
        "appversion": DeviceInfo.deviceVersion,
        "deviceflavour": DeviceInfo.deviceVersion,
      };
      result = await ProfileService.getNotificationSettings(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _notificationSettingsController.sink.add(null);
    }
    if (result != null) {
      log(result.toString());
      NotificationSettingsModel dashboardResponse = NotificationSettingsModel.fromJson(result);
      _notificationSettingsController.sink.add(ApiResponse.completed(dashboardResponse));
      return dashboardResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _notificationSettingsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<CommonResponseModel?> updateNotificationSettings({required String setting, required String news, required String general, required String rightHere}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "setting": setting,
        "news": news,
        "general": general,
        "righthere": rightHere,
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
        "appversion": DeviceInfo.deviceVersion,
        "deviceflavour": DeviceInfo.deviceVersion,
      };
      result = await ProfileService.updateNotificationSettings(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      log(result.toString());
      CommonResponseModel updateProfileResponse = CommonResponseModel.fromJson(result);
      return updateProfileResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }
}

final ProfileManager profileManager = ProfileManager();
