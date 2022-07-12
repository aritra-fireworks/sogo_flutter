import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/promotions_manager/promotions_manager.dart';
import 'package:sogo_flutter/src/models/promotions/promotion_details_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_outline_button.dart';

class PromotionDetails extends StatefulWidget {
  final String promotionId;
  const PromotionDetails({Key? key, required this.promotionId}) : super(key: key);

  @override
  State<PromotionDetails> createState() => _PromotionDetailsState();
}

class _PromotionDetailsState extends State<PromotionDetails> {

  format(DateTime date, {bool showYear = true}) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    if(showYear) {
      return DateFormat("d'$suffix' MMMM, yyyy").format(date);
    } else {
      return DateFormat("d'$suffix' MMMM").format(date);
    }
  }

  @override
  void initState() {
    super.initState();
    promotionsManager.getPromotionDetails(promotionId: widget.promotionId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            title: Text("Promotions", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                ),
                margin: EdgeInsets.only(top: 80.h),
              ),
              StreamBuilder<ApiResponse<PromotionDetailsModel>?>(
                  stream: promotionsManager.promotionDetails,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<PromotionDetailsModel>?> snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          debugPrint('Loading');
                          return const SizedBox();
                        case Status.COMPLETED:
                          debugPrint('Mall List Loaded');
                          if(snapshot.data?.data?.news != null && snapshot.data!.data!.news!.isNotEmpty){
                            return promotionDetailsBody(context, snapshot.data!.data!.news!.first);
                          }
                          return Center(
                            child: Text("No details found", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),),
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
                  })
            ],
          ),
        ),
      ],
    );
  }

  Widget promotionDetailsBody(BuildContext context, News promotionDetails) {
    bool showYear = true;
    if(promotionDetails.startDate?.split("-").first == promotionDetails.endDate?.split("-").first){
      showYear = false;
    }
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: CachedNetworkImage(
                  imageUrl: promotionDetails.featuredImg??"", fit: BoxFit.fitWidth,
                  placeholder: (context, url) => AspectRatio(
                    aspectRatio: 1.8,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballScale,
                      colors: [AppColors.primaryRed, AppColors.secondaryRed],
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", fit: BoxFit.fitWidth,),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(promotionDetails.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  SizedBox(height: 15.h,),
                  promotionTile(iconPath: "assets/images/ic_event_date.png", title: "${format(DateFormat("yyyy-MM-dd").parse(promotionDetails.startDate?.trim()??"2022-05-25"), showYear: showYear)} - ${format(DateFormat("yyyy-MM-dd").parse(promotionDetails.endDate?.trim()??"2022-05-25"))}"),
                  SizedBox(height: 10.h,),
                  promotionTile(iconPath: "assets/images/ic_event_location.png", title: promotionDetails.location?.trim()??""),
                  SizedBox(height: 20.h,),
                  HtmlWidget(promotionDetails.description??"", textStyle: TextStyle(fontFamily: "MyriadRegular", color: AppColors.textGrey, fontSize: 15.sp),),
                  SizedBox(height: 30.h,),
                  RoundOutlineButton(onPressed: (){
                    if(promotionDetails.link != null && promotionDetails.link!.isNotEmpty) {
                      Share.share(promotionDetails.link ?? "", subject: 'Look what I found!');
                    } else {
                      AppUtils.showToast("This promotion doesn't have a link to share.");
                    }
                  }, borderRadius: 9, child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.arrowshape_turn_up_right_fill, color: AppColors.primaryRed, size: 15.sp,),
                      SizedBox(width: 10.w,),
                      Text("Share", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.primaryRed),),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget promotionTile({required String iconPath, required String title}) {
    return Row(
      children: [
        Image.asset(iconPath, width: 15.w,),
        SizedBox(width: 15.w,),
        Flexible(child: Text(title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),)),
      ],
    );
  }
}
