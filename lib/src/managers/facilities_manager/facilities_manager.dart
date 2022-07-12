import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/facility/facilities_list_model.dart';
import 'package:sogo_flutter/src/models/facility/facility_categories_model.dart';
import 'package:sogo_flutter/src/models/facility/facility_details_model.dart';
import 'package:sogo_flutter/src/models/facility/facility_floor_model.dart';
import 'package:sogo_flutter/src/services/facilities_service/facilities_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class FacilitiesManager {

  final _facilityCategoriesController = BehaviorSubject<ApiResponse<FacilityCategoriesModel>?>();
  Stream<ApiResponse<FacilityCategoriesModel>?> get facilityCategories => _facilityCategoriesController.stream;

  final _facilityFloorController = BehaviorSubject<ApiResponse<FacilityFloorModel>?>();
  Stream<ApiResponse<FacilityFloorModel>?> get facilityFloor => _facilityFloorController.stream;

  final _facilitiesListController = BehaviorSubject<ApiResponse<FacilitiesListModel>?>();
  Stream<ApiResponse<FacilitiesListModel>?> get facilitiesList => _facilitiesListController.stream;

  final _facilityDetailsController = BehaviorSubject<ApiResponse<FacilityDetailsModel>?>();
  Stream<ApiResponse<FacilityDetailsModel>?> get facilityDetails => _facilityDetailsController.stream;

  Future<FacilityCategoriesModel?> getFacilityCategories({required String merchantId}) async {
    _facilityCategoriesController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "merchantid": merchantId,
        "mall": ApplicationGlobal.selectedMall?.id,
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
      result = await FacilitiesService.facilityCategories(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _facilityCategoriesController.sink.add(null);
    }
    if (result != null) {
      FacilityCategoriesModel response = FacilityCategoriesModel.fromJson(result);
      _facilityCategoriesController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _facilityCategoriesController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<FacilityFloorModel?> getFacilityFloor({required String merchantId}) async {
    _facilityFloorController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "merchantid": merchantId,
        "mall": ApplicationGlobal.selectedMall?.id,
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
      result = await FacilitiesService.getFacilityFloor(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _facilityFloorController.sink.add(null);
    }
    if (result != null) {
      FacilityFloorModel response = FacilityFloorModel.fromJson(result);
      _facilityFloorController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _facilityFloorController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<FacilitiesListModel?> getFacility({String? categoryId, String? searchTerm}) async {
    _facilitiesListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "categoryid": categoryId ?? "",
        "searchterm": searchTerm ?? "",
        "mall": ApplicationGlobal.selectedMall?.id,
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
      result = await FacilitiesService.getFacility(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _facilitiesListController.sink.add(null);
    }
    if (result != null) {
      FacilitiesListModel response = FacilitiesListModel.fromJson(result);
      _facilitiesListController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _facilitiesListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<FacilityDetailsModel?> getFacilityDetails({required String facilityId}) async {
    _facilityDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "facilityid": facilityId,
        "mall": ApplicationGlobal.selectedMall?.id,
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
      result = await FacilitiesService.facilityDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _facilityDetailsController.sink.add(null);
    }
    if (result != null) {
      FacilityDetailsModel response = FacilityDetailsModel.fromJson(result);
      _facilityDetailsController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _facilityDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

}

final FacilitiesManager facilitiesManager = FacilitiesManager();
