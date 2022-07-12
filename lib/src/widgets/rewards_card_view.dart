import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/models/profile/dashboard_model.dart';

class RewardsCard extends StatefulWidget {
  final HotDeal reward;
  final String locationIcon;
  const RewardsCard({Key? key, required this.reward, required this.locationIcon}) : super(key: key);

  @override
  State<RewardsCard> createState() => _RewardsCardState();
}

class _RewardsCardState extends State<RewardsCard> {

  bool imageFailed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.sp,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.sp,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                image: imageFailed ? const DecorationImage(image: AssetImage("assets/images/pic_placeholder.png"), fit: BoxFit.contain) : DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.reward.img??"",
                      errorListener: () => setState(() => imageFailed = true),
                    ),
                    fit: BoxFit.contain
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.reward.label != null && widget.reward.label!.isNotEmpty ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primaryRed.withOpacity(0.11),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        child: Text(widget.reward.label??"", style: TextStyle(fontFamily: "GothamBold", fontSize: 7.sp, color: AppColors.primaryRed.withOpacity(0.4)),),
                      ) : const SizedBox(),
                      Text("Until ${widget.reward.date}", style: TextStyle(fontFamily: "GothamRegular", fontSize: 7.sp, color: AppColors.lightBlack.withOpacity(0.4)),),
                    ],
                  ),
                  SizedBox(height: 6.sp,),
                  Text(widget.reward.name??"", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  const Spacer(),
                  Row(
                    children: [
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(text: "${widget.reward.point}", style: TextStyle(fontFamily: "GothamMedium", fontSize: 12.sp, color: AppColors.primaryRed),),
                          TextSpan(text: num.tryParse(widget.reward.point?.replaceAll(",", "")??"") != null ? " Pts" : "", style: TextStyle(fontFamily: "GothamMedium", fontSize: 12.sp, color: Colors.black),),
                        ],
                      )),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: const Color(0xFF559E62),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        child: Text("In-Store", style: TextStyle(fontFamily: "GothamMedium", fontSize: 11.sp, color: Colors.white),),
                      ),
                      SizedBox(width: 10.w,),
                      SizedBox(
                        height: 20.sp,
                        width: 20.sp,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: CachedNetworkImage(
                            imageUrl: widget.locationIcon, fit: BoxFit.cover,
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
            ),
          ),
        ],
      ),
    );
  }
}
