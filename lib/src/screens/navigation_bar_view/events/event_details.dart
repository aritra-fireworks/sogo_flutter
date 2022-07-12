import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/events_manager/events_manager.dart';
import 'package:sogo_flutter/src/models/events/event_details_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';

class EventDetails extends StatefulWidget {
  final String eventId;
  const EventDetails({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {

  format(DateTime date, {bool showYear = true}) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    if(showYear) {
      return DateFormat("d'$suffix' MMMM, yyyy").format(date);
    } else {
      return DateFormat("d'$suffix' MMMM").format(date);
    }
  }

  @override
  void initState() {
    super.initState();
    eventsManager.getEventDetails(eventId: widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text("Sales & Events", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                ),
                margin: EdgeInsets.only(top: 80.h),
              ),
              StreamBuilder<ApiResponse<EventDetailsModel>?>(
                  stream: eventsManager.eventDetails,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<EventDetailsModel>?> snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          debugPrint('Loading');
                          return const SizedBox();
                        case Status.COMPLETED:
                          debugPrint('Mall List Loaded');
                          if(snapshot.data?.data?.details != null && snapshot.data!.data!.details!.isNotEmpty){
                            return eventDetailsBody(context, snapshot.data!.data!.details!.first);
                          }
                          return Center(
                            child: Text("No details found", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),),
                          );
                        case Status.NODATAFOUND:
                          debugPrint('Not found');
                          return const SizedBox();
                        case Status.ERROR:
                          debugPrint('Error');
                          return const SizedBox();
                      }
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ],
    );
  }

  Widget eventDetailsBody(BuildContext context, EventDetail eventDetails) {
    bool showYear = true;
    if(eventDetails.purchaseStart?.split("/").last == eventDetails.purchaseEnd?.split("/").last){
      showYear = false;
    }
    String startDate = eventDetails.purchaseStart??"23/05/2022";
    String endDate = eventDetails.purchaseEnd??"23/05/2022";
    try{
      startDate = format(DateFormat("dd/MM/yyyy").parse(startDate), showYear: showYear);
      endDate = format(DateFormat("dd/MM/yyyy").parse(endDate), showYear: showYear);
    } catch(e){
      debugPrint("Error converting");
    }
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: CachedNetworkImage(
                  imageUrl: eventDetails.featuredImage??"", fit: BoxFit.fitWidth,
                  placeholder: (context, url) => LoadingIndicator(
                    indicatorType: Indicator.ballScale,
                    colors: [AppColors.primaryRed, AppColors.secondaryRed],
                  ),
                  errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", fit: BoxFit.fitWidth,),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(eventDetails.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  SizedBox(height: 15.h,),
                  eventTile(iconPath: "assets/images/ic_event_date.png", title: "$startDate - $endDate"),
                  SizedBox(height: 10.h,),
                  eventTile(iconPath: "assets/images/ic_event_location.png", title: eventDetails.address??""),
                  SizedBox(height: 10.h,),
                  eventTile(iconPath: "assets/images/ic_admission_fee.png", title: eventDetails.points??""),
                  SizedBox(height: 20.h,),
                  HtmlWidget(eventDetails.description??"", textStyle: TextStyle(fontFamily: "MyriadRegular", color: AppColors.textGrey, fontSize: 15.sp),),
                  SizedBox(height: 30.h,),
                  RoundButton(onPressed: (){
                    final Event event = Event(
                      title: eventDetails.title??"",
                      description: eventDetails.description??"",
                      location: eventDetails.address??"",
                      startDate: DateFormat("dd MMM yyyy").parse(startDate),
                      endDate: DateFormat("dd MMM yyyy").parse(endDate),
                      allDay: true,
                      iosParams: const IOSParams(
                        reminder: Duration(minutes: 5), // on iOS, you can set alarm notification after your event.
                      ),
                    );
                    Add2Calendar.addEvent2Cal(event);
                  }, borderRadius: 9, child: Text("Add to calender", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white),)),
                  SizedBox(height: 10.h,),
                  RoundOutlineButton(onPressed: (){
                    Share.share(eventDetails.shareLink ?? "", subject: 'Look at what I found!');
                  }, borderRadius: 9, child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.arrowshape_turn_up_right_fill, color: AppColors.primaryRed, size: 15.sp,),
                      SizedBox(width: 10.w,),
                      Text("Share", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.primaryRed),),
                    ],
                  )),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  
  Widget eventTile({required String iconPath, required String title}) {
    return Row(
      children: [
        Image.asset(iconPath, width: 15.w,),
        SizedBox(width: 15.w,),
        Flexible(child: Text(title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),)),
      ],
    );
  }
}
