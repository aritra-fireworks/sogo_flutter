import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/phone_text_field.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

// ignore: must_be_immutable
class ResetViaPhonePopup extends StatelessWidget {
  final Function(PhoneNumber)? onClickNext;
  final TextEditingController controller;
  ResetViaPhonePopup({Key? key, this.onClickNext, required this.controller}) : super(key: key);

  final FocusNode _focusNode = FocusNode();
  PhoneNumber number = PhoneNumber(isoCode: 'MY');
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
                  Text("Enter Your Phone Number", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamMedium", fontSize: 20.sp, color: AppColors.lightBlack),),
                  SizedBox(height: 30.h,),
                  Text("Please enter your phone number for us to send the instruction via SMS in order to retrieving your account password.", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamBook", fontSize: 15.sp, color: AppColors.lightBlack),),
                  SizedBox(height: 30.h,),
                  PhoneTextField(
                    controller: controller,
                    focusNode: _focusNode,
                    title: "Phone",
                    hintText: "Enter your Phone Number",
                    number: number,
                    textInputAction: TextInputAction.done,
                    onInputChanged: (PhoneNumber phone){
                      if(number != phone){
                        number = phone;
                        debugPrint(phone.isoCode);
                        debugPrint(phone.dialCode);
                        debugPrint(phone.phoneNumber);
                      }
                    },
                  ),
                  SizedBox(height: 30.h,),
                  RoundButton(
                    child: const Text("Next", style: TextStyle(fontSize: 16, fontFamily: "Regular"),),
                    borderRadius: 9,
                    onPressed: () {
                      if(controller.text.trim().isEmpty || controller.text.trim().length < 8 || int.tryParse(controller.text.trim()) is! int){
                        AppUtils.showToast("Please enter a valid phone number");
                      } else {
                        Navigator.pop(context);
                        if(onClickNext != null) onClickNext!(number);
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