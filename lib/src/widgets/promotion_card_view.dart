import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/models/promotions/promotions_list_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/dashboard/dashboard_view.dart';

class PromotionCardView extends StatelessWidget {
  final News promotion;
  final String locationIcon;
  const PromotionCardView({Key? key, required this.promotion, required this.locationIcon,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BlurBgRoundedImage(imagePath: promotion.featuredImg??"",),
          ),
          SizedBox(height: 10.h,),
          Text(promotion.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 12.sp, color: AppColors.lightBlack),),
          SizedBox(height: 8.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(promotion.endDateText??"", style: TextStyle(fontFamily: "GothamBook", fontSize: 12.sp, color: AppColors.textGrey),),
              SizedBox(
                height: 20.sp,
                width: 20.sp,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: CachedNetworkImage(
                    imageUrl: locationIcon, fit: BoxFit.cover,
                    placeholder: (context, url) => LoadingIndicator(
                      indicatorType: Indicator.ballScale,
                      colors: [AppColors.primaryRed, AppColors.secondaryRed],
                    ),
                    errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", fit: BoxFit.cover,),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
