import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/screens/auth/migration/migration_options_screen.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';


class ExistingSogoCardScreen extends StatefulWidget {
  final MigrationType migrationType;
  const ExistingSogoCardScreen({Key? key, required this.migrationType}) : super(key: key);

  @override
  State<ExistingSogoCardScreen> createState() => _ExistingSogoCardScreenState();
}

class _ExistingSogoCardScreenState extends State<ExistingSogoCardScreen> {

  // final TextEditingController _emailController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

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
          child: Stack(
            children: [
              Container(
                height: 200.h,
                decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
              ),
              Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    leading: const SizedBox(),
                    centerTitle: true,
                    title: Text("Existing Sogo Card Member", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                        child: existingSogoCardBody(buildContext)),
                  )),
            ],
          )),
    );
  }

  Widget existingSogoCardBody(BuildContext buildContext) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Image.asset("assets/images/existing_sogo_card.png", fit: BoxFit.fitWidth,),
                ],
              ),
              SizedBox(height: 20.h,),
              Text("We have detected that you are an existing Sogo card member. Moving forward, we will move your account to the NEW SOGO Loyalty with better privileges and benefits for you, absolutely free. \n\nDon’t worry, your points balance and important data will be carried forward!", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),),
              SizedBox(height: 20.h,),
              Text("Shall we proceed?", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
              SizedBox(height: 30.h,),
              RoundButton(
                onPressed: (){
                  // AppUtils.showCustomDialog(context: context, dialogBox: CheckUserExistsPopup(controller: _emailController, onClickNext: () async {
                  //   if(_emailController.text.trim().isEmpty){
                  //     AppUtils.showToast("Enter your email address");
                  //   } else if(!_emailController.text.trim().isEmail()){
                  //     AppUtils.showToast("Please enter a valid email");
                  //   } else {
                  //     setState(() {
                  //       isLoading = true;
                  //     });
                  //     CommonResponseModel? response = await authManager.migrationResetPassword(type: "Migration_Reset_Password", email: _emailController.text.trim());
                  //     setState(() {
                  //       isLoading = false;
                  //     });
                  //     if(response?.status == "success"){
                  //       AppUtils.showCustomDialog(context: buildContext, dialogBox: ActivationLinkSentPopup(email: _emailController.text.trim(), onOkClicked: (){
                  //         Navigator.pop(buildContext);
                  //       },));
                  //     } else {
                  //       AppUtils.showCustomDialog(context: buildContext, dialogBox: ActivationNotFoundPopup(message: response?.message??"",));
                  //     }
                  //   }
                  // },));
                  Navigator.push(buildContext, MaterialPageRoute(builder: (context) => MigrationOptionScreen(migrationType: widget.migrationType),));
                },
                borderRadius: 9,
                child: Text("Yes, Proceed to New SOGO Loyalty", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white),),
              ),
              SizedBox(height: 10.h,),
              RoundOutlineButton(
                onPressed: (){
                  Navigator.pop(buildContext);
                },
                borderRadius: 9,
                child: Text("Maybe Later", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
              ),
              SizedBox(height: 30.h,),
            ],
          ),
        ),
      ),
    );
  }
}

// extension on String {
//   bool isEmail() => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
// }