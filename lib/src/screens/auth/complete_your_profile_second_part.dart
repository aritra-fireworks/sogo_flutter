import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:sogo_flutter/src/models/auth/points_details_model.dart';
import 'package:sogo_flutter/src/models/auth/states_model.dart';
import 'package:sogo_flutter/src/screens/auth/profile_completed_popup.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/nav_bar_view.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/utils/device_info.dart';
import 'package:sogo_flutter/src/widgets/custom_radio_list_tile.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';
import 'package:sogo_flutter/src/widgets/titled_text_field.dart';

class CompleteYourProfileSecondPartScreen extends StatefulWidget {
  const CompleteYourProfileSecondPartScreen({Key? key}) : super(key: key);

  @override
  State<CompleteYourProfileSecondPartScreen> createState() => _CompleteYourProfileSecondPartScreenState();
}

class _CompleteYourProfileSecondPartScreenState extends State<CompleteYourProfileSecondPartScreen> {

  bool isLoading = false;
  Mall? selectedMall;
  StateItem? selectedState;
  String? selectedRace;

  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(text: "Malaysia");

  final FocusNode _address1Focus = FocusNode();
  final FocusNode _address2Focus = FocusNode();
  final FocusNode _pinCodeFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    dashboardManager.getMallList(withoutToken: true);
    authManager.getStatesList(withoutToken: true);
  }

  @override
  Widget build(BuildContext buildContext) {
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
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
                    onPressed: () {
                      Navigator.pop(buildContext);
                    },
                  ),
                  centerTitle: true,
                  title: Text("Complete Your Profile", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                      child: completeProfileBody(buildContext)),
                )),
          ],
        ));
  }

  Widget completeProfileBody(BuildContext buildContext) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text("Getting To Know You Better", style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamBold"),),
              ),
              SizedBox(height: 30.h,),
              raceSelect(),
              SizedBox(height: 20.h,),
              preferredMallDropdown(),
              SizedBox(height: 10.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: TitledTextField(
                  controller: _address1Controller,
                  focusNode: _address1Focus,
                  title: "Address 1",
                  hintText: "Address 1",
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: TitledTextField(
                  controller: _address2Controller,
                  focusNode: _address2Focus,
                  title: "Address 2",
                  hintText: "Address 2",
                  isMandatory: false,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: TitledTextField(
                  controller: _postCodeController,
                  focusNode: _pinCodeFocus,
                  title: "Postcode",
                  hintText: "Postcode",
                  isMandatory: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: TitledTextField(
                  controller: _cityController,
                  focusNode: _cityFocus,
                  title: "City",
                  hintText: "City",
                  isMandatory: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              SizedBox(height: 10.h,),
              statesListDropdown(),
              SizedBox(height: 10.h,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: TitledTextField(
                  controller: _countryController,
                  focusNode: _countryFocus,
                  title: "Country",
                  hintText: "Country",
                  isMandatory: true,
                  enabled: false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              SizedBox(height: 20.h,),
              StreamBuilder<ApiResponse<PointsDetailsModel>?>(
                  stream: authManager.pointsDetails,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<PointsDetailsModel>?> snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          debugPrint('Loading');
                          return const SizedBox();
                        case Status.COMPLETED:
                          debugPrint('Mall List Loaded');
                          String? profileCompletePoints = snapshot.data?.data?.completeprofile;
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: RoundButton(
                              child: const Text("Next", style: TextStyle(fontSize: 16, fontFamily: "GothamMedium"),),
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
                                    "custid": ApplicationGlobal.custId,
                                    "mercid": "44",
                                    // "title": "",
                                    // "fname": "",
                                    // "lname": "",
                                    // "email": "",
                                    // "phone": "",
                                    // "phone_country": "",
                                    // "dob": dateOfBirth,
                                    // "nric": _nricController.text.trim(),
                                    // "id_type": selectedType.id,
                                    // "display_name": "",
                                    // "gender": selectedGender?.id,
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
                                    AppUtils.showCustomDialog(context: buildContext, withConfetti: true, dialogBox: ProfileCompletedPopup(message: "You have been rewarded $profileCompletePoints Pts.", onOkClicked: (){
                                      Navigator.push(buildContext, MaterialPageRoute(builder: (context) => const NavBarView(),));
                                    },));
                                  } else {
                                    AppUtils.showMessage(context: buildContext, title: "Error!", message: updateResponse?.message??"Failed to update details.");
                                  }
                                }
                              },
                            ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: RoundOutlineButton(
                  child: const Text("Skip for Now", style: TextStyle(fontSize: 16, fontFamily: "GothamBold", color: AppColors.lightBlack),),
                  borderRadius: 9,
                  onPressed: () async {
                    Navigator.pushReplacement(buildContext, MaterialPageRoute(builder: (context) => const NavBarView(),));
                  },
                ),
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Widget preferredMallDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
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
      ),
    );
  }

  Widget raceSelect() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text("What’s Your Race?", style: TextStyle(fontFamily: "GothamMedium", color: AppColors.lightBlack, fontSize: 15.sp),),
        ),
        SizedBox(height: 10.sp,),
        ...["Malay", "Chinese", "Indian", "Others"].map((e) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: CustomRadioListTile<String>(
            dense: true,
            visualDensity: VisualDensity.compact,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primaryRed,
            selectedTileColor: AppColors.lightBlack,
            title: Text(e, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: selectedRace == e ? AppColors.lightBlack : AppColors.grey),),
            value: e,
            groupValue: selectedRace,
            onChanged: (String? value) {
              setState(() {
                selectedRace = value;
              });
            },
          ),
        ),).toList()
      ],
    );
  }

  Widget statesListDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
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
      ),
    );
  }
}

