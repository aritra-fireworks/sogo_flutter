
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_base_helper.dart';

class DirectoryService {

  static final ApiBaseHelper _helper = ApiBaseHelper();

  static Future<dynamic> directoryCategories(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().directoryCategoriesUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> getDirectoryFloor(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().getDirectoryFloorUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> getDirectory(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().getDirectoryUrl(), params, isFormData: true);

    return response;
  }

  static Future<dynamic> directoryDetails(Map params) async {

    dynamic response = await _helper.postRequest(UrlController().directoryDetailsUrl(), params, isFormData: true);

    return response;
  }

}