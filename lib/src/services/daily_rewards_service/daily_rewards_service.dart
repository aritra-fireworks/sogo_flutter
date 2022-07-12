
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class DailyRewardService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> dailyReward(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().dailyRewardsUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> dailyCheckIn(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().dailyCheckInUrl(), params, isFormData: true);

    return response;
  }


}