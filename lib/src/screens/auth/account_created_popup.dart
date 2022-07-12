import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class AccountCreatedPopup extends StatelessWidget {
  final String message;
  final VoidCallback? onOk;
  const AccountCreatedPopup({Key? key, required this.message, this.onOk}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Congratulations! Your account has been successfully created.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
              SizedBox(height: 20.h,),
              Image.asset("assets/images/ic_pts_register.png", width: 160.w, fit: BoxFit.fitWidth,),
              SizedBox(height: 20.h,),
              Text(message, textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
              SizedBox(height: 20.h,),
              RoundButton(onPressed: (){
                Navigator.pop(context);
                if(onOk != null) onOk!();
              }, borderRadius: 9, child: Text("OK", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),),),
            ],
          ),
        ),
      ),
    );
  }
}
