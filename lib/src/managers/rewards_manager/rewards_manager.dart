import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/rewards/claim_reward_model.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/merchant_details_model.dart';
import 'package:sogo_flutter/src/models/rewards/my_multi_wallet_list_model.dart';
import 'package:sogo_flutter/src/models/rewards/my_reward_details_model.dart';
import 'package:sogo_flutter/src/models/rewards/my_rewards_list_model.dart';
import 'package:sogo_flutter/src/models/rewards/reward_category_list_model.dart';
import 'package:sogo_flutter/src/models/rewards/reward_details_model.dart';
import 'package:sogo_flutter/src/models/rewards/rewards_list_model.dart';
import 'package:sogo_flutter/src/services/rewards_service/rewards_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class RewardsManager {

  final _rewardsIndex = BehaviorSubject<int?>();
  Stream<int?> get rewardsIndexStream => _rewardsIndex.stream;
  StreamSink<int?> get rewardsIndexSink => _rewardsIndex.sink;

  final _rewardsListController = BehaviorSubject<ApiResponse<RewardsListModel>?>();
  Stream<ApiResponse<RewardsListModel>?> get rewardsList => _rewardsListController.stream;

  final _rewardsCategoryListController = BehaviorSubject<ApiResponse<RewardCategoryListModel>?>();
  Stream<ApiResponse<RewardCategoryListModel>?> get rewardsCategoryList => _rewardsCategoryListController.stream;

  final _rewardDetailsController = BehaviorSubject<ApiResponse<RewardDetailsModel>?>();
  Stream<ApiResponse<RewardDetailsModel>?> get rewardDetails => _rewardDetailsController.stream;

  final _merchantDetailsController = BehaviorSubject<ApiResponse<MerchantDetailsModel>?>();
  Stream<ApiResponse<MerchantDetailsModel>?> get merchantDetails => _merchantDetailsController.stream;



  final _myRewardsListController = BehaviorSubject<ApiResponse<MyRewardsListModel>?>();
  Stream<ApiResponse<MyRewardsListModel>?> get myRewardsList => _myRewardsListController.stream;

  final _myMultiRewardsListController = BehaviorSubject<ApiResponse<MyMultiWalletListModel>?>();
  Stream<ApiResponse<MyMultiWalletListModel>?> get myMultiRewardsList => _myMultiRewardsListController.stream;

  final _myRewardDetailsController = BehaviorSubject<ApiResponse<MyRewardDetailsModel>?>();
  Stream<ApiResponse<MyRewardDetailsModel>?> get myRewardDetails => _myRewardDetailsController.stream;


  updateRewardsIndex(int index){
    rewardsIndexSink.add(index);
  }

  reset(){
    rewardsIndexSink.add(null);
  }


  Future<RewardsListModel?> getRewardsList({required int start, required int offset, String? categoryId}) async {
    _rewardsListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "start": start.toString(),
        "offset": offset.toString(),
        "mall": ApplicationGlobal.selectedMall?.id,
        "custid": ApplicationGlobal.profile?.custid??"",
        "category": categoryId??"",
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
      result = await RewardsService.rewardsList(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _rewardsListController.sink.add(null);
    }
    if (result != null) {
      RewardsListModel rewardsListResponse = RewardsListModel.fromJson(result);
      _rewardsListController.sink.add(ApiResponse.completed(rewardsListResponse));
      return rewardsListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _rewardsListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<RewardCategoryListModel?> getRewardsCategory() async {
    _rewardsCategoryListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
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
      result = await RewardsService.rewardsCategoryList(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _rewardsCategoryListController.sink.add(null);
    }
    if (result != null) {
      RewardCategoryListModel rewardsListResponse = RewardCategoryListModel.fromJson(result);
      _rewardsCategoryListController.sink.add(ApiResponse.completed(rewardsListResponse));
      return rewardsListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _rewardsCategoryListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }


  Future<RewardDetailsModel?> getRewardDetails({required String rewardId}) async {
    _rewardDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "id": rewardId,
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
      result = await RewardsService.rewardDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _rewardDetailsController.sink.add(null);
    }
    if (result != null) {
      RewardDetailsModel rewardDetailsResponse = RewardDetailsModel.fromJson(result);
      _rewardDetailsController.sink.add(ApiResponse.completed(rewardDetailsResponse));
      return rewardDetailsResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _rewardDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<ClaimRewardModel?> rewardCheckout({required String rewardId, required int qty, required String collectionMethod}) async {
    Map<String, dynamic>? result;
    try {
      Map params = {
        "itemid": rewardId,
        "qty": "$qty",
        "collection_method": collectionMethod,
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
      result = await RewardsService.rewardCheckout(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      ClaimRewardModel rewardDetailsResponse = ClaimRewardModel.fromJson(result);
      return rewardDetailsResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

  Future<MerchantDetailsModel?> getMerchantDetails({required String mall, required String merchantId}) async {
    _merchantDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "mall": mall,
        "mercid": "44",
        "merchantid": merchantId,
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
      result = await RewardsService.merchantDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _merchantDetailsController.sink.add(null);
    }
    if (result != null) {
      MerchantDetailsModel rewardDetailsResponse = MerchantDetailsModel.fromJson(result);
      _merchantDetailsController.sink.add(ApiResponse.completed(rewardDetailsResponse));
      return rewardDetailsResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _merchantDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }




  Future<MyRewardsListModel?> getMyRewardsList({required int start, required int offset, String? condition}) async {
    _myRewardsListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "start": start.toString(),
        "offset": offset.toString(),
        "mall": ApplicationGlobal.selectedMall?.id,
        "custid": ApplicationGlobal.profile?.custid??"",
        "type": "",
        "condition": condition??"",
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
      result = await RewardsService.myRewardsList(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _myRewardsListController.sink.add(null);
    }
    if (result != null) {
      MyRewardsListModel myRewardsListResponse = MyRewardsListModel.fromJson(result);
      _myRewardsListController.sink.add(ApiResponse.completed(myRewardsListResponse));
      return myRewardsListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _myRewardsListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<MyMultiWalletListModel?> getMyMultiRewardsList({required int start, required int offset, required String type, required String id, required String condition}) async {
    _myMultiRewardsListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "start": start.toString(),
        "offset": offset.toString(),
        "mall": ApplicationGlobal.selectedMall?.id,
        "custid": ApplicationGlobal.profile?.custid??"",
        "type": type,
        "id": id,
        "condition": condition,
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
      result = await RewardsService.myMultiRewardsList(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _myMultiRewardsListController.sink.add(null);
    }
    if (result != null) {
      MyMultiWalletListModel rewardsListResponse = MyMultiWalletListModel.fromJson(result);
      _myMultiRewardsListController.sink.add(ApiResponse.completed(rewardsListResponse));
      return rewardsListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _myMultiRewardsListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<MyRewardDetailsModel?> getMyRewardDetails({required String rewardId, required String type}) async {
    _myRewardDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "id": rewardId,
        "custid": ApplicationGlobal.profile?.custid??"",
        "mercid": "44",
        "type": type,
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
      result = await RewardsService.myRewardDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _myRewardDetailsController.sink.add(null);
    }
    if (result != null) {
      MyRewardDetailsModel rewardDetailsResponse = MyRewardDetailsModel.fromJson(result);
      _myRewardDetailsController.sink.add(ApiResponse.completed(rewardDetailsResponse));
      return rewardDetailsResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _myRewardDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }
}

final RewardsManager rewardsManager = RewardsManager();
