import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static String? deviceUid = "Web";
  static String? deviceName = "Browser";
  static String? deviceVersion = "1.0.0";
  static String? deviceModel = "NA";
  static String? deviceOS = "Android";
  static String? deviceMake = "NA";
  static String? deviceType = "NA";
  static String? timezone = DateTime.now().timeZoneName;

  static getDeviceInfo() async {
    if (Platform.isAndroid) {
      // Android-specific code
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceUid = androidInfo.androidId;
      deviceName = androidInfo.brand;
      deviceVersion = androidInfo.version.sdkInt.toString();
      deviceModel = androidInfo.model;
      deviceMake = androidInfo.brand;
      timezone = DateTime.now().timeZoneName;
      deviceOS = "android";
      deviceType = "androidphone";
      //debugPrint('Running on ${androidInfo.androidId}');
    } else if (Platform.isIOS) {
      // iOS-specific code
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceUid = iosInfo.identifierForVendor;
      deviceName = iosInfo.name;
      deviceVersion = iosInfo.systemVersion;
      deviceModel = iosInfo.model;
      deviceMake = 'Apple';
      timezone = DateTime.now().timeZoneName;
      deviceOS = "iOS";
      deviceType = "iphone";
    }
  }
}
