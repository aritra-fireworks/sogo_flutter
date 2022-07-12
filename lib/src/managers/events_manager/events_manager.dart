import 'package:flutter/foundation.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/models/events/event_details_model.dart';
import 'package:sogo_flutter/src/models/events/events_list_model.dart';
import 'package:sogo_flutter/src/services/events_service/events_service.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:rxdart/rxdart.dart';

class EventsManager {

  final _eventsListController = BehaviorSubject<ApiResponse<EventsListModel>?>();
  Stream<ApiResponse<EventsListModel>?> get eventsList => _eventsListController.stream;

  final _eventDetailsController = BehaviorSubject<ApiResponse<EventDetailsModel>?>();
  Stream<ApiResponse<EventDetailsModel>?> get eventDetails => _eventDetailsController.stream;

  Future<EventsListModel?> getEventsList({required int start, required int offset}) async {
    _eventsListController.sink.add(ApiResponse.loading("In Progress"));
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
      result = await EventsService.eventsList(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _eventsListController.sink.add(null);
    }
    if (result != null) {
      EventsListModel eventsListResponse = EventsListModel.fromJson(result);
      _eventsListController.sink.add(ApiResponse.completed(eventsListResponse));
      return eventsListResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _eventsListController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }


  Future<EventDetailsModel?> getEventDetails({required String eventId}) async {
    _eventDetailsController.sink.add(ApiResponse.loading("In Progress"));
    Map<String, dynamic>? result;
    try {
      Map params = {
        "eventid": eventId,
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
      result = await EventsService.eventDetails(params);
    } catch (e) {
      AppUtils.showToast('Error: $e');
      debugPrint('Error: $e');
      _eventDetailsController.sink.add(null);
    }
    if (result != null) {
      EventDetailsModel eventDetailsResponse = EventDetailsModel.fromJson(result);
      _eventDetailsController.sink.add(ApiResponse.completed(eventDetailsResponse));
      return eventDetailsResponse;
    } else {
      AppUtils.showToast('Server Error!');
      _eventDetailsController.sink.add(ApiResponse.error("Server Error!"));
    }
    return null;
  }
}

final EventsManager eventsManager = EventsManager();
