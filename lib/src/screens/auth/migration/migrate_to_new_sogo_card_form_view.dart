import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/auth/migration_data_model.dart';
import 'package:sogo_flutter/src/screens/auth/migration/create_account_migrated_user.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/phone_text_field.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';


class MigrateToNewSogoCardView extends StatefulWidget {
  const MigrateToNewSogoCardView({Key? key}) : super(key: key);

  @override
  State<MigrateToNewSogoCardView> createState() => _MigrateToNewSogoCardViewState();
}

class _MigrateToNewSogoCardViewState extends State<MigrateToNewSogoCardView> {

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _nricController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _cardNumberFocus = FocusNode();
  final FocusNode _nricFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  IdType selectedType = authManager.idList.first;
  PhoneNumber number = PhoneNumber(isoCode: 'MY');

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

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
                    title: Text("Moving To New Sogo Card", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                        child: eventsListBody(context)),
                  )),
            ],
          )),
    );
  }

  Widget eventsListBody(BuildContext context) {

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
            Text("Please key in the number of your current Sogo Card.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
            SizedBox(height: 10.h,),
            TitledTextField(
              controller: _cardNumberController,
              focusNode: _cardNumberFocus,
              title: "Member Card Number",
              hintText: "Enter Member Card Number",
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 30.h,),
            Text("Please key in either NIRC or Phone Number associated with the current Sogo Card", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
            SizedBox(height: 15.h,),
            nricDropdown(),
            SizedBox(height: 40.h,),
            Align(alignment: Alignment.center, child: Text("Or", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamBold", fontSize: 15.sp, color: AppColors.lightBlack),)),
            SizedBox(height: 20.h,),
            PhoneTextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              title: "Phone Number",
              hintText: "Enter Phone Number",
              isMandatory: false,
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

            const SizedBox(height: 30,),
            RoundButton(
              onPressed: () async {
                bool validId = false;
                switch(selectedType.id){
                  case 0: {
                    validId = _nricController.text.trim().isValidPassport();
                    break;
                  }
                  case 1: {
                    validId = validateNric(_nricController.text.trim());
                    debugPrint(validId.toString());
                    break;
                  }
                  case 2: {
                    validId = validateID(_nricController.text.trim());
                    break;
                  }
                  default: {
                    validId = false;
                    break;
                  }
                }
                if(_cardNumberController.text.trim().isEmpty) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Enter SOGO card number", onOk: (){
                    _cardNumberFocus.requestFocus();
                  });
                } else if(_nricController.text.trim().isEmpty && _phoneController.text.trim().isEmpty){
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid ID or phone number", onOk: (){
                    _nricFocus.requestFocus();
                  });
                } else if(!validId){
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid ID", onOk: (){
                    _nricFocus.requestFocus();
                  });
                } else if(_nricController.text.trim().isEmpty && (_phoneController.text.trim().isEmpty || _phoneController.text.trim().length < 8 || int.tryParse(_phoneController.text.trim()) is! int)){
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid phone number", onOk: (){
                    _phoneFocus.requestFocus();
                  });
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  Map params = {};
                  if(_nricController.text.trim().isNotEmpty){
                    params = {
                      "member_card_no": _cardNumberController.text.trim(),
                      "id_type": selectedType.id.toString(),
                      "nric": _nricController.text.trim(),
                    };
                  } else if(_phoneController.text.trim().isNotEmpty){
                    params = {
                      "member_card_no": _cardNumberController.text.trim(),
                      "id_type": selectedType.id.toString(),
                      "phone_country": number.dialCode?.replaceAll("+", ""),
                      "phone": number.phoneNumber?.replaceAll(number.dialCode ?? "+", "")
                    };
                  }
                  MigrationDataModel? response = await authManager.getMigratedUserData(params: params);
                  setState(() {
                    isLoading = false;
                  });
                  if(response?.status == "success"){
                    ApplicationGlobal.memberCardNo = _cardNumberController.text.trim();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateAccountMigratedUserView(),));
                  } else {
                    AppUtils.showMessage(context: context, title: "Error!", message: response?.message ?? "Failed to find user data. Try again");
                  }
                }

              },
              borderRadius: 9,
              child: const Text("Proceed", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
            ),
            SizedBox(height: 30.h,),
          ],
        ),
      ),
    );
  }

  Widget nricDropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<IdType>(
          value: selectedType,
          icon: const SizedBox(),
          elevation: 16,
          style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),
          underline: const SizedBox(),
          onChanged: (IdType? newValue) {
            setState(() {
              selectedType = newValue!;
            });
          },
          isDense: true,
          alignment: Alignment.centerLeft,
          borderRadius: BorderRadius.circular(9),
          items: authManager.idList
              .map<DropdownMenuItem<IdType>>((IdType value) {
            return DropdownMenuItem<IdType>(
              value: value,
              child: Text(value.type, style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
            );
          }).toList(),
          selectedItemBuilder: (context) {
            return authManager.idList.map((e) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(e.type, style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
                Icon(Icons.arrow_drop_down, color: AppColors.lightBlack.withOpacity(0.6), size: 28.sp,)
              ],
            )).toList();
          },
        ),
        SizedBox(height: 5.sp,),
        SizedBox(
          height: 40,
          child: TextField(
            controller: _nricController,
            focusNode: _nricFocus,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.none,
            style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamRegular"),
            decoration: InputDecoration(
              suffixIconColor: const Color(0xFFD1D1D1),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
              errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp)),
              isDense: true,
              hintText: "Enter your id",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp, fontFamily: "GothamRegular"),
            ),
          ),
        )
      ],
    );
  }
}

extension on String {
  bool isValidPassport() => RegExp(r"^[a-zA-Z0-9]{2}[0-9]{5,}").hasMatch(this);
}

bool validateNric(String nric) {
  if(nric.length == 12){
    String nricNumber = nric.replaceAll("-", "");
    debugPrint("NRIC number: $nricNumber");
    int month = int.tryParse(nricNumber.substring(2, 4)) != null ? int.parse(nricNumber.substring(2, 4)) : 0;
    debugPrint("Month: $month");
    if(month >= 1 && month <= 12){
      int day = int.tryParse(nricNumber.substring(4, 6)) != null ? int.parse(nricNumber.substring(4, 6)) : 0;
      debugPrint("Day: $day");
      if(day >= 1 && day <= 31) {
        String location = nricNumber.substring(6, 8);
        debugPrint("Location: $location");
        if(!(["00","17","18","19","20","69","70","73","80","81","94","95","96"].contains(location))){
          return true;
        }
      }
    }
  }
  return false;
}

bool validateID(String id) {
  if(id.length >= 5){
    return true;
  }
  return false;
}