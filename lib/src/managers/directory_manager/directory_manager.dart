import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/directory/directory_categories_model.dart';
import 'package:sogo_flutter/src/models/directory/directory_details_model.dart';
import 'package:sogo_flutter/src/models/directory/directory_floor_model.dart';
import 'package:sogo_flutter/src/models/directory/directory_list_model.dart';
import 'package:sogo_flutter/src/services/directory_service/directory_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class DirectoryManager {

  final _directoryCategoriesController = BehaviorSubject<ApiResponse<DirectoryCategoriesModel>?>();
  Stream<ApiResponse<DirectoryCategoriesModel>?> get directoryCategories => _directoryCategoriesController.stream;

  final _directoryFloorController = BehaviorSubject<ApiResponse<DirectoryFloorModel>?>();
  Stream<ApiResponse<DirectoryFloorModel>?> get directoryFloor => _directoryFloorController.stream;

  final _allDirectoryListController = BehaviorSubject<ApiResponse<DirectoryListModel>?>();
  Stream<ApiResponse<DirectoryListModel>?> get allDirectoryList => _allDirectoryListController.stream;

  final _directoryListController = BehaviorSubject<ApiResponse<DirectoryListModel>?>();
  Stream<ApiResponse<DirectoryListModel>?> get directoryList => _directoryListController.stream;

  final _directoryDetailsController = BehaviorSubject<ApiResponse<DirectoryDetailsModel>?>();
  Stream<ApiResponse<DirectoryDetailsModel>?> get directoryDetails => _directoryDetailsController.stream;

  Future<DirectoryCategoriesModel?> getDirectoryCategories({required String merchantId}) async {
    _directoryCategoriesController.sink.add(ApiResponse.loading("In Progress"));
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
      result = await DirectoryService.directoryCategories(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _directoryCategoriesController.sink.add(null);
    }
    if (result != null) {
      DirectoryCategoriesModel response = DirectoryCategoriesModel.fromJson(result);
      _directoryCategoriesController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _directoryCategoriesController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<DirectoryFloorModel?> getDirectoryFloor() async {
    _directoryFloorController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
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
      result = await DirectoryService.getDirectoryFloor(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _directoryFloorController.sink.add(null);
    }
    if (result != null) {
      DirectoryFloorModel response = DirectoryFloorModel.fromJson(result);
      _directoryFloorController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _directoryFloorController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<DirectoryListModel?> getAllDirectoryList() async {
    _allDirectoryListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
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
      result = await DirectoryService.getDirectory(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _allDirectoryListController.sink.add(null);
    }
    if (result != null) {
      DirectoryListModel response = DirectoryListModel.fromJson(result);
      _allDirectoryListController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _allDirectoryListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<DirectoryListModel?> getDirectoryList({String? categoryId, String? searchTerm, bool withStream = true}) async {
    if(withStream) {
      _directoryListController.sink.add(ApiResponse.loading("In Progress"));
    }
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
      result = await DirectoryService.getDirectory(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      if(withStream) {
        _directoryListController.sink.add(null);
      }
    }
    if (result != null) {
      DirectoryListModel response = DirectoryListModel.fromJson(result);
      if(withStream) {
        _directoryListController.sink.add(ApiResponse.completed(response));
      }
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      if(withStream) {
        _directoryListController.sink.add(ApiResponse.error("Server Error!"));
      }
    }
    return null;
  }

  Future<DirectoryDetailsModel?> getDirectoryDetails({required String directoryId}) async {
    _directoryDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "directoryid": directoryId,
        "merchantid": directoryId,
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
      result = await DirectoryService.directoryDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _directoryDetailsController.sink.add(null);
    }
    if (result != null) {
      DirectoryDetailsModel response = DirectoryDetailsModel.fromJson(result);
      _directoryDetailsController.sink.add(ApiResponse.completed(response));
      return response;
    } else {
      AppUtils.showToast('Server Error!');
      _directoryDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

}

final DirectoryManager directoryManager = DirectoryManager();
