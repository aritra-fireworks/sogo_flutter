import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/models/rewards/my_rewards_list_model.dart';

class MyRewardCardView extends StatefulWidget {
  final Wallet wallet;
  final List<Mall> malls;
  const MyRewardCardView({Key? key, required this.wallet, required this.malls}) : super(key: key);

  @override
  State<MyRewardCardView> createState() => _MyRewardCardViewState();
}

class _MyRewardCardViewState extends State<MyRewardCardView> {

  bool imageFailed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.sp,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                width: 100.sp,
                height: 100.sp,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    image: imageFailed ? const DecorationImage(image: AssetImage("assets/images/pic_placeholder.png"), fit: BoxFit.fill) : DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.wallet.img??"",
                          errorListener: () => setState(() => imageFailed = true),
                        ),
                        fit: BoxFit.fill
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightBlack, width: 2),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4.sp),
                  child: Text("x${widget.wallet.units??"0"}", style: TextStyle(color: AppColors.lightBlack, fontFamily: "GothamRegular", fontSize: 13.sp),),
                ),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(alignment: Alignment.centerRight, child: Text("Until ${widget.wallet.expiredDate}", style: TextStyle(fontFamily: "GothamRegular", fontSize: 7.sp, color: AppColors.lightBlack.withOpacity(0.4)),)),
                  SizedBox(height: 6.sp,),
                  Text(widget.wallet.name??"", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 20.sp,
                      width: 20.sp,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: CachedNetworkImage(
                          imageUrl: widget.malls[widget.malls.indexWhere((element) => element.id == widget.wallet.mall.toString())].mallIconWhite??"", fit: BoxFit.cover,
                          placeholder: (context, url) => LoadingIndicator(
                            indicatorType: Indicator.ballScale,
                            colors: [AppColors.primaryRed, AppColors.secondaryRed],
                          ),
                          errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", fit: BoxFit.cover,),
                        ),
                      ),
                    ),
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
