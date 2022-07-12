
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class SupportService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> createTicket(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().createTicketUrl(), params, isFormData: true);

    return response;

  }

}