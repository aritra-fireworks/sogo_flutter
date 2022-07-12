
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class NotificationsService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> inboxListing(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().inboxListingUrl(), params, isFormData: true);

    return response;

  }

  static Future<dynamic> inboxAction(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().inboxActionUrl(), params, isFormData: true);

    return response;

  }

}