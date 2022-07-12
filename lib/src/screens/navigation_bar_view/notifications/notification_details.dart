import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/notifications_manager/notifications_manager.dart';
import 'package:sogo_flutter/src/models/notifications/notifications_model.dart';

class NotificationDetails extends StatefulWidget {
  final Inbox? inbox;
  final NotificationType notificationType;
  const NotificationDetails({Key? key, this.inbox, required this.notificationType}) : super(key: key);

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {

  @override
  void initState() {
    super.initState();
    notificationsManager.notificationAction(notificationId: "${widget.inbox?.id}", type: widget.notificationType, read: "1").then((value) => notificationsManager.getNotifications());
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
            leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Ink(
                child: const Icon(Icons.arrow_back_ios, color: Colors.white,),
              ),
            ),
            centerTitle: true,
            title: Text(widget.inbox?.title??"Notification", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(widget.inbox?.image??"", fit: BoxFit.fitWidth, errorBuilder: (BuildContext context, Object object, StackTrace? stackTrace){
                          return const SizedBox();
                        }),
                        SizedBox(height: 20.h,),
                        Text(widget.inbox?.title??"", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamMedium"),),
                        SizedBox(height: 20.h,),
                        HtmlWidget(widget.inbox?.message??"", textStyle: TextStyle(color: AppColors.grey, fontSize: 15.sp, fontFamily: "GothamRegular"),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
