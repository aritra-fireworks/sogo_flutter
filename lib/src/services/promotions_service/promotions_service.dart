
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class PromotionsService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> promotionsList(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().newsListUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> promotionDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().newsDetailsListUrl(), params, isFormData: true);

    return response;
  }

}