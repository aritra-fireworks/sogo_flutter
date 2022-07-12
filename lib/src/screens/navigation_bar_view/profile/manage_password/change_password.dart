import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext buildContext) {
    return KeyboardDismissWrapper(
      child: ModalProgressHUD(
        progressIndicator: LoadingIndicator(
          indicatorType: Indicator.ballScale,
          colors: [AppColors.primaryRed, AppColors.secondaryRed],
        ),
        inAsyncCall: isLoading,
        child: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
              ) {
            if (connectivity == ConnectivityResult.none) {
              return const Scaffold(
                body: Center(child: NetworkErrorPage()),
              );
            }
            return child;
          },
          child: Stack(
            children: [
              Container(
                height: 200.h,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
                    onPressed: () {
                      Navigator.pop(buildContext);
                    },
                  ),
                  centerTitle: true,
                  title: Text("Change Password", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
                ),
                body: changePasswordBody(buildContext),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget changePasswordBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
        child: Column(
          children: [
            Text("Please enter your new password below. Minimum 8 characters at least 1 alphabet, 1 number and 1 special character", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
            SizedBox(height: 30.h,),
            TitledTextField(
              controller: _oldPasswordController,
              focusNode: _oldPasswordFocus,
              title: "Old Password",
              hintText: "Enter your old password",
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            TitledTextField(
              controller: _newPasswordController,
              focusNode: _newPasswordFocus,
              title: "New Password",
              hintText: "Enter your new password",
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            TitledTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocus,
              title: "Confirm Password",
              hintText: "Enter your password again",
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 30.h,),
            RoundButton(
              child: const Text("Next", style: TextStyle(fontSize: 16, fontFamily: "Regular"),),
              borderRadius: 9,
              onPressed: () async {
                if(_oldPasswordController.text.trim().isEmpty){
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter old password.", onOk: (){
                    _oldPasswordFocus.requestFocus();
                  });
                } else if(_newPasswordController.text.trim().isEmpty){
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter new password.", onOk: (){
                    _newPasswordFocus.requestFocus();
                  });
                } else if(!_newPasswordController.text.trim().isValidPassword()) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter valid password.", onOk: (){
                    _newPasswordFocus.requestFocus();
                  });
                } else if(_confirmPasswordController.text.trim().isEmpty) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter confirm password.", onOk: (){
                    _confirmPasswordFocus.requestFocus();
                  });
                } else if(_confirmPasswordController.text.trim() != _newPasswordController.text.trim()) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Confirmed password does not match. Please try again.", onOk: (){
                    _confirmPasswordFocus.requestFocus();
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  CommonResponseModel? registerResponse = await authManager.changePassword(newPassword: _newPasswordController.text, oldPassword: _oldPasswordController.text);
                  setState(() {
                    isLoading = false;
                  });
                  if(registerResponse?.status == "success") {
                    AppUtils.showMessage(context: context, title: "Success!", message: registerResponse?.message??"Password changed successfully!", onOk: (){
                      int count = 0;
                      Navigator.popUntil(context, (route) => count++ >= 2);
                    });
                  } else {
                    AppUtils.showMessage(context: context, title: "Failed!", message: registerResponse?.message??"Failed to change the password. Try again.", onOk: (){});
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

extension on String {
  bool isValidPassword() => RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*[~`!@#$%^&*()_+=|:;<,>.?/]).{8,}$').hasMatch(this);
}