import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/screens/auth/set_password.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';


class MigrationConfirmationView extends StatefulWidget {
  const MigrationConfirmationView({Key? key}) : super(key: key);

  @override
  State<MigrationConfirmationView> createState() => _MigrationConfirmationViewState();
}

class _MigrationConfirmationViewState extends State<MigrationConfirmationView> {


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
                    title: Text("Confirmation", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                        child: migrationConfirmationBody(context)),
                  )),
            ],
          )),
    );
  }

  Widget migrationConfirmationBody(BuildContext context) {
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
            Text("Please confirm the details are accurate before we create a New Sogo Card for you.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
            Divider(height: 40.sp, thickness: 1.sp, color: AppColors.grey.withOpacity(0.2),),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Name : ", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack)),
                  TextSpan(text: "${ApplicationGlobal.firstName} ${ApplicationGlobal.lastName}", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack)),
                ],
              ),
            ),
            SizedBox(height: 12.h,),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Email : ", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack)),
                  TextSpan(text: "${ApplicationGlobal.email}", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack)),
                ],
              ),
            ),
            SizedBox(height: 12.h,),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Phone : ", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack)),
                  TextSpan(text: "${ApplicationGlobal.phone?.phoneNumber}", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack)),
                ],
              ),
            ),
            SizedBox(height: 12.h,),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "NRIC / Passport : ", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack)),
                  TextSpan(text: "${ApplicationGlobal.nric}", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack)),
                ],
              ),
            ),
            Divider(height: 40.sp, thickness: 1.sp, color: AppColors.grey.withOpacity(0.2),),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Total Points Balance : ", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack)),
                  TextSpan(text: "${ApplicationGlobal.pointsBalance} Pts", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack)),
                ],
              ),
            ),
            SizedBox(height: 30.h,),
            RoundButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SetPasswordScreen(isMigration: true,),));
              },
              borderRadius: 9,
              child: const Text("I Confirm that the Details are Correct", style: TextStyle(fontFamily: "GothamBold", fontSize: 15, color: Colors.white),),
            ),
            SizedBox(height: 30.h,),
          ],
        ),
      ),
    );
  }
}
