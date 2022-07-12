import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/managers/support_manager/support_manager.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/support_model.dart';
import 'package:sogo_flutter/src/models/profile/user_profile_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:sogo_flutter/src/widgets/image_capture.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';

class FeedbackFormView extends StatefulWidget {
  final IssueType type;
  const FeedbackFormView({Key? key, required this.type}) : super(key: key);

  @override
  State<FeedbackFormView> createState() => _FeedbackFormViewState();
}

class _FeedbackFormViewState extends State<FeedbackFormView> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cardNoController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _cardNoFocus = FocusNode();
  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _messageFocus = FocusNode();

  List<IssueType> idList = [
    const IssueType(0, "App Crash"),
    const IssueType(1, "Membership"),
    const IssueType(2, "Others"),
  ];

  late IssueType selectedType = widget.type;
  File? _image;

  bool textFieldSet = false;
  bool isLoading = false;

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
                title: Text("Customer Support", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
              ),
              body: StreamBuilder<ApiResponse<UserProfileModel>?>(
                  stream: profileManager.profile,
                  builder: (BuildContext streamContext, AsyncSnapshot<ApiResponse<UserProfileModel>?> profileSnapshot) {
                    if (profileSnapshot.hasData) {
                      switch (profileSnapshot.data!.status) {
                        case Status.LOADING:
                          debugPrint('Loading');
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                            ),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(color: AppColors.primaryRed,),
                          );
                        case Status.COMPLETED:
                          debugPrint('Profile Loaded');
                          UserProfileModel? userData = profileSnapshot.data?.data;
                          return helpCenterBody(context, userData);
                        case Status.NODATAFOUND:
                          debugPrint('Not found');
                          return helpCenterBody(context, null);
                        case Status.ERROR:
                          debugPrint('Error');
                          return helpCenterBody(context, null);
                      }
                    }
                    return const SizedBox();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget helpCenterBody(BuildContext context, UserProfileModel? userData) {
    Size size = MediaQuery.of(context).size;
    if(!textFieldSet){
      _nameController.text = userData?.profile?.name ?? "";
      _emailController.text = userData?.profile?.email ?? "";
      _phoneController.text = userData?.profile?.phone ?? "";
      _cardNoController.text = userData?.profile?.cardno ?? "";
      textFieldSet = true;
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            issueDropdown(),
            SizedBox(height: 10.h,),
            TitledTextField(
              controller: _nameController,
              focusNode: _nameFocus,
              title: "Name",
              hintText: "Enter your name",
              isMandatory: false,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            TitledTextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              title: "Phone Number",
              hintText: "Enter your phone",
              isMandatory: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            TitledTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              title: "Email Address",
              hintText: "Enter your email",
              isMandatory: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            TitledTextField(
              controller: _cardNoController,
              focusNode: _cardNoFocus,
              title: "SOGO Card Number",
              hintText: "Enter your SOGO Card Number",
              isMandatory: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            TitledTextField(
              controller: _subjectController,
              focusNode: _subjectFocus,
              title: "Subject",
              hintText: "Enter subject",
              isMandatory: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 10.h,),
            Text("Message", style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamMedium"),),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: SizedBox(
                height: size.height * 0.25,
                child: TextField(
                  controller: _messageController,
                  focusNode: _messageFocus,
                  maxLines: 100,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp),
                      borderRadius: BorderRadius.zero,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 11.w),
                    hintText: "Enter your message",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp, fontFamily: "GothamRegular"),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            pickImage(size),
            SizedBox(height: 30.h,),
            RoundButton(
              onPressed: () => submitFeedback(context),
              borderRadius: 9,
              child: const Text("Submit", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  Widget issueDropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<IssueType>(
          value: selectedType,
          icon: const SizedBox(),
          elevation: 16,
          style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 16.sp),
          underline: const SizedBox(),
          onChanged: (IssueType? newValue) {
            setState(() {
              selectedType = newValue!;
            });
          },
          isDense: true,
          alignment: Alignment.centerLeft,
          borderRadius: BorderRadius.circular(9),
          items: idList
              .map<DropdownMenuItem<IssueType>>((IssueType value) {
            return DropdownMenuItem<IssueType>(
              value: value,
              child: Text(value.type, style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
            );
          }).toList(),
          selectedItemBuilder: (context) {
            return idList.map((e) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Issue", style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 16.sp),),
                Icon(Icons.arrow_drop_down, color: AppColors.lightBlack, size: 28.sp,),
                SizedBox(width: 40.w,),
              ],
            )).toList();
          },
        ),
        SizedBox(height: 5.h,),
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text(selectedType.type, style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: const Color(0xFF919191)),),
        ),
      ],
    );
  }

  Widget pickImage(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _image == null
            ? InkWell(
          onTap: (){
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.push(context, MaterialPageRoute(builder: (context) => ImageCapture(imageCallback: (file) {_image = file; setState(() {});},),));
          },
          child: Align(
          alignment: Alignment.centerRight,
          child: Text("+ Upload Attachment", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
        ),
        )
            : Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 10),
                child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      height: 100,
                      width: size.width,
                    )),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: (){
                  setState(() {
                    _image = null;
                  });
                },
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryRed,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> submitFeedback(BuildContext context) async {
    if(_nameController.text.trim().isEmpty) {
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Enter your name", onOk: (){
        _nameFocus.requestFocus();
      });
    } else if(_phoneController.text.trim().isEmpty){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Enter your phone number", onOk: (){
        _phoneFocus.requestFocus();
      });
    } else if(_phoneController.text.trim().isEmpty || _phoneController.text.trim().length < 8 || int.tryParse(_phoneController.text.trim()) is! int){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid phone number", onOk: (){
        _phoneFocus.requestFocus();
      });
    } else if(_emailController.text.trim().isEmpty){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Enter your email address", onOk: (){
        _emailFocus.requestFocus();
      });
    } else if(!_emailController.text.trim().isEmail()){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid email", onOk: (){
        _emailFocus.requestFocus();
      });
    } else if(_cardNoController.text.trim().isEmpty){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid SOGO card number.", onOk: (){
        _cardNoFocus.requestFocus();
      });
    } else if(_subjectController.text.trim().isEmpty){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a subject.", onOk: (){
        _subjectFocus.requestFocus();
      });
    } else if(_messageController.text.trim().isEmpty){
      AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a subject.", onOk: (){
        _messageFocus.requestFocus();
      });
    } else {
      setState(() {
        isLoading = true;
      });
      Map params = {
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "email": _emailController.text.trim(),
        "subject": _subjectController.text.trim(),
        "IssueType": selectedType.type,
        "description": _messageController.text.trim(),
        "image": _image != null ? base64Encode(_image!.readAsBytesSync()) : "",
        "mall": ApplicationGlobal.selectedMall?.id,
        "custid": ApplicationGlobal.profile?.custid??"",
        "mercid": "44",
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
      SupportResponseModel? response = await supportManager.createTicket(params: params);
      if(response?.isSent ?? false){
        AppUtils.showMessage(context: context, title: "Thank You!", message: "Your support request has been submitted", onOk: (){
          Navigator.pop(context);
        });
      } else {
        AppUtils.showMessage(context: context, title: "OTP Error!", message: "Failed to send feedback. Please try again", onOk: (){});
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}

class IssueType extends Equatable {
  final int id;
  final String type;

  const IssueType(this.id, this.type);

  @override
  List<dynamic> get props => [id, type];
}

extension on String {
  bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
}