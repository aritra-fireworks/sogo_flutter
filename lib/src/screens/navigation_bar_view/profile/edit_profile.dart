import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/managers/dashboard_manager/dashboard_manager.dart';
import 'package:sogo_flutter/src/managers/get_code.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/models/common_response_model.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/models/auth/states_model.dart';
import 'package:sogo_flutter/src/models/profile/user_profile_model.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:sogo_flutter/src/widgets/custom_date_picker.dart';
import 'package:sogo_flutter/src/widgets/custom_expansion_tile.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/phone_text_field.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';
import 'package:intl_phone_number_input/src/models/country_list.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nricController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(text: "MY");

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _nricFocus = FocusNode();
  final FocusNode _address1Focus = FocusNode();
  final FocusNode _address2Focus = FocusNode();
  final FocusNode _pinCodeFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();

  PhoneNumber number = PhoneNumber(isoCode: 'MY');
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  bool isExpanded = false;
  Mall? selectedMall;
  StateItem? selectedState;
  String? selectedRace;
  IdType selectedType = authManager.idList.first;
  DateTime? dob;
  String? dateOfBirth;
  GenderType? selectedGender;


  bool genderSet = false;
  bool dobSet = false;
  bool raceSet = false;
  bool stateSet = false;
  bool fieldsSet = false;
  bool scrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    authManager.getStatesList();
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
                  title: Text("Edit Profile", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
                ),
                body: StreamBuilder<ApiResponse<UserProfileModel>?>(
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
                            if(!fieldsSet){
                              selectedType = authManager.idList.firstWhere((element) => element.id == userData?.profile?.idType);
                              _firstNameController.text = userData?.profile?.fname??"";
                              _lastNameController.text = userData?.profile?.lname??"";
                              _phoneController.text = userData?.profile?.phone??"";
                              number = PhoneNumber(isoCode: Countries.countryList.firstWhere((country) => country['dial_code'] == ("+${userData?.profile?.phoneCountry??'60'}"))["alpha_2_code"]??"MY", dialCode: '+${userData?.profile?.phoneCountry??"60"}', phoneNumber: '+${userData?.profile?.phoneCountry??"60"}${userData?.profile?.phone??""}');
                              _emailController.text = userData?.profile?.email??"";
                              _nricController.text = userData?.profile?.nric??"";
                              _address1Controller.text = userData?.profile?.address1??"";
                              _address2Controller.text = userData?.profile?.address2??"";
                              _postCodeController.text = userData?.profile?.postcode??"";
                              _cityController.text = userData?.profile?.city??"";
                              _countryController.text = userData?.profile?.countryOfResidence??"";
                              fieldsSet = true;
                            }
                            if(userData?.profile?.gender != null && int.tryParse(userData?.profile?.gender??"") != null && !genderSet){
                              selectedGender = userData?.profile?.gender == "1" ? authManager.genderList[0] : authManager.genderList[1];
                              genderSet = true;
                            }
                            if(userData?.profile?.dob != null && DateTime.tryParse(userData?.profile?.dob??"") != null && !dobSet){
                              dateOfBirth = userData?.profile?.dob??"";
                              dob = DateTime.parse(userData!.profile!.dob!);
                              dobSet = true;
                            }
                            if(userData?.profile?.race != null && !raceSet){
                              selectedRace = userData?.profile?.race;
                              raceSet = true;
                            }
                            if(!stateSet){
                              selectedState = StateItem(id: "00", state: userData?.profile?.region);
                            }
                            return editProfileBody(userData, buildContext);
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editProfileBody(UserProfileModel? data, BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
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
            PhoneTextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              title: "Phone Number",
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
            TitledTextField(
              controller: _emailController,
              focusNode: _emailFocus,
              title: "Email",
              hintText: "Email",
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
            ),
            nricDropdown(),
            genderSelect(),
            dobSelect(),
            raceSelect(),
            preferredMallDropdown(),
            SizedBox(height: 10.h,),
            expandedFields(),
            SizedBox(height: 20.h,),
            RoundButton(
              child: const Text("Save", style: TextStyle(fontSize: 16, fontFamily: "GothamMedium"),),
              borderRadius: 9,
              onPressed: () async {
                if(selectedRace == null) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please select your race", onOk: (){});
                } else if(selectedMall == null) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please select your preferred mall", onOk: (){});
                } else if(_address1Controller.text.trim().isEmpty) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter your Address", onOk: (){
                    _address1Focus.requestFocus();
                  });
                } else if(_cityController.text.trim().isEmpty) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter your City name", onOk: (){
                    _cityFocus.requestFocus();
                  });
                } else if(selectedState == null) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please select your State from dropdown", onOk: (){});
                } else if(_countryController.text.trim().isEmpty) {
                  AppUtils.showMessage(context: context, title: "Validation Error!", message: "Please enter your Country name", onOk: (){
                    _countryFocus.requestFocus();
                  });
                } else {
                  Map params = {
                    "custid": ApplicationGlobal.profile?.custid,
                    "mercid": "44",
                    // "title": "",
                    "fname": _firstNameController.text.trim(),
                    "lname": _lastNameController.text.trim(),
                    "email": _emailController.text.trim(),
                    "phone": number.phoneNumber?.replaceAll(number.dialCode ?? "+", ""),
                    "phone_country": number.dialCode?.replaceAll("+", ""),
                    "dob": dateOfBirth,
                    "nric": _nricController.text.trim(),
                    "id_type": selectedType.id.toString(),
                    // "display_name": "",
                    "gender": selectedGender?.id.toString(),
                    // "love_anniversary": "",
                    // "nationality": selectedRace,
                    "country": "MY",
                    "race": selectedRace,
                    // "householdincome": 0,
                    // "selectedinterests": "",
                    "address1": _address1Controller.text.trim(),
                    "address2": _address2Controller.text.trim(),
                    "state": selectedState?.state,
                    "city": _cityController.text.trim(),
                    "postcode": _postCodeController.text.trim(),
                    "mall": selectedMall?.id,
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
                    // update successful
                    AppUtils.showMessage(context: context, title: "Success!", message: "Your profile was updated successfully!", onOk: (){
                      profileManager.getProfile();
                      Navigator.pop(context);
                    });
                  } else {
                    AppUtils.showMessage(context: context, title: "Error!", message: updateResponse?.message??"Failed to update details.");
                  }
                }
              },
            ),
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

  Widget dobSelect() {
    return Column(
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
    );
  }

  Widget genderSelect() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gender", style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
          DropdownButton<GenderType>(
            value: selectedGender,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.lightBlack, size: 26.sp,),
            elevation: 16,
            style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 16.sp),
            underline: DecoratedBox(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp))),),
            onChanged: (GenderType? newValue) {
              setState(() {
                selectedGender = newValue!;
              });
            },
            hint: Text("Select gender", style: TextStyle(fontFamily: "GothamRegular", fontSize: 16.sp, color: const Color(0xFF919191)),),
            isDense: false,
            isExpanded: true,
            alignment: Alignment.centerLeft,
            borderRadius: BorderRadius.circular(9),
            items: authManager.genderList
                .map<DropdownMenuItem<GenderType>>((GenderType value) {
              return DropdownMenuItem<GenderType>(
                value: value,
                child: Text(value.name, style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 16.sp),),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget raceSelect() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Race", style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
          DropdownButton<String>(
            value: selectedRace,
            icon: Icon(Icons.keyboard_arrow_down, color: AppColors.lightBlack, size: 26.sp,),
            elevation: 16,
            style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 16.sp),
            underline: DecoratedBox(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.sp))),),
            onChanged: (String? newValue) {
              setState(() {
                selectedRace = newValue!;
              });
            },
            hint: Text("Select race", style: TextStyle(fontFamily: "GothamRegular", fontSize: 16.sp, color: const Color(0xFF919191)),),
            isDense: false,
            isExpanded: true,
            alignment: Alignment.centerLeft,
            borderRadius: BorderRadius.circular(9),
            items: ["Malay", "Chinese", "Indian", "Others"].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 16.sp),),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget preferredMallDropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Preferred Mall", style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamMedium")),
              TextSpan(text: "*", style: TextStyle(color: AppColors.primaryRed, fontSize: 16.sp, fontFamily: "Medium")),
            ],
          ),
        ),
        StreamBuilder<ApiResponse<MallListModel>?>(
            stream: dashboardManager.mallList,
            builder: (BuildContext context, AsyncSnapshot<ApiResponse<MallListModel>?> mallListSnapshot) {
              if (mallListSnapshot.hasData) {
                switch (mallListSnapshot.data!.status) {
                  case Status.LOADING:
                    debugPrint('Loading');
                    return const SizedBox();
                  case Status.COMPLETED:
                    debugPrint('Mall List Loaded');
                    selectedMall ??= mallListSnapshot.data!.data!.malls!.firstWhere((element) => element.defaultMall == true);
                    return DropdownButton<Mall>(
                      value: selectedMall,
                      icon: Icon(Icons.arrow_drop_down, color: AppColors.lightBlack, size: 28.sp,),
                      elevation: 16,
                      style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),
                      underline: Container(
                        height: 1.sp,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      onChanged: (Mall? newValue) {
                        setState(() {
                          selectedMall = newValue!;
                        });
                      },
                      isExpanded: true,
                      alignment: Alignment.centerLeft,
                      borderRadius: BorderRadius.circular(9),
                      items: mallListSnapshot.data?.data?.malls?.map<DropdownMenuItem<Mall>>((Mall value) {
                        return DropdownMenuItem<Mall>(
                          value: value,
                          child: Text(value.name??"", style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
                        );
                      }).toList(),
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
      ],
    );
  }

  Widget expandedFields() {
    if(isExpanded && !scrolledToBottom){
      Future.delayed(const Duration(milliseconds: 200), (){
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
          scrolledToBottom = true;
        });
        setState(() {});
      });
    } else {
      scrolledToBottom = false;
    }
    return CustomExpansionTile(
      onExpansionChanged: (value) => setState(() {isExpanded = value;}),
      childrenPadding: EdgeInsets.zero,
      expandedAlignment: Alignment.center,
      title: Row(
        children: [
          Expanded(child: Divider(color: AppColors.grey, height: 1.sp, thickness: 1.sp,),),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey, width: 1.sp),
              borderRadius: BorderRadius.circular(50),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
            child: Text(isExpanded ? "Show less -" : "Show more +", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: const Color(0xFF080808)),),
          ),
          Expanded(child: Divider(color: AppColors.grey, height: 1.sp, thickness: 1.sp,),),
        ],
      ),
      children: [
        TitledTextField(
          controller: _address1Controller,
          focusNode: _address1Focus,
          title: "Address 1",
          hintText: "Address 1",
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        TitledTextField(
          controller: _address2Controller,
          focusNode: _address2Focus,
          title: "Address 2",
          hintText: "Address 2",
          isMandatory: false,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        TitledTextField(
          controller: _postCodeController,
          focusNode: _pinCodeFocus,
          title: "Postcode",
          hintText: "Postcode",
          isMandatory: false,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.none,
        ),
        TitledTextField(
          controller: _cityController,
          focusNode: _cityFocus,
          title: "City",
          hintText: "City",
          isMandatory: true,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 10.h,),
        statesListDropdown(),
        SizedBox(height: 10.h,),
        TitledTextField(
          controller: _countryController,
          focusNode: _countryFocus,
          title: "Country",
          hintText: "Country",
          isMandatory: true,
          enabled: false,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget statesListDropdown() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "State", style: TextStyle(color: AppColors.textBlack, fontSize: 16.sp, fontFamily: "GothamMedium")),
              TextSpan(text: "*", style: TextStyle(color: AppColors.primaryRed, fontSize: 16.sp, fontFamily: "Medium")),
            ],
          ),
        ),
        StreamBuilder<ApiResponse<StatesModel>?>(
            stream: authManager.statesList,
            builder: (BuildContext context, AsyncSnapshot<ApiResponse<StatesModel>?> stateListSnapshot) {
              if (stateListSnapshot.hasData) {
                switch (stateListSnapshot.data!.status) {
                  case Status.LOADING:
                    debugPrint('Loading');
                    return const SizedBox();
                  case Status.COMPLETED:
                    debugPrint('Mall List Loaded');
                    if(selectedState != null && !stateSet){
                      String? currentState = selectedState?.state;
                      selectedState = stateListSnapshot.data?.data?.results?.firstWhere((element) => element.state == currentState);
                      currentState = null;
                      stateSet = true;
                    }
                    return DropdownButton<StateItem>(
                      value: selectedState,
                      icon: Icon(Icons.arrow_drop_down, color: AppColors.lightBlack, size: 28.sp,),
                      elevation: 16,
                      style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),
                      underline: Container(
                        height: 1.sp,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      onChanged: (StateItem? newValue) {
                        setState(() {
                          selectedState = newValue!;
                        });
                      },
                      hint: Text("Select State", style: TextStyle(color: Colors.grey, fontSize: 16.sp, fontFamily: "GothamRegular"),),
                      isExpanded: true,
                      alignment: Alignment.centerLeft,
                      borderRadius: BorderRadius.circular(9),
                      items: stateListSnapshot.data?.data?.results?.map<DropdownMenuItem<StateItem>>((StateItem value) {
                        return DropdownMenuItem<StateItem>(
                          value: value,
                          child: Text(value.state??"", style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
                        );
                      }).toList(),
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
      ],
    );
  }
}
