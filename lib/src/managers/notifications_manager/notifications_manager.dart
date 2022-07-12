import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/models/notifications/notifications_model.dart';
import 'package:sogo_flutter/src/services/notifications_service/notifications_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';

enum NotificationType {
  global,
  private,
}

class NotificationsManager {

  final _notificationsController = BehaviorSubject<ApiResponse<NotificationsModel>?>();
  Stream<ApiResponse<NotificationsModel>?> get notifications => _notificationsController.stream;

  Future<void> getNotifications({bool withLoading = true, String read = "", String archive = ""}) async {
    if (withLoading) {
      _notificationsController.sink.add(ApiResponse.loading("In Progress"));
    }
    Map<String, dynamic>? result;
    try {
      Map params = {
        "read": read,
        "archive": archive,
        "custid": ApplicationGlobal.profile?.custid??"",
        "mercid": "44",
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "sectoken": ApplicationGlobal.bearerToken,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
        "appversion": DeviceInfo.deviceVersion,
        "deviceflavour": DeviceInfo.deviceVersion,
      };
      result = await NotificationsService.inboxListing(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _notificationsController.sink.add(null);
    }
    if (result != null) {
      NotificationsModel notificationsResponse = NotificationsModel.fromJson(result);
      _notificationsController.sink.add(ApiResponse.completed(notificationsResponse));
    } else {
      _notificationsController.sink.add(ApiResponse.error("Server Error!"));
    }
  }

  Future<CommonResponseModel?> notificationAction({required String? notificationId, required NotificationType type, String read = "", String archive = ""}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "type": type.name,
        "read": read,
        "archive": archive,
        "inbox_id": notificationId ?? "",
        "all": "",
        "custid": ApplicationGlobal.profile?.custid??"",
        "mercid": "44",
        "date": SecretCode.getDate(),
        "vc": SecretCode.getVCKey(),
        "os": DeviceInfo.deviceOS,
        "sectoken": ApplicationGlobal.bearerToken,
        "phonename": DeviceInfo.deviceMake,
        "phonetype": "Phone",
        "lang": "en",
        "deviceid": DeviceInfo.deviceUid,
        "devicetype": DeviceInfo.deviceType,
        "appversion": DeviceInfo.deviceVersion,
        "deviceflavour": DeviceInfo.deviceVersion,
      };
      result = await NotificationsService.inboxAction(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      CommonResponseModel? response = CommonResponseModel.fromJson(result);
      return response;
    } else {
      AppUtils.showToast("Server Error!");
    }
    return null;
  }

  dispose() {
    _notificationsController.close();
  }

  resetData() {
    _notificationsController.sink.add(null);
  }
}

final NotificationsManager notificationsManager = NotificationsManager();
