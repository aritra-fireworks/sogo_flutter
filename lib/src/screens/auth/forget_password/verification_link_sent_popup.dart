import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class VerificationLinkSentPopup extends StatelessWidget {
  final VoidCallback? onOkClicked;
  final String? email;
  final String? phone;
  const VerificationLinkSentPopup({Key? key, this.onOkClicked, this.email, this.phone}) : super(key: key);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Reset Password", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamMedium", fontSize: 20.sp, color: AppColors.lightBlack),),
              SizedBox(height: 15.h,),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "A verification link has been sent to ", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack)),
                    if(email != null)
                      TextSpan(text: email, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack)),
                    if(phone != null)
                      TextSpan(text: phone, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack)),
                  ],
                ),
              ),
              SizedBox(height: 15.h,),
              RoundButton(
                child: const Text("Ok", style: TextStyle(fontSize: 16, fontFamily: "Regular"),),
                borderRadius: 9,
                onPressed: () {
                  Navigator.pop(context);
                  if(onOkClicked != null) onOkClicked!();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
