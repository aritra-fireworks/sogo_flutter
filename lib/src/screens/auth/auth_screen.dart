import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/screens/auth/create_new_account.dart';
import 'package:sogo_flutter/src/screens/auth/login_view.dart';
import 'package:sogo_flutter/src/screens/auth/migration/migration_options_screen.dart';
import 'package:sogo_flutter/src/screens/auth/sign_up_view.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/my_sogo_logo.png", width: size.width/3, fit: BoxFit.fitWidth),
            SizedBox(height: 20.h,),
            RoundButton(
              onPressed: (){
                openLogin(context);
              },
              borderRadius: 9,
              child: const Text("Login", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
            ),
            SizedBox(height: 10.h,),
            RoundOutlineButton(
              onPressed: (){
                openSignUp(context);
              },
              borderRadius: 9,
              child: const Text("Sign Up", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: AppColors.textBlack),),
            ),
            SizedBox(height: 20.h,),
            RichText(text: TextSpan(text: "Transfer Existing Sogo Card to New Sogo Card", style: const TextStyle(decoration: TextDecoration.underline, color: Color(0xFF434343), fontFamily: "GothamRegular"), recognizer: TapGestureRecognizer()..onTap = (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MigrationOptionScreen(migrationType: MigrationType.register),));
            }),),
          ],
        ),
      ),
    );
  }

  openLogin(BuildContext context){
    AppUtils.openBottomSheet(context: context, child: const LoginView(),).then((value){
      debugPrint("login popped: $value");
      if(value == true) {
        debugPrint("Login Popped");
        openSignUp(context);
      }
    });
  }

  openSignUp(BuildContext context){
    AppUtils.openBottomSheet(context: context, child: const SignUpView(),).then((value) {
      debugPrint("signup popped: $value");
      if(value == true) {
        openLogin(context);
      } else if(value == false) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateNewAccountView(),));
      }
    });
  }
}
