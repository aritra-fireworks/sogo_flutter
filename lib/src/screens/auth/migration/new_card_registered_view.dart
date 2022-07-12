import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/auth/points_details_model.dart';
import 'package:sogo_flutter/src/screens/auth/account_created_popup.dart';
import 'package:sogo_flutter/src/screens/auth/complete_your_profile.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class NewCardRegisteredView extends StatefulWidget {
  const NewCardRegisteredView({Key? key}) : super(key: key);

  @override
  State<NewCardRegisteredView> createState() => _NewCardRegisteredViewState();
}

class _NewCardRegisteredViewState extends State<NewCardRegisteredView> {

  static late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 1));
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _controllerCenter.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFE14F67),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -60.sp,
                right: -50.sp,
                child: circles(size: 240.sp, color: Colors.white.withOpacity(0.4)),
              ),
              Positioned(
                top: 60.sp,
                left: -80.sp,
                child: circles(size: 240.sp, color: Colors.white.withOpacity(0.4)),
              ),
              Positioned(
                top: size.height * 0.5,
                left: -50.sp,
                child: circles(size: 100.sp, color: Colors.black.withOpacity(0.25)),
              ),
              Positioned(
                bottom: 80.h,
                right: -100.sp,
                child: circles(size: 200.sp, color: Colors.black.withOpacity(0.25)),
              ),
              Positioned(
                bottom: -100.sp,
                left: -100.sp,
                child: circles(size: 200.sp, color: Colors.black.withOpacity(0.25)),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.asset("assets/images/new_card.png", fit: BoxFit.fitWidth,),
                          Align(
                            alignment: Alignment.center,
                            child: ConfettiWidget(
                              confettiController: _controllerCenter,
                              numberOfParticles: 50,
                              blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
                              emissionFrequency: 0.01,
                              shouldLoop: false, // start again as soon as the animation is finished
                              colors: const [
                                Colors.green,
                                Colors.blue,
                                Colors.pink,
                                Colors.orange,
                                Colors.purple
                              ], // manually specify the colors to be used
                              createParticlePath: AppUtils.drawStar, // define a custom shape/path.
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        child: Column(
                          children: [
                            Text("New Card Registered !", style: TextStyle(fontFamily: "GothamBold", fontSize: 47.sp, color: Colors.white),),
                            SizedBox(height: 10.h,),
                            Text("We have created a New Sogo Card for you!", style: TextStyle(fontFamily: "GothamRegular", fontSize: 20.sp, color: Colors.white),),
                            SizedBox(height: 40.h,),
                            StreamBuilder<ApiResponse<PointsDetailsModel>?>(
                                stream: authManager.pointsDetails,
                                builder: (BuildContext context, AsyncSnapshot<ApiResponse<PointsDetailsModel>?> snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data!.status) {
                                      case Status.LOADING:
                                        debugPrint('Loading');
                                        return const SizedBox();
                                      case Status.COMPLETED:
                                        String? registerPoints = snapshot.data?.data?.register;
                                        return RoundButton(
                                          onPressed: (){
                                            AppUtils.showCustomDialog(context: context, withConfetti: true, dialogBox: AccountCreatedPopup(message: "You have been rewarded $registerPoints Pts.", onOk: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => CompleteYourProfileScreen(context: context),));
                                            },));
                                          },
                                          borderRadius: 9,
                                          color: Colors.white,
                                          child: Text("OK", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.primaryRed),),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget circles({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, spreadRadius: 1, blurRadius: 40)]
      ),
    );
  }
}
