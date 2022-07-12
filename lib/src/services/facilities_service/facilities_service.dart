
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class FacilitiesService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> facilityCategories(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().facilityCategoriesUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> getFacilityFloor(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().getFacilityFloorUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> getFacility(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().getFacilityUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> facilityDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().facilityDetailsUrl(), params, isFormData: true);

    return response;
  }

}