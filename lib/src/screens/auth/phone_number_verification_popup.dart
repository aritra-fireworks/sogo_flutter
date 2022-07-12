import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/phone_text_field.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';

class PhoneNumberVerificationPopup extends StatefulWidget {
  final Function(PhoneNumber) onNext;
  final VoidCallback onSkip;
  const PhoneNumberVerificationPopup({Key? key, required this.onNext, required this.onSkip}) : super(key: key);

  @override
  State<PhoneNumberVerificationPopup> createState() => _PhoneNumberVerificationPopupState();
}

class _PhoneNumberVerificationPopupState extends State<PhoneNumberVerificationPopup> {

  late TextEditingController _mobileController;
  late FocusNode _mobileFocus;

  PhoneNumber number = PhoneNumber(isoCode: 'MY');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _mobileFocus = FocusNode();
  }

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
              Text("Phone Number Verification", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: AppColors.lightBlack),),
              SizedBox(height: 30.h,),
              Text("We need to verify the authenticity of your account before you can perform this action", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
              SizedBox(height: 20.h,),
              PhoneTextField(
                controller: _mobileController,
                focusNode: _mobileFocus,
                title: "",
                isMandatory: false,
                hintText: "Enter your phone number",
                number: number,
                onInputChanged: (PhoneNumber phone){
                  if(number != phone){
                    number = phone;
                  }
                },
              ),
              SizedBox(height: 20.h,),
              RoundButton(onPressed: (){
                if(_mobileController.text.trim().isEmpty || _mobileController.text.trim().length < 8 || int.tryParse(_mobileController.text.trim()) is! int){
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid phone number", onOk: (){
                    _mobileFocus.requestFocus();
                  });
                } else {
                  Navigator.pop(context);
                  widget.onNext(number);
                }
              }, borderRadius: 9, child: Text("Next", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),),),
              SizedBox(height: 10.h,),
              RoundOutlineButton(onPressed: (){
                Navigator.pop(context);
                widget.onSkip();
              }, borderRadius: 9, child: Text("Skip for Now", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamBold", color: AppColors.lightBlack),),),
            ],
          ),
        ),
      ),
    );
  }
}
