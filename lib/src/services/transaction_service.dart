
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class TransactionService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> transactionsList(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().transactionHistoryUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> transactionDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().transactionDetailsUrl(), params, isFormData: true);

    return response;
  }

}