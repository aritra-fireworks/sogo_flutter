import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/managers/auth_manager/social_auth_manager.dart';
import 'package:sogo_flutter/src/models/auth/check_migrate_user_response.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/screens/auth/create_new_account.dart';
import 'package:sogo_flutter/src/screens/auth/forget_password/reset_via_email_popup.dart';
import 'package:sogo_flutter/src/screens/auth/forget_password/reset_via_sms_popup.dart';
import 'package:sogo_flutter/src/screens/auth/forget_password/verification_link_sent_popup.dart';
import 'package:sogo_flutter/src/screens/auth/migration/account_not_found_popup.dart';
import 'package:sogo_flutter/src/screens/auth/migration/existing_sogo_card_member_view.dart';
import 'package:sogo_flutter/src/screens/auth/migration/migration_options_screen.dart';
import 'package:sogo_flutter/src/screens/auth/forget_password/reset_password_options_popup.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/nav_bar_view.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _resetPasswordEmailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return KeyboardDismissWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h,),
                  Image.asset("assets/images/my_sogo_logo.png", width: size.width/3, fit: BoxFit.fitWidth),
                  SizedBox(height: 20.h,),
                  const Text("Login", style: TextStyle(color: Color(0xFF080808), fontSize: 20, fontFamily: "GothamMedium"),),
                  SizedBox(height: 10.h,),
                  TitledTextField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    title: "Email",
                    hintText: "Enter your registered email",
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                  ),
                  TitledTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    title: "Password",
                    hintText: "Enter your password",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 6.h,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(text: TextSpan(text: "Forgot Password?", style: TextStyle(color: AppColors.textBlack.withOpacity(0.47), fontSize: 15.sp, fontFamily: "GothamBook"), recognizer: TapGestureRecognizer()..onTap = (){
                      AppUtils.showCustomDialog(context: context, dialogBox: ResetPasswordOptionsPopup(
                        onViaEmailClicked: (){
                          AppUtils.showCustomDialog(context: context, dialogBox: ResetViaEmailPopup(controller: _resetPasswordEmailController, onClickNext: () async {
                            setState(() {
                              isLoading = true;
                            });
                            CommonResponseModel? response = await authManager.resetPassword(email: _resetPasswordEmailController.text.trim());
                            setState(() {
                              isLoading = false;
                            });
                            if(response?.status == "success") {
                              AppUtils.showCustomDialog(context: context, dialogBox: VerificationLinkSentPopup(email: _resetPasswordEmailController.text.trim(), onOkClicked: (){
                                _resetPasswordEmailController.clear();
                              },));
                            } else {
                              AppUtils.showCustomDialog(context: context, dialogBox: AccountNotFoundPopup(message: response?.message??"", onOkClicked: (){
                                _resetPasswordEmailController.clear();
                              },));
                            }
                          },));
                        },
                        onViaSMSClicked: (){
                          AppUtils.showCustomDialog(context: context, dialogBox: ResetViaPhonePopup(controller: _numberController, onClickNext: (PhoneNumber number) async {
                            setState(() {
                              isLoading = true;
                            });
                            CommonResponseModel? response = await authManager.resetPassword(phoneCountry: number.dialCode?.replaceAll("+", ""), phone: number.phoneNumber?.replaceAll(number.dialCode ?? "+", ""));
                            setState(() {
                              isLoading = false;
                            });
                            if(response?.status == "success") {
                              AppUtils.showCustomDialog(context: context, dialogBox: VerificationLinkSentPopup(phone: number.phoneNumber,));
                            } else {
                              AppUtils.showCustomDialog(context: context, dialogBox: AccountNotFoundPopup(message: response?.message??"",));
                            }
                          },));
                        },
                      ));
                    }),),
                  ),
                  SizedBox(height: 20.h,),
                  Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: RoundButton(
                      onPressed: () => login(context),
                      borderRadius: 9,
                      child: const Text("Login", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 60.h,),
                  Text("Or Continue With", style: TextStyle(fontFamily: "GothamBook", fontSize: 13.sp, color: AppColors.textBlack),),
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      loginOptions(imagePath: "assets/images/ic_facebook.png", onTap: () => facebookLogin(context)),
                      loginOptions(imagePath: "assets/images/ic_google.png", onTap: () => googleLogin(context)),
                      if(Platform.isIOS)
                        loginOptions(imagePath: "assets/images/ic_apple.png", onTap: () => appleLogin(context)),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  RichText(text: TextSpan(children: [
                      TextSpan(text: "Don’t Have Account? ", style: TextStyle(color: const Color(0xFF434343), fontSize: 13.sp, fontFamily: "GothamBook")),
                      TextSpan(text: "Sign Up Here", style: TextStyle(color: const Color(0xFF434343), decoration: TextDecoration.underline, fontSize: 13.sp, fontFamily: "GothamBook"), recognizer: TapGestureRecognizer()..onTap = (){
                        Navigator.pop(context, true);
                      }),
                  ]),),
                ],
              ),
            ),
            isLoading ? const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget loginOptions({required String imagePath, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(imagePath, height: 50.sp, width: 50.sp),
      ),
    );
  }

  void login(BuildContext context) async {
    if(_emailController.text.trim().isEmpty){
      AppUtils.showToast("Enter your email address");
    } else if(!_emailController.text.trim().isEmail()){
      AppUtils.showToast("Please enter a valid email address");
    } else {
      setState(() {
        isLoading = true;
      });
      CheckMigrateUserModel? response = await authManager.checkMigrateUser(type: "login", email: _emailController.text.trim());
      if(response?.migratedUser == true){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ExistingSogoCardScreen(migrationType: MigrationType.login),));
      } else {
        await authManager.login(email: _emailController.text, password: _passwordController.text).then((value) {
          if(value?.status == "success"){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBarView(),));
          } else {
            AppUtils.showMessage(context: context, title: "Error!", message: value?.message??"Error logging in. Try again.");
          }
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void googleLogin(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await socialAuthManager.googleSignIn(newSignIn: true).then((value) {
      if(value?.status == "success"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBarView(),));
      } else if(value?.message?.contains("not registered") ?? false){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewAccountView(isSocialSignUp: true),));
      } else {
        AppUtils.showMessage(context: context, title: "Error!", message: value?.message??"Error logging in. Try again.");
      }
    });
    setState(() {
      isLoading = false;
    });
  }
  
  void facebookLogin(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await socialAuthManager.facebookSignIn(newSignIn: true).then((value) {
      if(value?.status == "success"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBarView(),));
      } else if(value?.message?.contains("not registered") ?? false){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewAccountView(isSocialSignUp: true),));
      } else {
        AppUtils.showMessage(context: context, title: "Error!", message: value?.message??"Error logging in. Try again.");
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void appleLogin(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await socialAuthManager.signInWithApple().then((value) {
      if(value?.status == "success"){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBarView(),));
      } else if(value?.message?.contains("not registered") ?? false){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewAccountView(isSocialSignUp: true),));
      } else {
        AppUtils.showMessage(context: context, title: "Error!", message: value?.message??"Error logging in. Try again.");
      }
    });
    setState(() {
      isLoading = false;
    });
  }
}

extension on String {
  bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}