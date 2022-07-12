import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';

class SecretCode {
  static String getVCKey(){
    String decryptKey = ApplicationGlobal.secretKey + getDate();
    return generateMd5(decryptKey);
  }

  static String getDeleteAccountVCKey(){
    String decryptKey = "${ApplicationGlobal.deleteAccountKey}${ApplicationGlobal.profile?.custid}";
    debugPrint("Sign: $decryptKey");
    return generateMd5(decryptKey);
  }

  static String getDate(){
    return (DateTime.now().millisecondsSinceEpoch).toString();
  }

  static String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}