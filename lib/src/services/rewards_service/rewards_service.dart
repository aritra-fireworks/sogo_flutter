
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class RewardsService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> rewardsList(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().rewardsListUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> rewardsCategoryList(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().rewardsCategoryListUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> rewardDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().rewardDetailsUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> rewardCheckout(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().rewardCheckoutUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> merchantDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().merchantDetailsUrl(), params, isFormData: true);

    return response;
  }



  static Future<dynamic> myRewardsList(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().myRewardsListUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> myMultiRewardsList(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().myMultiRewardsListUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> myRewardDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().myRewardDetailsUrl(), params, isFormData: true);

    return response;
  }

}