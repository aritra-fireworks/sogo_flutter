
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class AuthService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> login(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().loginUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> checkSession(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().checkSessionUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> pointsDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().pointsDetailsUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> checkEmail(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().checkEmailUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> statesList(Map params, bool withoutToken) async {

    dynamic response = await _helper.postRequest(UrlController().statesUrl(withoutToken), params, isFormData: true);

    return response;
  }

  static Future<dynamic> sendOtp(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().sendOtpUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> verifyOtp(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().verifyOtpUrl(), params, isFormData: true);

    return response;
  }


  static Future<dynamic> addDeviceToken(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().addDeviceTokenUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> signUp(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().signUpUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> checkMigrateUser(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().checkMigrateUserUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> getMigratedUserData(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().getMigratedUserDataUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> changePassword(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().changePasswordUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> resetPassword(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().resetPasswordUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> migrationResetPassword(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().migrationResetPasswordUrl(), params, isFormData: true);

    return response;
  }

}