import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/profile/dashboard_model.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/services/dashboard_service/dashboard_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class DashboardManager {

  final _mallListController = BehaviorSubject<ApiResponse<MallListModel>?>();
  Stream<ApiResponse<MallListModel>?> get mallList => _mallListController.stream;

  final _dashboardController = BehaviorSubject<ApiResponse<DashboardModel>?>();
  Stream<ApiResponse<DashboardModel>?> get dashboard => _dashboardController.stream;

  Future<MallListModel?> getMallList({bool withoutToken = false}) async {
    _mallListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
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
      result = await DashboardService.mallList(params, withoutToken);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _mallListController.sink.add(null);
    }
    if (result != null) {
      debugPrint(result.toString());
      MallListModel mallListResponse = MallListModel.fromJson(result);
      ApplicationGlobal.mallList = mallListResponse;
      _mallListController.sink.add(ApiResponse.completed(mallListResponse));
      return mallListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _mallListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }


  Future<DashboardModel?> getDashboard({required String mallId}) async {
    _dashboardController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "mall": mallId,
        "custid": ApplicationGlobal.profile?.custid??"",
        "mercid": "44",
        "lat": "",
        "lng": "",
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
      result = await DashboardService.dashboard(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _dashboardController.sink.add(null);
    }
    if (result != null) {
      DashboardModel dashboardResponse = DashboardModel.fromJson(result);
      _dashboardController.sink.add(ApiResponse.completed(dashboardResponse));
      return dashboardResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _dashboardController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }
}

final DashboardManager dashboardManager = DashboardManager();
