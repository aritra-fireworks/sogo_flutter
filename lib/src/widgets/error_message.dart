import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class ErrorMessagePopup extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onOk;
  const ErrorMessagePopup({Key? key, required this.title, required this.message, this.onOk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 20.sp, fontFamily: "GothamMedium"),),
              SizedBox(height: 30.h,),
              Text(message, textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBook"),),
              SizedBox(height: 30.h,),
              RoundButton(onPressed: (){
                Navigator.pop(context);
                if(onOk != null) onOk!();
              }, borderRadius: 9, child: Text("OK", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),),),
              SizedBox(height: 10.h,),
            ],
          ),
        ),
      ),
    );
  }
}
