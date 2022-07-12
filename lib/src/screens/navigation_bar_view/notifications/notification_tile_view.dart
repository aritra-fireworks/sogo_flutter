import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';

class NotificationTile extends StatelessWidget {
  final String? title;
  final String? notification;
  final String? dateTime;
  final bool? read;
  const NotificationTile({Key? key, this.title, this.notification, this.dateTime, this.read = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title??"", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBold"),),
                SizedBox(height: 15.h,),
                Text(notification??"", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(dateTime??"", style: (read??false) ? TextStyle(color: AppColors.grey, fontSize: 13.sp, fontFamily: "GothamMedium") : TextStyle(color: const Color(0xFFDD1F18), fontSize: 13.sp, fontFamily: "GothamMedium"),),
              SizedBox(height: 15.h,),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (read??false) ? Colors.transparent : AppColors.primaryRed,
                ),
                height: 15.sp,
                width: 15.sp,
              ),
            ],
          ),
          Divider(thickness: 1.sp, height: 1.sp, color: AppColors.grey.withOpacity(0.2),),
        ],
      ),
    );
  }
}
