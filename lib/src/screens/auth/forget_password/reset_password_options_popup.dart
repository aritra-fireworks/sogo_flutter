import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';

class ResetPasswordOptionsPopup extends StatelessWidget {
  final VoidCallback? onViaEmailClicked;
  final VoidCallback? onViaSMSClicked;
  const ResetPasswordOptionsPopup({Key? key, this.onViaEmailClicked, this.onViaSMSClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Align(
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Please select reset via email or SMS, we will send you the instruction for retrieving your account password.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
                  SizedBox(height: 20.h,),
                  RoundButton(onPressed: (){
                    Navigator.pop(context);
                    if(onViaEmailClicked != null) onViaEmailClicked!();
                  }, borderRadius: 9, child: Text("Reset via Email", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),),),
                  SizedBox(height: 10.h,),
                  RoundOutlineButton(
                    onPressed: (){
                      Navigator.pop(context);
                      if(onViaSMSClicked != null) onViaSMSClicked!();
                    },
                    borderRadius: 9,
                    child: Text("Reset via SMS", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: AppColors.lightBlack),),
                  ),
                  SizedBox(height: 10.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
