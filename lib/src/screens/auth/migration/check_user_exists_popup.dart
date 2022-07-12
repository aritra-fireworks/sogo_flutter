import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class CheckUserExistsPopup extends StatelessWidget {
  final VoidCallback? onClickNext;
  final TextEditingController controller;
  CheckUserExistsPopup({Key? key, this.onClickNext, required this.controller}) : super(key: key);

  final FocusNode _textFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.cancel_sharp, color: AppColors.primaryRed,)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("We will send you a link to activate your new membership card. Please enter the email that was registered with the existing membership card.", style: TextStyle(fontFamily: "GothamBook", fontSize: 15.sp, color: AppColors.lightBlack),),
                  SizedBox(height: 20.h,),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: controller,
                      focusNode: _textFocus,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamRegular"),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.sp)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.sp)),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.sp)),
                        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2.sp)),
                        isDense: true,
                        hintText: "Enter your email address",
                        hintStyle: TextStyle(color: AppColors.lightBlack.withOpacity(0.5), fontSize: 15.sp, fontFamily: "GothamBook"),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h,),
                  RoundButton(
                    child: const Text("Next", style: TextStyle(fontSize: 16, fontFamily: "Regular"),),
                    borderRadius: 9,
                    onPressed: () {
                      if(controller.text.isEmpty) {
                        AppUtils.showToast("Please enter your email address");
                        _textFocus.requestFocus();
                      } else if(!controller.text.trim().isEmail()){
                        AppUtils.showToast("Please enter a valid email address");
                        _textFocus.requestFocus();
                      } else {
                        Navigator.pop(context);
                        if(onClickNext != null) onClickNext!();
                      }
                    },
                  ),
                  SizedBox(height: 15.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}