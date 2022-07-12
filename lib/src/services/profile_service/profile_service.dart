
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class ProfileService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> profile(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().profileUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> updateProfile(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().updateProfileUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> deleteProfile(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().deleteProfileUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> getReferralInfo(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().getReferralInfoUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> getNotificationSettings(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().getNotificationSettingsUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> updateNotificationSettings(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().updateNotificationSettingsUrl(), params, isFormData: true);

    return response;
  }

}