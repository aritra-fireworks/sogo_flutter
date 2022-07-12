import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';


class ResetLinkSentPopUp extends StatefulWidget {
  final String? message;
  const ResetLinkSentPopUp({Key? key, this.message}) : super(key: key);

  @override
  State<ResetLinkSentPopUp> createState() => _ResetLinkSentPopUpState();
}

class _ResetLinkSentPopUpState extends State<ResetLinkSentPopUp> {

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
              SizedBox(height: 10.h,),
              Text("Reset Password", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 20.sp, fontFamily: "GothamMedium"),),
              SizedBox(height: 30.h,),
              Text(widget.message ?? "A verification link has been sent to your email.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBook"),),
              SizedBox(height: 30.h,),
              RoundButton(onPressed: () async {
                Navigator.pop(context);
              },
                borderRadius: 9,
                child: Text("OK", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),),
              ),
              SizedBox(height: 20.h,),
            ],
          ),
        ),
      ),
    );
  }
}

extension on String {
  bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}