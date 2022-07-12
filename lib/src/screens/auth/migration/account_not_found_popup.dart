import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class AccountNotFoundPopup extends StatelessWidget {
  final VoidCallback? onOkClicked;
  final String message;
  const AccountNotFoundPopup({Key? key, this.onOkClicked, required this.message}) : super(key: key);

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
              Text("Account Not Found!", style: TextStyle(fontFamily: "GothamBold", fontSize: 15.sp, color: AppColors.lightBlack),),
              SizedBox(height: 20.h,),
              Text(message.trim().isNotEmpty ? message : 'We did not find your email, please check the email and try again or register a new account.', style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack)),
              SizedBox(height: 20.h,),
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
