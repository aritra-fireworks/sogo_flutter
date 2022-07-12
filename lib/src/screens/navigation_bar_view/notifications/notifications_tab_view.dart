import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/notifications_manager/notifications_manager.dart';
import 'package:sogo_flutter/src/models/notifications/notifications_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/notifications/notification_details.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/notifications/notification_tile_view.dart';

class NotificationsPage extends StatelessWidget {
  final List<Inbox>? inbox;
  final NotificationType notificationType;
  const NotificationsPage({Key? key, this.inbox, required this.notificationType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(inbox != null && inbox!.isNotEmpty){
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: inbox!.length,
        itemBuilder: (context, index) => InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDetails(inbox: inbox![index], notificationType: notificationType),));
          },
          child: NotificationTile(
            title: inbox![index].title,
            notification: inbox![index].message,
            dateTime: inbox![index].date,
            read: inbox![index].unread == 0,
          ),
        ),
      );
    } else {
      return Center(
        child: Text("No notifications.", style: TextStyle(color: AppColors.grey, fontSize: 16.sp, fontFamily: "GothamBold"),),
      );
    }
  }
}
