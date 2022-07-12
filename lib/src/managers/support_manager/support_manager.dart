import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/support_model.dart';
import 'package:sogo_flutter/src/services/support_service/support_service.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';

class SupportManager {


  Future<SupportResponseModel?> createTicket({required Map params}) async {
    Map<String, dynamic>? result;
    try {
      result = await SupportService.createTicket(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
    }
    if (result != null) {
      SupportResponseModel response = SupportResponseModel.fromJson(result);
      return response;
    } else {
      AppUtils.showToast('Server Error!');
    }
    return null;
  }

}

final SupportManager supportManager = SupportManager();
