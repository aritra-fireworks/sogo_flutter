import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/auth/check_migrate_user_response.dart';
import 'package:sogo_flutter/src/screens/auth/create_new_account.dart';
import 'package:sogo_flutter/src/screens/auth/login_view.dart';
import 'package:sogo_flutter/src/screens/auth/migration/account_not_found_popup.dart';
import 'package:sogo_flutter/src/screens/auth/migration/activation_link_sent_popup.dart';
import 'package:sogo_flutter/src/screens/auth/migration/check_user_exists_popup.dart';
import 'package:sogo_flutter/src/screens/auth/migration/migrate_to_new_sogo_card_form_view.dart';
import 'package:sogo_flutter/src/screens/auth/sign_up_view.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

enum MigrationType {
  login,
  register
}

class MigrationOptionScreen extends StatefulWidget {
  final MigrationType migrationType;
  const MigrationOptionScreen({Key? key, required this.migrationType}) : super(key: key);

  @override
  State<MigrationOptionScreen> createState() => _MigrationOptionScreenState();
}

class _MigrationOptionScreenState extends State<MigrationOptionScreen> {

  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      progressIndicator: LoadingIndicator(
        indicatorType: Indicator.ballScale,
        colors: [AppColors.primaryRed, AppColors.secondaryRed],
      ),
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.cancel_sharp, color: AppColors.primaryRed,))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/my_sogo_logo.png", width: size.width/3, fit: BoxFit.fitWidth),
              SizedBox(height: 40.h,),
              Text("Migrate using the below option", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
              SizedBox(height: 15.h,),
              RoundButton(
                onPressed: (){
                  AppUtils.showCustomDialog(context: context, dialogBox: CheckUserExistsPopup(controller: _emailController, onClickNext: () async {
                    if(_emailController.text.trim().isEmpty){
                      AppUtils.showToast("Enter your email address");
                    } else if(!_emailController.text.trim().isEmail()){
                      AppUtils.showToast("Please enter a valid email");
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      CheckMigrateUserModel? response = await authManager.checkMigrateUser(type: widget.migrationType.name, email: _emailController.text.trim());
                      setState(() {
                        isLoading = false;
                      });
                      if(response?.migratedUser == true){
                        AppUtils.showCustomDialog(context: context, dialogBox: ActivationLinkSentPopup(email: _emailController.text.trim(), onOkClicked: (){
                          Navigator.popUntil(context, ModalRoute.withName("/Onboarding"));
                        },));
                      } else {
                        AppUtils.showCustomDialog(context: context, dialogBox: AccountNotFoundPopup(message: response?.message??"", onOkClicked: (){
                          Navigator.popUntil(context, ModalRoute.withName("/Onboarding"));
                        },));
                      }
                    }
                  },));
                },
                borderRadius: 9,
                child: const Text("Email Address", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
              ),
              SizedBox(height: 10.h,),
              RoundButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MigrateToNewSogoCardView(),));
                },
                borderRadius: 9,
                child: const Text("Member Card Number", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
              ),
            ],
          ),
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

extension on String {
  bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}