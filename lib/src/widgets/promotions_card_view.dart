import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/models/profile/dashboard_model.dart';

class PromotionsCard extends StatefulWidget {
  final Promotion promotion;
  const PromotionsCard({Key? key, required this.promotion}) : super(key: key);

  @override
  State<PromotionsCard> createState() => _PromotionsCardState();
}

class _PromotionsCardState extends State<PromotionsCard> {

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
                    widget.promotion.featuredImg??"",
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
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.promotion.title??"", maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  const Spacer(),
                  Text("${widget.promotion.startDate} to ${widget.promotion.endDate}", style: TextStyle(fontFamily: "GothamRegular", fontSize: 10.sp, color: AppColors.primaryRed),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
