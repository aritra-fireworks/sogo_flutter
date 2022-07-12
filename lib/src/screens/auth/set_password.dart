import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/auth/points_details_model.dart';
import 'package:sogo_flutter/src/models/auth/register_response.dart';
import 'package:sogo_flutter/src/screens/auth/account_created_popup.dart';
import 'package:sogo_flutter/src/screens/auth/complete_your_profile.dart';
import 'package:sogo_flutter/src/screens/auth/migration/new_card_registered_view.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';

class SetPasswordScreen extends StatefulWidget {
  final bool isMigration;
  const SetPasswordScreen({Key? key, this.isMigration = false}) : super(key: key);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.text = ApplicationGlobal.password??"";
    _confirmPasswordController.text = ApplicationGlobal.password??"";
    authManager.getPointsDetails();
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
                    title: Text("Password", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
                  ),
                  body: WillPopScope(
                    onWillPop: () async => false,
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
                        child: setPasswordBody(buildContext)),
                  )),
            ],
          )),
    );
  }

  Widget setPasswordBody(BuildContext buildContext) {
    Size size = MediaQuery.of(buildContext).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SizedBox(
            height: size.height - 65 - 60.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Please enter your new password.\n\nPassword must have at least 8 characters and contain uppercase, lowercase, numbers and symbols.", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
                SizedBox(height: 30.h,),
                TitledTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  title: "New Password",
                  hintText: "Enter your password",
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                ),
                TitledTextField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  title: "Confirm Password",
                  hintText: "Re-type your password",
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                ),
                const Spacer(),
                StreamBuilder<ApiResponse<PointsDetailsModel>?>(
                    stream: authManager.pointsDetails,
                    builder: (BuildContext context, AsyncSnapshot<ApiResponse<PointsDetailsModel>?> snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.data!.status) {
                          case Status.LOADING:
                            debugPrint('Loading');
                            return const SizedBox();
                          case Status.COMPLETED:
                            debugPrint('Points details Loaded');
                            String? registerPoints = snapshot.data?.data?.register;
                            return RoundButton(
                              child: const Text("Next", style: TextStyle(fontSize: 16, fontFamily: "Regular"),),
                              borderRadius: 9,
                              onPressed: () async {
                                if(_passwordController.text.trim().isEmpty){
                                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter password.", onOk: (){
                                    _passwordFocus.requestFocus();
                                  });
                                } else if(!_passwordController.text.trim().isValidPassword()) {
                                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter valid password.", onOk: (){
                                    _passwordFocus.requestFocus();
                                  });
                                } else if(_confirmPasswordController.text.trim().isEmpty) {
                                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter confirm password.", onOk: (){
                                    _confirmPasswordFocus.requestFocus();
                                  });
                                } else if(_confirmPasswordController.text.trim() != _passwordController.text.trim()) {
                                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Confirmed password does not match. Please try again.", onOk: (){
                                    _confirmPasswordFocus.requestFocus();
                                  });
                                } else {
                                  ApplicationGlobal.password = _passwordController.text;
                                  setState(() {
                                    isLoading = true;
                                  });
                                  RegisterResponseModel? registerResponse = await authManager.register();
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if(registerResponse?.status == "success") {
                                    if(widget.isMigration){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCardRegisteredView(),));
                                    } else {
                                      AppUtils.showCustomDialog(context: buildContext, withConfetti: true, dialogBox: AccountCreatedPopup(message: "You have been rewarded $registerPoints Pts.", onOk: (){
                                        Navigator.push(buildContext, MaterialPageRoute(builder: (context) => CompleteYourProfileScreen(context: buildContext),));
                                      },));
                                    }
                                  } else {
                                    AppUtils.showMessage(context: buildContext, title: "Validation Error!", message: registerResponse?.message??"OTP was not verified. Try again.", onOk: (){});
                                  }
                                }
                              },
                            );
                          case Status.NODATAFOUND:
                            debugPrint('Not found');
                            return const SizedBox();
                          case Status.ERROR:
                            debugPrint('Error');
                            return const SizedBox();
                        }
                      }
                      return Container();
                    }),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on String {
  bool isValidPassword() => RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[~`!@#$%^&*()_+=|:;<,>.?/]).{8,}$').hasMatch(this);
}