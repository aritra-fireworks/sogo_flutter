
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class EventsService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> eventsList(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().eventsListUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> eventDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().eventDetailsListUrl(), params, isFormData: true);

    return response;
  }

}