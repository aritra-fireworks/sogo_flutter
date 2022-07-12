import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/models/profile/user_profile_model.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/screens/onboarding/onboarding_views.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/phone_text_field.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';


enum VerificationType{
  phone,
  email,
  iAgree
}

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({Key? key}) : super(key: key);

  @override
  _DeleteAccountViewState createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {

  late TextEditingController _mobileController;
  late TextEditingController _emailController;
  late TextEditingController _agreeController;
  
  late FocusNode _mobileFocus;
  late FocusNode _emailFocus;
  late FocusNode _agreeFocus;

  bool isLoading = false;
  PhoneNumber number = PhoneNumber(isoCode: 'MY');
  late VerificationType _verificationType;


  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _emailController = TextEditingController();
    _agreeController = TextEditingController();
    _mobileFocus = FocusNode();
    _emailFocus = FocusNode();
    _agreeFocus = FocusNode();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    _agreeController.dispose();
    _mobileFocus.dispose();
    _emailFocus.dispose();
    _agreeFocus.dispose();
    super.dispose();
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
          child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
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
                    child: StreamBuilder<ApiResponse<UserProfileModel>?>(
                        stream: profileManager.profile,
                        builder: (BuildContext context, AsyncSnapshot<ApiResponse<UserProfileModel>?> profileSnapshot) {
                          if (profileSnapshot.hasData) {
                            switch (profileSnapshot.data!.status) {
                              case Status.LOADING:
                                debugPrint('Loading');
                                return Center(child: CircularProgressIndicator(color: AppColors.primaryRed,));
                              case Status.COMPLETED:
                                debugPrint('Profile Loaded');
                                UserProfileModel? userData = profileSnapshot.data?.data;
                                return deleteAccountBody(buildContext, userData);
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
              ))),
    );
  }

  Widget deleteAccountBody(BuildContext context, UserProfileModel? data,){
    Widget verificationInputWidget = verifyIAgree();
    _verificationType = VerificationType.iAgree;
    if(data?.profile?.phone != null && data!.profile!.phone!.isNotEmpty){
      verificationInputWidget = verifyPhone();
      _verificationType = VerificationType.phone;
    } else if(data?.profile?.email != null && data!.profile!.email!.isNotEmpty) {
      verificationInputWidget = verifyEmail();
      _verificationType = VerificationType.email;
    }
    return Stack(
      children: [
        Container(
          height: 200.h,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text("Delete My Account", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: "GothamBold"),),
          ),
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25.h,),
                  Text("Deleting your account will:", style: TextStyle(color: AppColors.lightBlack, fontSize: 16.sp, fontFamily: "GothamMedium"),),
                  SizedBox(height: 20.h,),
                  Text("Delete your account info and profile picture.", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
                  SizedBox(height: 5.h,),
                  Text("Delete your associated transaction records.", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular")),
                  SizedBox(height: 5.h,),
                  Text("Deletion of account is immediate and permanent.", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular")),
                  SizedBox(height: 25.h,),
                  verificationInputWidget,
                  SizedBox(height: 25.h,),
                  RoundButton(onPressed: () async {
                    switch(_verificationType){
                      case VerificationType.iAgree: {
                        if(_agreeController.text.trim() == "I AGREE"){
                          AppUtils.showCustomDialog(context: context, dialogBox: confirmDialog(context));
                        } else {
                          AppUtils.showMessage(context: context, title: "Error!", message: "Please enter \"AGREE\"",);
                        }
                        break;
                      }
                      case VerificationType.email: {
                        if(_emailController.text.trim() == data?.profile?.email){
                          AppUtils.showCustomDialog(context: context, dialogBox: confirmDialog(context));
                        } else {
                          AppUtils.showMessage(context: context, title: "Error!", message: "Please enter your email address",);
                        }
                        break;
                      }
                      case VerificationType.phone: {
                        if(number.phoneNumber == "+${data?.profile?.phoneCountry}${data?.profile?.phone}"){
                          AppUtils.showCustomDialog(context: context, dialogBox: confirmDialog(context));
                        } else if(_mobileController.text.trim().isEmpty){
                          AppUtils.showMessage(context: context, title: "Error!", message: "Please enter your phone number",);
                        } else {
                          AppUtils.showMessage(context: context, title: "Error!", message: "Please enter your correct phone number associated with the current account",);
                        }
                        break;
                      }
                    }
                  }, color: AppColors.primaryRed, borderRadius: 9, child: Text("Delete My Account", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget verifyPhone() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Enter your phone number to continue", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontFamily: "GothamMedium"),),
        SizedBox(height: 15.h,),
        PhoneTextField(
          controller: _mobileController,
          focusNode: _mobileFocus,
          title: "Phone",
          hintText: "Enter your phone number",
          number: number,
          onInputChanged: (PhoneNumber phone){
            if(number != phone){
              number = phone;
            }
          },
        ),
      ],
    );
  }

  Widget verifyEmail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Enter your email address to continue", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontFamily: "GothamMedium"),),
        SizedBox(height: 15.h,),
        TitledTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          title: "Email",
          hintText: "Enter your email address",
          isMandatory: false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
        )
      ],
    );
  }

  Widget verifyIAgree() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Enter \"AGREE\" to continue", style: TextStyle(color: Colors.black, fontSize: 16.sp, fontFamily: "GothamMedium"),),
        SizedBox(height: 15.h,),
        TitledTextField(
          controller: _agreeController,
          focusNode: _agreeFocus,
          title: "Enter Agree",
          hintText: 'Enter "AGREE"',
          isMandatory: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
        )
      ],
    );
  }

  Widget confirmDialog(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Delete My Account", style: TextStyle(color: AppColors.lightBlack, fontSize: 18.sp, fontFamily: "GothamMedium"),),
              SizedBox(height: 15.h,),
              Text("Are you sure you want to delete your account?", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Expanded(
                    child: RoundButton(
                      onPressed: (){
                        Navigator.pop(context);
                        deleteAccount(context);
                      }, borderRadius: 9, child: Text("Confirm", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 15.w,),
                  Expanded(
                    child: RoundOutlineButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, borderRadius: 9, child: Text("Cancel", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteAccount(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    CommonResponseModel? response = await profileManager.deleteProfile();
    setState(() {
      isLoading = false;
    });
    if(response?.status == "success") {
      AppUtils.showCustomDialog(context: context, dialogBox: deleteSuccess(context));
    } else {
      AppUtils.showMessage(context: context, title: "Error!", message: "Failed to delete your account(${response?.message}). Please try again.");
    }
  }

  Widget deleteSuccess(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Account Deleted", style: TextStyle(color: AppColors.lightBlack, fontSize: 18.sp, fontFamily: "GothamMedium"),),
              SizedBox(height: 15.h,),
              Text("Your account has been successfully deleted.", style: TextStyle(color: AppColors.lightBlack, fontSize: 14.sp, fontFamily: "GothamRegular"),),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Expanded(
                    child: RoundButton(
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const OnboardingViews(),), (route) => false);
                      }, borderRadius: 9, child: Text("OK", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
