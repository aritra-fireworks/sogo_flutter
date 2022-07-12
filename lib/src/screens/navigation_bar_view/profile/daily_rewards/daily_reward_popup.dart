import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class DailyRewardPopup extends StatelessWidget {
  final VoidCallback? onOkClicked;
  const DailyRewardPopup({Key? key, this.onOkClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 15.h,),
                Text("You’ve checked in today", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18.sp, fontFamily: "GothamRegular"),),
                SizedBox(height: 25.h,),
                Text("Check-in tomorrow to get more Point Rewards", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 18.sp, fontFamily: "GothamRegular"),),
                SizedBox(height: 15.h,),
                Image.asset("assets/images/ic_checked_in.png", width: 160.w, fit: BoxFit.fitWidth,),
                SizedBox(height: 25.h,),
                RoundButton(onPressed: (){
                  Navigator.pop(context);
                  if(onOkClicked != null) onOkClicked!();
                }, borderRadius: 9, child: Text("OK", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),),),
                SizedBox(height: 10.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
