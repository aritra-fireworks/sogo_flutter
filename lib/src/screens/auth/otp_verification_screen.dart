import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/screens/auth/complete_your_profile.dart';
import 'package:sogo_flutter/src/screens/auth/migration/migration_confirmation_view.dart';
import 'package:sogo_flutter/src/screens/auth/set_password.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';


class OTPVerificationView extends StatefulWidget {
  final PhoneNumber number;
  final bool isMigration;
  final bool isSocialSignUp;
  const OTPVerificationView({Key? key, required this.number, this.isMigration = false, this.isSocialSignUp = false}) : super(key: key);

  @override
  _OTPVerificationViewState createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends State<OTPVerificationView> {

  bool canResend = false;
  int otpCount = 1;
  bool isLoading = false;
  late StopWatchTimer stopWatchTimer;

  String? otp;

  @override
  void initState() {
    super.initState();
    stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(30), // millisecond => seconds.
      onChange: (value) {
        if(value == 0){
          if(mounted){
            setState(()=>canResend = true);
          }else{
            canResend = true;
          }
        }
      },
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      stopWatchTimer.onExecute.add(StopWatchExecute.start);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: LoadingIndicator(
        indicatorType: Indicator.ballScale,
        colors: [AppColors.primaryRed, AppColors.secondaryRed],
      ),
      inAsyncCall: isLoading,
      child: KeyboardDismissWrapper(
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
                title: Text("Phone Verification", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
              ),
              body: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                ),
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("We have sent an OTP to your mobile phone ${widget.number.phoneNumber} for verification.", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamBook", height: 1.4, color: AppColors.lightBlack),),
                      const SizedBox(height: 30,),
                      inputPinFields(),
                      const SizedBox(height: 30,),
                      StreamBuilder<int>(
                        stream: stopWatchTimer.rawTime,
                        initialData: 0,
                        builder: (context, snap) {
                          final value = snap.data;
                          final displayTime = StopWatchTimer.getDisplayTime(value??0, hours: false, milliSecond: false, minute: false);
                          return RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(text: "Didn’t get your OTP? Request a new OTP in $displayTime seconds or ", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBook"), recognizer: TapGestureRecognizer()..onTap = () async {
                                  if(canResend){
                                    setState(() {
                                      isLoading = true;
                                    });
                                    CommonResponseModel? otpResponse = await authManager.sendOtp(number: widget.number);
                                    if(otpResponse?.status == "success"){
                                      AppUtils.showToast("OTP re-sent successfully!", color: Colors.green);
                                    } else {
                                      AppUtils.showToast(otpResponse?.message??"Failed to send OTP. Please try again");
                                    }
                                    setState(() {
                                      isLoading = false;
                                      canResend = false;
                                    });
                                    stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                                    stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                    AppUtils.showToast("OTP resend successfully!", color: Colors.green);
                                  }
                                }),
                                TextSpan(text: "update your phone number.", style: const TextStyle(color: Color(0xFF004EFF), fontSize: 16, fontFamily: "Regular"), recognizer: TapGestureRecognizer()..onTap = () => Navigator.pop(context)),
                              ],
                              style: const TextStyle(height: 1.4),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30,),
                      Text("Tip: If you have a spam blocking app, make sure to turn it off. It may be preventing us from sending you your OTP.", style: TextStyle(color: AppColors.lightBlack, fontSize: 11.sp, fontFamily: "GothamBook"),),
                      const Spacer(),
                      SizedBox(
                        height: 50,
                        child: SizedBox.expand(
                          child: RoundButton(
                            borderRadius: 9,
                            onPressed: otp != null && otp!.isNotEmpty && otp!.length == 4 ? () async {
                              setState(() {
                                isLoading = true;
                              });
                              CommonResponseModel? verifyOtpResponse = await authManager.verifyOtp(number: widget.number, otp: otp!);
                              setState(() {
                                isLoading = false;
                              });
                              if(verifyOtpResponse?.status == "success") {
                                if(widget.isMigration){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MigrationConfirmationView(),));
                                } else if(widget.isSocialSignUp){
                                  Map params = {
                                    "custid": ApplicationGlobal.profile?.custid ?? "",
                                    "mercid": "44",
                                    "phone": widget.number.phoneNumber?.replaceAll(widget.number.dialCode ?? "+", ""),
                                    "phone_country": widget.number.dialCode?.replaceAll("+", ""),
                                    "date": SecretCode.getDate(),
                                    "vc": SecretCode.getVCKey(),
                                    "os": DeviceInfo.deviceOS,
                                    "sectoken": ApplicationGlobal.bearerToken,
                                    "phonename": DeviceInfo.deviceMake,
                                    "phonetype": "Phone",
                                    "lang": "en",
                                    "deviceid": DeviceInfo.deviceUid,
                                    "devicetype": DeviceInfo.deviceType,
                                    "appversion": DeviceInfo.deviceVersion,
                                    "deviceflavour": DeviceInfo.deviceVersion,
                                  };
                                  setState(() {
                                    isLoading = true;
                                  });
                                  CommonResponseModel? updateResponse = await profileManager.updateProfile(params);
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if(updateResponse?.status == "success") {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteYourProfileScreen(context: context),));
                                  } else {
                                    AppUtils.showMessage(context: context, title: "Error!", message: updateResponse?.message??"Failed to update details.");
                                  }
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SetPasswordScreen(),));
                                }

                                AppUtils.showToast(verifyOtpResponse?.message??"OTP verified successfully!", color: Colors.green);
                              } else {
                                AppUtils.showMessage(context: context, title: "OTP Invalid!", message: verifyOtpResponse?.message??"OTP was not verified. Try again.", onOk: (){});
                              }
                            } : null,
                            child: const Text("Next", style: TextStyle(fontSize: 16, fontFamily: "Regular"),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputPinFields(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80.w),
      child: PinCodeTextField(
        appContext: context,
        pastedTextStyle: TextStyle(
          color: Colors.green.shade600,
          fontWeight: FontWeight.bold,
        ),
        textStyle: TextStyle(fontFamily: "GothamBold", color: AppColors.lightBlack, height: 1.3, fontSize: 15.sp),
        length: 4,
        obscureText: false,
        animationType: AnimationType.fade,
        validator: (v) {
          if (v != null && v.length < 3) {
            return null;
          } else {
            return null;
          }
        },
        pinTheme: PinTheme(
          borderWidth: 3,
          activeColor: Colors.grey,
          inactiveFillColor: Colors.transparent,
          selectedFillColor: Colors.transparent,
          inactiveColor: Colors.grey,
          selectedColor: Colors.grey,
          shape: PinCodeFieldShape.underline,
          // borderRadius: BorderRadius.circular(12),
          // fieldHeight: 50,
          fieldWidth: 30.w,
          activeFillColor: Colors.transparent,
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        // boxShadows: const [BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 0)],
        keyboardType: TextInputType.number,

        onCompleted: (v) {
          debugPrint("Completed");
          otp = v;
          setState(() {});
        },
        // onTap: () {
        //   print("Pressed");
        // },
        onChanged: (value) {
          debugPrint(value);
          otp = value;
          setState(() {});
        },
        beforeTextPaste: (text) {
          debugPrint("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          if(text != null) {
            otp = text;
            setState(() {});
          }
          return true;
        },
      ),
    );
  }
}
