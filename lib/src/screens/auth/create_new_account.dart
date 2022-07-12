import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/auth/check_migrate_user_response.dart';
import 'package:sogo_flutter/src/models/auth/points_details_model.dart';
import 'package:sogo_flutter/src/models/auth/register_response.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/screens/auth/account_created_popup.dart';
import 'package:sogo_flutter/src/screens/auth/migration/existing_sogo_card_member_view.dart';
import 'package:sogo_flutter/src/screens/auth/migration/migration_options_screen.dart';
import 'package:sogo_flutter/src/screens/auth/otp_verification_screen.dart';
import 'package:sogo_flutter/src/screens/auth/phone_number_verification_popup.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/nav_bar_view.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/checkbox.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/phone_text_field.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';

class CreateNewAccountView extends StatefulWidget {
  final bool isSocialSignUp;
  const CreateNewAccountView({Key? key, this.isSocialSignUp = false}) : super(key: key);

  @override
  State<CreateNewAccountView> createState() => _CreateNewAccountViewState();
}

class _CreateNewAccountViewState extends State<CreateNewAccountView> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _referralFocus = FocusNode();

  PhoneNumber number = PhoneNumber(isoCode: 'MY');
  bool pdpa = false;
  bool news = false;
  bool hasReferral = false;

  String registerPoints = "";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = ApplicationGlobal.firstName??"";
    _lastNameController.text = ApplicationGlobal.lastName??"";
    _phoneController.text = ApplicationGlobal.phone?.phoneNumber?.replaceAll(ApplicationGlobal.phone?.dialCode??"+", "")??"";
    _emailController.text = ApplicationGlobal.email??"";
    authManager.getPointsDetails();
  }

  @override
  Widget build(BuildContext context) {
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
                        Navigator.pop(context);
                      },
                    ),
                    centerTitle: true,
                    title: Text("Create New Account", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
                  ),
                  body: WillPopScope(
                    onWillPop: () async => true,
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
                        child: createAccountBody(context)),
                  )),
            ],
          )),
    );
  }

  Widget createAccountBody(BuildContext context) {
    InputBorder inputBorder = OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp), borderRadius: BorderRadius.circular(5));
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TitledTextField(
              controller: _firstNameController,
              focusNode: _firstNameFocus,
              title: "First Name",
              hintText: "First Name",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            TitledTextField(
              controller: _lastNameController,
              focusNode: _lastNameFocus,
              title: "Last Name",
              hintText: "Last Name",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            TitledTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              title: "Email",
              hintText: "Email",
              enabled: !widget.isSocialSignUp,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
            ),
            if(!widget.isSocialSignUp)
              PhoneTextField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                title: "Phone",
                hintText: "Phone",
                number: number,
                textInputAction: TextInputAction.done,
                onInputChanged: (PhoneNumber phone){
                  if(number != phone){
                    number = phone;
                    debugPrint(phone.isoCode);
                    debugPrint(phone.dialCode);
                    debugPrint(phone.phoneNumber);
                  }
                },
              ),
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCheckbox(
                      alignment: Alignment.centerLeft,
                      value: hasReferral, onChanged: (value){
                      setState(() {
                        hasReferral = value;
                      });
                    },
                      label: Text("I have referral link", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, height: 1.4, fontFamily: "GothamMedium"),),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: hasReferral ? null : 0,
                      child: TextField(
                        controller: _referralController,
                        focusNode: _referralFocus,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        enabled: hasReferral,
                        textCapitalization: TextCapitalization.none,
                        style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamRegular"),
                        decoration: InputDecoration(
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder,
                          border: inputBorder,
                          errorBorder: inputBorder,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                          hintText: "Paste your referral link here",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp, height: 1.3, fontFamily: "GothamRegular"),
                        ),
                      ),
                    ),
                  ],
                );
              }
            ),
            SizedBox(height: 15.h,),
            StatefulBuilder(
              builder: (context, setState) {
                return AppCheckbox(
                  alignment: Alignment.centerLeft,
                  value: pdpa, onChanged: (value){
                  setState(() {
                    pdpa = value;
                  });
                },
                  label: Text("I understand and agree with the Terms & Conditions and Privacy Policy.", style: TextStyle(color: AppColors.lightBlack.withOpacity(0.4), fontSize: 15.sp, height: 1.4, fontFamily: "GothamBook"),),
                );
              }
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return AppCheckbox(
                  alignment: Alignment.centerLeft,
                  value: news, onChanged: (value){
                  setState(() {
                    news = value;
                  });
                },
                  label: Text("I agree to receive information about current events & promotions (optional).", style: TextStyle(color: AppColors.lightBlack.withOpacity(0.4), fontSize: 15.sp, height: 1.4, fontFamily: "GothamBook"),),
                );
              }
            ),
            const SizedBox(height: 30,),
            RoundButton(
              onPressed: () => verifyOtp(context),
              borderRadius: 9,
              child: const Text("Next", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
            ),
            SizedBox(height: 30.h,),
          ],
        ),
      ),
    );
  }

  verifyOtp(BuildContext context) async {
    if(_firstNameController.text.trim().isEmpty) {
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Enter your first name", onOk: (){
        _firstNameFocus.requestFocus();
      });
    } else if(_lastNameController.text.trim().isEmpty){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Enter your last name", onOk: (){
        _lastNameFocus.requestFocus();
      });
    } else if(_emailController.text.trim().isEmpty){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Enter your email address", onOk: (){
        _emailFocus.requestFocus();
      });
    } else if(!_emailController.text.trim().isEmail()){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid email", onOk: (){
        _emailFocus.requestFocus();
      });
    } else if(!widget.isSocialSignUp && (_phoneController.text.trim().isEmpty || _phoneController.text.trim().length < 8 || int.tryParse(_phoneController.text.trim()) is! int)){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid phone number", onOk: (){
        _phoneFocus.requestFocus();
      });
    } else if(!pdpa){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please agree to the terms & conditions to proceed.", onOk: (){});
    } else  if(hasReferral && _referralController.text.trim().isEmpty){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid referral code", onOk: (){
        _referralFocus.requestFocus();
      });
    } else {
      setState(() {
        isLoading = true;
      });
      CheckMigrateUserModel? response = await authManager.checkMigrateUser(type: "register", email: _emailController.text.trim());
      if(response?.migratedUser == true){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ExistingSogoCardScreen(migrationType: MigrationType.register),));
      } else {
        if(widget.isSocialSignUp){
          setState(() {
            isLoading = true;
          });
          RegisterResponseModel? registerResponse = await authManager.register();
          setState(() {
            isLoading = false;
          });
          StreamBuilder<ApiResponse<PointsDetailsModel>?>(
              stream: authManager.pointsDetails,
              builder: (BuildContext buildContext, AsyncSnapshot<ApiResponse<PointsDetailsModel>?> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      debugPrint('Loading');
                      break;
                    case Status.COMPLETED:
                      debugPrint('Points details Loaded');
                      String? registerPoints = snapshot.data?.data?.register;
                      this.registerPoints = registerPoints ?? "";
                      break;
                    case Status.NODATAFOUND:
                      debugPrint('Not found');
                      break;
                    case Status.ERROR:
                      debugPrint('Error');
                      break;
                  }
                }
                return Container();
              });
          if(registerResponse?.status == "success") {
            AppUtils.showCustomDialog(context: context, withConfetti: true, dialogBox: AccountCreatedPopup(message: "You have been rewarded $registerPoints Pts.", onOk: (){
              updatePhoneNumber();
            },));
          } else {
            AppUtils.showMessage(context: context, title: "Validation Error!", message: registerResponse?.message??"OTP was not verified. Try again.", onOk: (){});
          }
        } else {
          CommonResponseModel? checkEmailResponse = await authManager.checkEmail(email: _emailController.text.trim());
          if(checkEmailResponse?.status == "success"){
            ApplicationGlobal.firstName = _firstNameController.text.trim();
            ApplicationGlobal.lastName = _lastNameController.text.trim();
            ApplicationGlobal.email = _emailController.text.trim();
            if(!widget.isSocialSignUp) {
              ApplicationGlobal.phone = number;
            }
            ApplicationGlobal.referralCode = _referralController.text.trim();
            ApplicationGlobal.newsSubscription = news;
            CommonResponseModel? otpResponse = await authManager.sendOtp(number: number);
            if(otpResponse?.status == "success"){
              AppUtils.showToast("OTP sent successfully!", color: Colors.green);
              Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationView(number: number),));
            } else {
              AppUtils.showMessage(context: context, title: "OTP Error!", message: otpResponse?.message??"Failed to send OTP. Please try again", onOk: (){});
            }
          } else {
            AppUtils.showMessage(context: context, title: "Email already exists!", message: checkEmailResponse?.message??"Email already exists in database.", onOk: (){});
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void updatePhoneNumber() {
    AppUtils.showCustomDialog(
      context: context,
      dialogBox: PhoneNumberVerificationPopup(
        onNext: (number) async {
          setState(() {
            isLoading = true;
          });
          CommonResponseModel? otpResponse = await authManager.sendOtp(number: number);
          setState(() {
            isLoading = false;
          });
          if(otpResponse?.status == "success"){
            AppUtils.showToast("OTP sent successfully!", color: Colors.green);
            Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationView(number: number, isSocialSignUp: true,),));
          } else {
            AppUtils.showMessage(context: context, title: "OTP Error!", message: otpResponse?.message??"Failed to send OTP. Please try again", onOk: (){
              updatePhoneNumber();
            });
          }
        },
        onSkip: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBarView(),));
        },
      ),
    );
  }
}

extension on String {
  bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}