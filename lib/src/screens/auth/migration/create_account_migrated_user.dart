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
import 'package:sogo_flutter/src/models/auth/migration_data_model.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/screens/auth/migration/existing_sogo_card_member_view.dart';
import 'package:sogo_flutter/src/screens/auth/migration/migration_options_screen.dart';
import 'package:sogo_flutter/src/screens/auth/otp_verification_screen.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/checkbox.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/phone_text_field.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';

class CreateAccountMigratedUserView extends StatefulWidget {
  const CreateAccountMigratedUserView({Key? key}) : super(key: key);

  @override
  State<CreateAccountMigratedUserView> createState() => _CreateAccountMigratedUserViewState();
}

class _CreateAccountMigratedUserViewState extends State<CreateAccountMigratedUserView> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  PhoneNumber number = PhoneNumber(isoCode: 'MY');
  bool pdpa = false;
  bool news = false;

  bool fieldsSet = false;

  bool isLoading = false;


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
                        child: StreamBuilder<ApiResponse<MigrationDataModel>?>(
                            stream: authManager.migratedUserData,
                            builder: (BuildContext context, AsyncSnapshot<ApiResponse<MigrationDataModel>?> migratedUserDataSnapshot) {
                              if (migratedUserDataSnapshot.hasData) {
                                switch (migratedUserDataSnapshot.data!.status) {
                                  case Status.LOADING:
                                    debugPrint('Loading');
                                    return Center(child: CircularProgressIndicator(color: AppColors.primaryRed,));
                                  case Status.COMPLETED:
                                    debugPrint('Profile Loaded');
                                    MigrationDataModel? userData = migratedUserDataSnapshot.data?.data;
                                    if(!fieldsSet){
                                      _firstNameController.text = userData?.migratedData?.fname??"";
                                      _lastNameController.text = userData?.migratedData?.lname??"";
                                      _phoneController.text = userData?.migratedData?.phone??"";
                                      number = PhoneNumber(isoCode: "MY", dialCode: "+60", phoneNumber: '+${userData?.migratedData?.phone??""}');
                                      _emailController.text = userData?.migratedData?.email??"";
                                      fieldsSet = true;
                                    }
                                    return createAccountMigrateUserBody(buildContext, userData);
                                  case Status.NODATAFOUND:
                                    debugPrint('Not found');
                                    return const SizedBox();
                                  case Status.ERROR:
                                    debugPrint('Error');
                                    return const SizedBox();
                                }
                              }
                              return Container();
                            })),
                  )),
            ],
          )),
    );
  }

  Widget createAccountMigrateUserBody(BuildContext context, MigrationDataModel? userData) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ensure your details are accurate and most recent. We will use these for your New Sogo Card Account.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
            SizedBox(height: 10.h,),
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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
            ),
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
            SizedBox(height: 30.h,),
            RoundButton(
              onPressed: () => verifyOtp(context, userData),
              borderRadius: 9,
              child: const Text("Next", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  verifyOtp(BuildContext context, MigrationDataModel? userData) async {
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
    } else if(_phoneController.text.trim().isEmpty || _phoneController.text.trim().length < 8 || int.tryParse(_phoneController.text.trim()) is! int){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid phone number", onOk: (){
        _phoneFocus.requestFocus();
      });
    } else if(!pdpa){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please agree to the terms & conditions to proceed.", onOk: (){});
    } else {
      setState(() {
        isLoading = true;
      });
      CommonResponseModel? checkEmailResponse = await authManager.checkEmail(email: _emailController.text.trim());
      // if(checkEmailResponse?.status == "success"){
      //
      // } else {
      //   AppUtils.showMessage(context: context, title: "Email already exists!", message: checkEmailResponse?.message??"Email already exists in database.", onOk: (){});
      // }
      CommonResponseModel? otpResponse = await authManager.sendOtp(number: number);
      if(otpResponse?.status == "success"){
        ApplicationGlobal.firstName = _firstNameController.text.trim();
        ApplicationGlobal.lastName = _lastNameController.text.trim();
        ApplicationGlobal.email = _emailController.text.trim();
        ApplicationGlobal.nric = userData?.migratedData?.nric;
        ApplicationGlobal.phone = number;
        ApplicationGlobal.pointsBalance = userData?.migratedData?.points;
        ApplicationGlobal.migrate = 1;
        ApplicationGlobal.newsSubscription = news;
        AppUtils.showToast("OTP sent successfully!", color: Colors.green);
        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerificationView(number: number, isMigration: true),));
      } else {
        AppUtils.showMessage(context: context, title: "OTP Error!", message: otpResponse?.message??"Failed to send OTP. Please try again", onOk: (){});
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}

extension on String {
  bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}