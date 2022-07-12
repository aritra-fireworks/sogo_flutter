import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/models/auth/points_details_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';

class CompleteProfilePopup extends StatelessWidget {
  final VoidCallback? onCompleteNow;
  final VoidCallback? onLater;
  const CompleteProfilePopup({Key? key, this.onCompleteNow, this.onLater}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: StreamBuilder<ApiResponse<PointsDetailsModel>?>(
              stream: authManager.pointsDetails,
              builder: (BuildContext context, AsyncSnapshot<ApiResponse<PointsDetailsModel>?> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      debugPrint('Loading');
                      return const SizedBox();
                    case Status.COMPLETED:
                      debugPrint('Points details Loaded');
                      String? completeProfilePoints = snapshot.data?.data?.completeprofile;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/images/ic_get_pts.png", width: 160.w, fit: BoxFit.fitWidth,),
                          SizedBox(height: 20.h,),
                          Text("Get the most out of your Membership. Complete your Profile Info. and be rewarded with $completeProfilePoints Pts.", textAlign: TextAlign.center, style: TextStyle(color: AppColors.lightBlack, fontSize: 15.sp, fontFamily: "GothamRegular"),),
                          SizedBox(height: 20.h,),
                          RoundButton(onPressed: (){
                            Navigator.pop(context);
                            if(onCompleteNow != null) onCompleteNow!();
                          }, borderRadius: 9, child: Text("Complete Now", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: Colors.white),),),
                          SizedBox(height: 10.h,),
                          RoundOutlineButton(onPressed: (){
                            Navigator.pop(context);
                            if(onLater != null) onLater!();
                          }, borderRadius: 9, child: Text("Update Later", style: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", color: AppColors.lightBlack),),),
                        ],
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
        ),
      ),
    );
  }
}
