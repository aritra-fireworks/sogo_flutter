import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/screens/auth/complete_profile_popup.dart';
import 'package:sogo_flutter/src/screens/auth/complete_your_profile_second_part.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/nav_bar_view.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:sogo_flutter/src/widgets/custom_date_picker.dart';
import 'package:sogo_flutter/src/widgets/custom_radio_list_tile.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';

class CompleteYourProfileScreen extends StatefulWidget {
  final BuildContext context;
  const CompleteYourProfileScreen({Key? key, required this.context}) : super(key: key);

  @override
  State<CompleteYourProfileScreen> createState() => _CompleteYourProfileScreenState();
}

class _CompleteYourProfileScreenState extends State<CompleteYourProfileScreen> {

  final TextEditingController _nricController = TextEditingController();

  final FocusNode _nricFocus = FocusNode();

  bool isLoading = false;
  IdType selectedType = authManager.idList.first;
  DateTime? dob;
  String? dateOfBirth;
  GenderType? selectedGender;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      AppUtils.showCustomDialog(context: widget.context, dialogBox: CompleteProfilePopup(onCompleteNow: (){}, onLater: (){
        Navigator.pushReplacement(widget.context, MaterialPageRoute(builder: (context) => const NavBarView(),));
      },));
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
        child: Stack(
          children: [
            Container(
              height: 200.h,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
            ),
            Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  // leading: IconButton(
                  //   icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
                  //   onPressed: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  centerTitle: true,
                  title: Text("Complete Your Profile", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                      child: completeProfileBody(context)),
                )),
          ],
        ));
  }

  Widget completeProfileBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: SizedBox(
            height: size.height - 65 - 60.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text("Welcome ${ApplicationGlobal.profile?.fname},", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBold"),),
                ),
                SizedBox(height: 30.h,),
                nricDropdown(),
                SizedBox(height: 20.h,),
                dobSelect(),
                SizedBox(height: 25.h,),
                genderSelect(),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: RoundButton(
                    child: const Text("Next", style: TextStyle(fontSize: 16, fontFamily: "GothamMedium"),),
                    borderRadius: 9,
                    onPressed: () async {
                      bool validId = false;
                      switch(selectedType.id){
                        case 0: {
                          validId = _nricController.text.trim().isValidPassport();
                          break;
                        }
                        case 1: {
                          validId = validateNric(_nricController.text.trim());
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
                      if(_nricController.text.trim().isEmpty){
                        AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid ID", onOk: (){
                          _nricFocus.requestFocus();
                        });
                      } else if(!validId){
                        AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter a valid ID", onOk: (){
                          _nricFocus.requestFocus();
                        });
                      } else if(dateOfBirth == null) {
                        AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please select your date of birth", onOk: (){});
                      } else if(selectedGender == null) {
                        AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please select your gender", onOk: (){});
                      } else {
                        ApplicationGlobal.nric = _nricController.text.trim();
                        ApplicationGlobal.dob = dateOfBirth;
                        ApplicationGlobal.gender = selectedGender!.id;
                        Map params = {
                          "custid": ApplicationGlobal.custId,
                          "mercid": "44",
                          // "title": "",
                          // "fname": "",
                          // "lname": "",
                          // "email": "",
                          // "phone": "",
                          // "phone_country": "",
                          "dob": dateOfBirth,
                          "nric": _nricController.text.trim(),
                          "id_type": selectedType.id.toString(),
                          // "display_name": "",
                          "gender": selectedGender?.id.toString(),
                          // "love_anniversary": "",
                          // "nationality": "",
                          // "country": "",
                          // "race": "",
                          // "householdincome": 0,
                          // "selectedinterests": "",
                          // "address1": "",
                          // "address2": "",
                          // "state": "",
                          // "city": "",
                          // "postcode": "",
                          // "mall": 0,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CompleteYourProfileSecondPartScreen(),));
                        } else {
                          AppUtils.showMessage(context: context, title: "Error!", message: updateResponse?.message??"Failed to update details.");
                        }
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: RoundOutlineButton(
                    child: const Text("Skip for Now", style: TextStyle(fontSize: 16, fontFamily: "GothamBold", color: AppColors.lightBlack),),
                    borderRadius: 9,
                    onPressed: () async {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBarView(),));
                    },
                  ),
                ),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nricDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
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
      ),
    );
  }

  Widget dobSelect() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "Date of Birth", style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamMedium")),
                TextSpan(text: "*", style: TextStyle(color: AppColors.primaryRed, fontSize: 16.sp, fontFamily: "Medium")),
              ],
            ),
          ),
          CustomDatePickerField(
            selectedDate: dob,
            label: "Select date of birth",
            onPicked: (value, valueText) {
              setState(() {
                dob = value;
                dateOfBirth = valueText;
              });
            },
          )
        ],
      ),
    );
  }

  Widget genderSelect() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text("What’s Your Gender?", style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
        ),
        SizedBox(height: 10.sp,),
        ...authManager.genderList.map((e) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomRadioListTile<GenderType>(
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primaryRed,
            selectedTileColor: AppColors.lightBlack,
            tileColor: AppColors.grey,
            title: Text(e.name, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: selectedGender == e ? AppColors.lightBlack : AppColors.grey),),
            value: e,
            groupValue: selectedGender,
            onChanged: (GenderType? value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
        ),).toList()
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
    int month = int.tryParse(nricNumber.substring(2, 4)) != null ? int.parse(nricNumber.substring(2, 4)) : 0;
    if(month >= 1 && month <= 12){
      int day = int.tryParse(nricNumber.substring(4, 6)) != null ? int.parse(nricNumber.substring(4, 6)) : 0;
      if(day >= 1 && day <= 31) {
        String location = nricNumber.substring(6, 8);
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