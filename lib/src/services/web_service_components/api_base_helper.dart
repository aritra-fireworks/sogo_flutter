import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sogo_flutter/src/services/web_service_components/set_header.dart';
import 'dart:convert';
import 'dart:async';

import 'package:sogo_flutter/src/utils/app_utils.dart';



class ApiBaseHelper {
  Future<dynamic> getRequest(String url, {String? bearerToken, bool isFormData=false}) async {
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      var header = await SetHeaderHttps.setHttpHeader(bearerToken: bearerToken, isFormData: isFormData);
      final response = await http.get(Uri.parse(url), headers: header);
      responseJson = _returnResponse(response, url: url);
    } on SocketException {
      AppUtils.showToast('Network error');
    }
    return responseJson;
  }

  Future<dynamic> postRequest(String url, dynamic body, {bool isFormData = false, String? bearerToken}) async {
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      var header = await SetHeaderHttps.setHttpHeader(isFormData: isFormData, bearerToken: bearerToken);
      final response = await http.post(Uri.parse(url), body: body, headers: header);
      responseJson = _returnResponse(response, url: url, body: body);
    } on SocketException {
      AppUtils.showToast('Network error');
    }
    return responseJson;
  }

  Future<dynamic> putRequest(String url, dynamic body) async {
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      var header = await SetHeaderHttps.setHttpHeader();
      final response = await http.put(Uri.parse(url), body: body, headers: header);
      responseJson = _returnResponse(response, url: url, body: body);
    } on SocketException {
      AppUtils.showToast('Network error');
    }
    return responseJson;
  }

  Future<dynamic> deleteRequest(String url) async {
    // ignore: prefer_typing_uninitialized_variables
    var apiResponse;
    try {
      var header = await SetHeaderHttps.setHttpHeader();
      final response = await http.delete(Uri.parse(url), headers: header);
      apiResponse = _returnResponse(response, url: url);
    } on SocketException {
      AppUtils.showToast('Network error');
    }
    return apiResponse;
  }

  dynamic _returnResponse(http.Response response, {String? url, dynamic body}) {
    if(kDebugMode) {
      print("URL = $url");
      if(body != null) {
        log("Request Body = ${body.toString()}");
      }
      print("Status Code = ${response.statusCode}");
      log("Response Body = ${response.body}");
    }
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    if(response.statusCode >= 200 && response.statusCode < 500){

      try{
        responseJson = json.decode(response.body);
      } catch(e){
        responseJson = response.body;
      }

      return responseJson;
    }
    else {
      debugPrint('Status Code: ${response.statusCode}\nBody: ${response.body}');
      AppUtils.showToast('Status Code: ${response.statusCode}\nBody: ${response.body}');
    }
  }
}
