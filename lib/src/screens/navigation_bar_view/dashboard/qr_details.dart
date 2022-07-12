import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/models/profile/user_profile_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';

class QrDetails extends StatefulWidget {
  const QrDetails({Key? key}) : super(key: key);

  @override
  State<QrDetails> createState() => _QrDetailsState();
}

class _QrDetailsState extends State<QrDetails> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ApiResponse<UserProfileModel>?>(
        stream: profileManager.profile,
        builder: (BuildContext context, AsyncSnapshot<ApiResponse<UserProfileModel>?> profileSnapshot) {
          if (profileSnapshot.hasData) {
            switch (profileSnapshot.data!.status) {
              case Status.LOADING:
                debugPrint('Loading');
                return Center(child: CircularProgressIndicator(color: AppColors.primaryRed,));
              case Status.COMPLETED:
                debugPrint('Dashboard Loaded');
                return qrBody(profileSnapshot.data?.data);
              case Status.NODATAFOUND:
                debugPrint('Not found');
                return const SizedBox();
              case Status.ERROR:
                debugPrint('Error');
                return const SizedBox();
            }
          }
          return Container();
        });
  }
  
  Widget qrBody(UserProfileModel? data) {
    Size size = MediaQuery.of(context).size;
    String buildBarcode(
        Barcode bc,
        String data, {
          String? filename,
          double? width,
          double? height,
          double? fontHeight,
        }) {
      /// Create the Barcode
      final svg = bc.toSvg(
        data,
        width: width ?? size.width * 0.7,
        height: height ?? 60.h,
        fontHeight: fontHeight,
      );
      debugPrint('Svg: $svg');
      return svg;
    }
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.string(buildBarcode(Barcode.qrCode(), data?.profile?.qrcode??"", width: size.width/2.8, height: size.width/2.8)),
            ),
            SizedBox(height: 40.h,),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 5),
                child: SvgPicture.string(buildBarcode(Barcode.gs128(), data?.profile?.cardno??"", fontHeight: 0)),
              ),
            ),
            SizedBox(height: 10.h,),
            tile(imagePath: "assets/images/ic_card_no.png", title: data?.profile?.cardno??"000000", fontSize: 20),
            tile(imagePath: "assets/images/ic_name.png", title: data?.profile?.name??"User"),
            tile(imagePath: "assets/images/ic_points.png", title: "${data?.profile?.points??"0"} Pts", showDivider: false),
          ],
        ),
      ),
    );
  }
  
  Widget tile({required String imagePath, required String title, double fontSize = 15, bool showDivider = true}) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.7 + 16,
      child: Column(
        children: [
          SizedBox(height: 15.h,),
          Row(
            children: [
              Image.asset(imagePath, width: 25.sp, height: 25.sp,),
              SizedBox(width: 10.w,),
              Expanded(
                child: Text(title, style: TextStyle(fontFamily: "GothamBold", fontSize: fontSize.sp, color: AppColors.textBlack),),
              ),
            ],
          ),
          SizedBox(height: 15.h,),
          if(showDivider)
            Divider(height: 1, thickness: 1, color: AppColors.primaryRed.withOpacity(0.17),),
        ],
      ),
    );
  }
}
