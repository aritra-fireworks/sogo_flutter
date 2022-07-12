

import 'package:sogo_flutter/src/constants/global.dart';

class SetHeaderHttps {
  static Future<Map<String, String>> setHttpHeader({bool isFormData = false, String? bearerToken}) async {
    var authToken = ApplicationGlobal.bearerToken.isNotEmpty ? "Bearer ${ApplicationGlobal.bearerToken}" : "";
    if(bearerToken != null && bearerToken.isNotEmpty){
      authToken = bearerToken;
    }
    Map<String, String> header;
    header = isFormData ? {
      "Authorization": authToken
    } : {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "Authorization": authToken
    };
    return header;
  }
}
