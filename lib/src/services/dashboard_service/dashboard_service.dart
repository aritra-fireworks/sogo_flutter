
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class DashboardService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> dashboard(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().dashboardUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> mallList(Map params, bool withoutToken) async {

    dynamic response = await _helper.postRequest(UrlController().mallListUrl(withoutToken), params, isFormData: true);

    return response;
  }

}