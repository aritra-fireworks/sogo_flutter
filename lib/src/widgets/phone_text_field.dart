import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String title;
  final bool? isMandatory;
  final String hintText;
  final PhoneNumber number;
  final Function(PhoneNumber) onInputChanged;
  final bool isEnabled;
  final TextInputAction textInputAction;
  const PhoneTextField({Key? key, required this.controller, required this.hintText, required this.onInputChanged, required this.number, this.isEnabled=true, this.textInputAction = TextInputAction.next, required this.title, this.isMandatory, this.focusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: title, style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamMedium")),
                if(isMandatory??true) TextSpan(text: "*", style: TextStyle(color: AppColors.primaryRed, fontSize: 16.sp, fontFamily: "GothamMedium")),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp))
            ),
            height: 50,
            alignment: Alignment.center,
            child: InternationalPhoneNumberInput(
              onInputChanged: onInputChanged,
              onInputValidated: (bool value) {

              },
              isEnabled: isEnabled,
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
                showFlags: false,
                trailingSpace: false,
              ),
              ignoreBlank: true,
              inputDecoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp, fontFamily: "GothamRegular"),
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                icon: const Icon(Icons.arrow_drop_down, color: AppColors.textBlack,)
              ),
              maxLength: 12,
              spaceBetweenSelectorAndTextField: 0,
              textAlignVertical: TextAlignVertical.top,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamRegular"),
              textStyle: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamRegular"),
              initialValue: number,
              textFieldController: controller,
              focusNode: focusNode,
              formatInput: false,
              keyboardType: TextInputType.phone,
              keyboardAction: textInputAction,
              onSaved: (PhoneNumber number) {
                debugPrint('On Saved: $number');
              },
            ),
          ),
        ],
      ),
    );
  }
}
