import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/manage_password/reset_via_email_popup.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/manage_password/reset_via_phone_popup.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';


class ResetPasswordPopUp extends StatelessWidget {
  final BuildContext previousContext;
  const ResetPasswordPopUp({Key? key, required this.previousContext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Material(
        borderRadius: BorderRadius.circular(13),
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel, color: AppColors.primaryRed,),
                  ),
                ),
              ),
              SizedBox(height: 10.h,),
              Text("Need To Reset Your Password?", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 20.sp, fontFamily: "GothamMedium"),),
              SizedBox(height: 30.h,),
              Text("Please select reset via email or SMS, we will send you the instruction for retrieving your account password.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBook"),),
              SizedBox(height: 30.h,),
              RoundButton(onPressed: (){
                Navigator.pop(context);
                AppUtils.showCustomDialog(context: previousContext, dialogBox: ResetViaEmailPopUp(previousContext: previousContext,));
              }, borderRadius: 9, child: const Text("Reset Via Email", style: TextStyle(fontSize: 15, fontFamily: "GothamMedium", color: Colors.white),),),
              SizedBox(height: 10.h,),
              RoundOutlineButton(
                onPressed: (){
                  Navigator.pop(context);
                  AppUtils.showCustomDialog(context: previousContext, dialogBox: ResetViaPhonePopUp(previousContext: previousContext,));
                },
                borderRadius: 9,
                child: const Text("Reset Via SMS", style: TextStyle(fontSize: 15, fontFamily: "GothamMedium", color: AppColors.lightBlack),),
              ),
              SizedBox(height: 20.h,),
            ],
          ),
        ),
      ),
    );
  }
}
