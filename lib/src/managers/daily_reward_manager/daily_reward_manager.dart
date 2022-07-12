import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/models/rewards/daily_rewards_model.dart';
import 'package:sogo_flutter/src/services/daily_rewards_service/daily_rewards_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class DailyRewardManager {

  final _dailyRewardController = BehaviorSubject<ApiResponse<DailyRewardsModel>?>();
  Stream<ApiResponse<DailyRewardsModel>?> get dailyReward => _dailyRewardController.stream;

  Future<DailyRewardsModel?> dailyRewardInfo() async {
    _dailyRewardController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
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
      result = await DailyRewardService.dailyReward(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _dailyRewardController.sink.add(null);
    }
    if (result != null) {
      log(result.toString());
      DailyRewardsModel dailyRewardsResponse = DailyRewardsModel.fromJson(result);
      _dailyRewardController.sink.add(ApiResponse.completed(dailyRewardsResponse));
      return dailyRewardsResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _dailyRewardController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<CommonResponseModel?> checkIn() async {
    Map<String, dynamic>? result;
    try {
      Map params = {
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
      result = await DailyRewardService.dailyCheckIn(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      log(result.toString());
      CommonResponseModel updateProfileResponse = CommonResponseModel.fromJson(result);
      return updateProfileResponse;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

}

final DailyRewardManager dailyRewardManager = DailyRewardManager();
