import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/promotions/promotion_details_model.dart';
import 'package:sogo_flutter/src/models/promotions/promotions_list_model.dart';
import 'package:sogo_flutter/src/services/promotions_service/promotions_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class PromotionsManager {

  final _promotionsListController = BehaviorSubject<ApiResponse<PromotionsListModel>?>();
  Stream<ApiResponse<PromotionsListModel>?> get promotionsList => _promotionsListController.stream;

  final _memberPrivilegesListController = BehaviorSubject<ApiResponse<PromotionsListModel>?>();
  Stream<ApiResponse<PromotionsListModel>?> get memberPrivileges => _memberPrivilegesListController.stream;

  final _promotionDetailsController = BehaviorSubject<ApiResponse<PromotionDetailsModel>?>();
  Stream<ApiResponse<PromotionDetailsModel>?> get promotionDetails => _promotionDetailsController.stream;

  Future<PromotionsListModel?> getPromotionsList({required int start, required int offset}) async {
    _promotionsListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "start": start.toString(),
        "offset": offset.toString(),
        "mall": ApplicationGlobal.selectedMall?.id,
        "custid": ApplicationGlobal.profile?.custid??"",
        "mercid": "44",
        "latitude": "",
        "longitude": "",
        "latest": "0",
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
      result = await PromotionsService.promotionsList(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _promotionsListController.sink.add(null);
    }
    if (result != null) {
      PromotionsListModel promotionsListResponse = PromotionsListModel.fromJson(result);
      _promotionsListController.sink.add(ApiResponse.completed(promotionsListResponse));
      return promotionsListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _promotionsListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<PromotionsListModel?> getMemberPrivileges({required int start, required int offset}) async {
    _memberPrivilegesListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "start": start.toString(),
        "offset": offset.toString(),
        "mall": ApplicationGlobal.selectedMall?.id,
        "custid": ApplicationGlobal.profile?.custid??"",
        "category": "member_privilege",
        "mercid": "44",
        "latitude": "",
        "longitude": "",
        "latest": "0",
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
      result = await PromotionsService.promotionsList(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _memberPrivilegesListController.sink.add(null);
    }
    if (result != null) {
      PromotionsListModel promotionsListResponse = PromotionsListModel.fromJson(result);
      _memberPrivilegesListController.sink.add(ApiResponse.completed(promotionsListResponse));
      return promotionsListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _memberPrivilegesListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }


  Future<PromotionDetailsModel?> getPromotionDetails({required String promotionId}) async {
    _promotionDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "newsid": promotionId,
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
      result = await PromotionsService.promotionDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _promotionDetailsController.sink.add(null);
    }
    if (result != null) {
      PromotionDetailsModel eventDetailsResponse = PromotionDetailsModel.fromJson(result);
      _promotionDetailsController.sink.add(ApiResponse.completed(eventDetailsResponse));
      return eventDetailsResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _promotionDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }
}

final PromotionsManager promotionsManager = PromotionsManager();
