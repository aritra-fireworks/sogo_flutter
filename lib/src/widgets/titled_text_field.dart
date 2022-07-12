import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';

class TitledTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String title;
  final bool? isMandatory;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization? textCapitalization;
  final bool? obscureText;
  final int? multiline;
  final bool? enabled;
  const TitledTextField({Key? key, required this.controller, required this.hintText, required this.keyboardType, required this.textInputAction, this.obscureText, this.multiline, required this.title, this.isMandatory = true, this.focusNode, this.textCapitalization = TextCapitalization.none, this.enabled = true}) : super(key: key);

  @override
  State<TitledTextField> createState() => _TitledTextFieldState();
}

class _TitledTextFieldState extends State<TitledTextField> {

  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    if(widget.obscureText != null){
      isObscure = widget.obscureText!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: widget.title, style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamMedium")),
                if(widget.isMandatory??true) TextSpan(text: "*", style: TextStyle(color: AppColors.primaryRed, fontSize: 16.sp, fontFamily: "Medium")),
              ],
            ),
          ),
          SizedBox(height: 6.h,),
          SizedBox(
            height: 40,
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              textInputAction: widget.textInputAction,
              keyboardType: widget.keyboardType,
              textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
              obscureText: isObscure,
              enabled: widget.enabled,
              maxLines: isObscure ? 1 : widget.multiline,
              style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamRegular"),
              decoration: InputDecoration(
                suffixIcon: widget.obscureText != null ? IconButton(onPressed: (){
                  setState(() {
                    isObscure = !isObscure;
                  });
                }, icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textGrey,)) : const SizedBox(),
                suffixIconColor: const Color(0xFFD1D1D1),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 11.h),
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp, fontFamily: "GothamRegular"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
