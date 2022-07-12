import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/manage_password/reset_link_sent_popup.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';


class ResetViaPhonePopUp extends StatefulWidget {
  final BuildContext previousContext;
  const ResetViaPhonePopUp({Key? key, required this.previousContext}) : super(key: key);

  @override
  State<ResetViaPhonePopUp> createState() => _ResetViaPhonePopUpState();
}

class _ResetViaPhonePopUpState extends State<ResetViaPhonePopUp> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  PhoneNumber _number = PhoneNumber(isoCode: "MY");
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissWrapper(
      child: Material(
        borderRadius: BorderRadius.circular(13),
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              margin: const EdgeInsets.all(25),
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
                  Text("Enter Your Phone Number", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 20.sp, fontFamily: "GothamMedium"),),
                  SizedBox(height: 30.h,),
                  Text("Please enter your phone number for us to send the instruction via SMS in order to retrieving your account password.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBook"),),
                  SizedBox(height: 30.h,),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.grey, width: 1.sp))
                    ),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (value) {
                        _number = value;
                      },
                      onInputValidated: (bool value) {

                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        showFlags: false,
                        trailingSpace: false,
                      ),
                      ignoreBlank: true,
                      inputDecoration: InputDecoration(
                          hintText: "Enter your phone number",
                          hintStyle: TextStyle(color: const Color(0xFF919191), fontSize: 15.sp, fontFamily: "GothamRegular"),
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          icon: const Icon(Icons.arrow_drop_down, color: AppColors.lightBlack,)
                      ),
                      maxLength: 12,
                      spaceBetweenSelectorAndTextField: 0,
                      textAlignVertical: TextAlignVertical.top,
                      autoValidateMode: AutovalidateMode.disabled,
                      selectorTextStyle: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),
                      textStyle: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),
                      initialValue: _number,
                      textFieldController: _phoneController,
                      focusNode: _phoneFocus,
                      formatInput: false,
                      keyboardType: TextInputType.phone,
                      keyboardAction: TextInputAction.done,
                      onSaved: (PhoneNumber number) {
                        debugPrint('On Saved: $number');
                      },
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  RoundButton(onPressed: () async {
                    if(_phoneController.text.trim().isEmpty || _phoneController.text.trim().length < 8 || int.tryParse(_phoneController.text.trim()) is! int){
                      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid phone number", onOk: (){
                        _phoneFocus.requestFocus();
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      CommonResponseModel? passwordResetResponse = await authManager.resetPassword(phone: _phoneController.text, phoneCountry: _number.dialCode?.replaceAll("+", ""));
                      setState(() {
                        isLoading = false;
                      });
                      if(passwordResetResponse?.status == "success") {
                        Navigator.pop(context);
                        AppUtils.showCustomDialog(context: widget.previousContext, dialogBox: ResetLinkSentPopUp(message: passwordResetResponse?.message,));
                      } else {
                        AppUtils.showMessage(context: widget.previousContext, title: "Failed!", message: passwordResetResponse?.message??"Failed to send SMS link. Try again.", onOk: (){});
                      }
                    }
                  },
                    borderRadius: 9,
                    child: Text("Next", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),),
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
            isLoading ? Container(color: AppColors.lightBlack.withOpacity(0.3), alignment: Alignment.center, child: CircularProgressIndicator(color: AppColors.primaryRed,)) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
