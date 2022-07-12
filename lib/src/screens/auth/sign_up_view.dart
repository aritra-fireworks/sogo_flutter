import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/social_auth_manager.dart';
import 'package:sogo_flutter/src/screens/auth/create_new_account.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/nav_bar_view.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h,),
              Image.asset("assets/images/my_sogo_logo.png", width: size.width/3, fit: BoxFit.fitWidth),
              SizedBox(height: 20.h,),
              const Text("Register As Member", style: TextStyle(color: Color(0xFF080808), fontSize: 20, fontFamily: "GothamMedium"),),
              SizedBox(height: 30.h,),
              RoundButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                borderRadius: 8,
                child: const Text("Sign Up with Email", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
              ),
              SizedBox(height: 40.h,),
              Text("Or Continue With", style: TextStyle(fontFamily: "GothamBook", fontSize: 13.sp, color: AppColors.textBlack),),
              SizedBox(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loginOptions(imagePath: "assets/images/ic_facebook.png", onTap: (){}),
                  loginOptions(imagePath: "assets/images/ic_google.png", onTap: () async => googleLogin(context)),
                  if(Platform.isIOS)
                    loginOptions(imagePath: "assets/images/ic_apple.png", onTap: (){}),
                ],
              ),
              SizedBox(height: 10.h,),
              RichText(text: TextSpan(children: [
                TextSpan(text: "Have Account? ", style: TextStyle(color: const Color(0xFF434343), fontSize: 13.sp, fontFamily: "GothamBook")),
                TextSpan(text: "Login Here", style: TextStyle(color: const Color(0xFF434343), decoration: TextDecoration.underline, fontSize: 13.sp, fontFamily: "GothamBook"), recognizer: TapGestureRecognizer()..onTap = (){
                  Navigator.pop(context, true);
                }),
              ],),),
            ],
          ),
        ),
        isLoading ? const Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ) : const SizedBox(),
      ],
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

  Future<void> googleLogin(BuildContext context) async {
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
}
