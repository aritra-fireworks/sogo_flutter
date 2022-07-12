import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/transactions/transaction_details_model.dart';
import 'package:sogo_flutter/src/models/transactions/transaction_history_model.dart';
import 'package:sogo_flutter/src/services/transaction_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class TransactionManager {

  final _transactionsListController = BehaviorSubject<ApiResponse<TransactionHistoryModel>?>();
  Stream<ApiResponse<TransactionHistoryModel>?> get transactionsList => _transactionsListController.stream;

  final _transactionDetailsController = BehaviorSubject<ApiResponse<TransactionDetailsModel>?>();
  Stream<ApiResponse<TransactionDetailsModel>?> get transactionDetails => _transactionDetailsController.stream;


  Future<TransactionHistoryModel?> getTransactionsList({required int archive, int? month, int? year}) async {
    _transactionsListController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "archive": "$archive",
        "merchantid": "44",
        "month": month != null ? month.toString() : "",
        "year": year != null ? year.toString() : "",
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
      result = await TransactionService.transactionsList(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _transactionsListController.sink.add(null);
    }
    if (result != null) {
      TransactionHistoryModel transactionsListResponse = TransactionHistoryModel.fromJson(result);
      _transactionsListController.sink.add(ApiResponse.completed(transactionsListResponse));
      return transactionsListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _transactionsListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

  Future<TransactionDetailsModel?> getTransactionDetails({required String type, required String transactionId}) async {
    _transactionDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "type": type,
        "transid": transactionId,
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
      result = await TransactionService.transactionDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _transactionDetailsController.sink.add(null);
    }
    if (result != null) {
      TransactionDetailsModel transactionDetailsResponse = TransactionDetailsModel.fromJson(result);
      _transactionDetailsController.sink.add(ApiResponse.completed(transactionDetailsResponse));
      return transactionDetailsResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _transactionDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }

}

final TransactionManager transactionManager = TransactionManager();
