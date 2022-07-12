import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/manage_password/reset_link_sent_popup.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';


class ResetViaEmailPopUp extends StatefulWidget {
  final BuildContext previousContext;
  const ResetViaEmailPopUp({Key? key, required this.previousContext}) : super(key: key);

  @override
  State<ResetViaEmailPopUp> createState() => _ResetViaEmailPopUpState();
}

class _ResetViaEmailPopUpState extends State<ResetViaEmailPopUp> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
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
                  Text("Enter Your Email Address", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 20.sp, fontFamily: "GothamMedium"),),
                  SizedBox(height: 30.h,),
                  Text("Please enter your email for us to send the instruction for reset your account password.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBook"),),
                  SizedBox(height: 30.h,),
                  TextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
                      hintStyle: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: const Color(0xFF919191)),
                      hintText: "Enter your email",
                    ),
                  ),
                  SizedBox(height: 30.h,),
                  RoundButton(onPressed: () async {
                    if(_emailController.text.trim().isEmpty){
                      AppUtils.showMessage(context: widget.previousContext, title: "Validation Error!", message: "Enter your email address", onOk: (){
                        _emailFocus.requestFocus();
                      });
                    } else if(!_emailController.text.trim().isEmail()){
                      AppUtils.showMessage(context: widget.previousContext, title: "Validation Error!", message: "Please enter a valid email", onOk: (){
                        _emailFocus.requestFocus();
                      });
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      CommonResponseModel? passwordResetResponse = await authManager.resetPassword(email: _emailController.text);
                      setState(() {
                        isLoading = false;
                      });
                      if(passwordResetResponse?.status == "success") {
                        Navigator.pop(context);
                        AppUtils.showCustomDialog(context: widget.previousContext, dialogBox: ResetLinkSentPopUp(message: passwordResetResponse?.message,));
                      } else {
                        AppUtils.showMessage(context: widget.previousContext, title: "Failed!", message: passwordResetResponse?.message??"Failed to send email link. Try again.", onOk: (){});
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

extension on String {
  bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}