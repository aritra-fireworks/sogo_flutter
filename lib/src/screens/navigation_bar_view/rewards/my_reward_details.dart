import 'package:barcode/barcode.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/rewards_manager/rewards_manager.dart';
import 'package:sogo_flutter/src/models/rewards/my_reward_details_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/rewards_merchant_details.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/rewards_more_details.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class MyRewardDetails extends StatefulWidget {
  final String rewardId;
  final String rewardType;
  const MyRewardDetails({Key? key, required this.rewardId, required this.rewardType}) : super(key: key);

  @override
  State<MyRewardDetails> createState() => _MyRewardDetailsState();
}

class _MyRewardDetailsState extends State<MyRewardDetails> {


  @override
  void initState() {
    super.initState();
    rewardsManager.getMyRewardDetails(rewardId: widget.rewardId, type: widget.rewardType);
  }

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
      width: width ?? 200.w,
      height: height ?? 80.h,
      fontHeight: fontHeight,
    );
    print('Svg: $svg');
    return svg;
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
            title: Text("Rewards", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
              StreamBuilder<ApiResponse<MyRewardDetailsModel>?>(
                  stream: rewardsManager.myRewardDetails,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<MyRewardDetailsModel>?> snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          debugPrint('Loading');
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                            ),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(color: AppColors.primaryRed,),
                          );
                        case Status.COMPLETED:
                          debugPrint('Mall List Loaded');
                          if(snapshot.data?.data?.details != null && snapshot.data!.data!.details!.isNotEmpty){
                            return rewardDetailsBody(context, snapshot.data!.data!.details!.first);
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

  Widget rewardDetailsBody(BuildContext context, MyRewardDetail rewardDetails) {
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
                  imageUrl: rewardDetails.featuredImage??"", fit: BoxFit.fitWidth,
                  placeholder: (context, url) => LoadingIndicator(
                    indicatorType: Indicator.ballScale,
                    colors: [AppColors.primaryRed, AppColors.secondaryRed],
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
                  Text(rewardDetails.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  Text(rewardDetails.merchantInfo?.first.mall??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  (rewardDetails.description??"").isNotEmpty ? SizedBox(height: 20.h,) : const SizedBox(),
                  HtmlWidget(rewardDetails.description??"", textStyle: TextStyle(fontFamily: "MyriadRegular", color: AppColors.textGrey, fontSize: 15.sp),),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  Text("Validity period till ${rewardDetails.purchaseEnd}", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  rewardDetails.merchantInfo != null ? redemptionMode(rewardDetails.merchantInfo!) : const SizedBox(),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  links(title: "More Details", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RewardMoreDetails(moreDetailsUrl: rewardDetails.moreDetails??"https://sogo.fireworksmedia.com"),));
                  }),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  links(title: "About Merchant", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantDetails(merchantId: rewardDetails.merchantInfo?.first.id != null ? rewardDetails.merchantInfo!.first.id! : "", mall: ApplicationGlobal.selectedMall!),));
                  }),
                  SizedBox(height: 30.h,),
                  RoundButton(onPressed: (){
                    openMyRewardsBottomSheet(context, rewardDetails);
                  }, borderRadius: 9, child: Text("Redeem Reward", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget redemptionMode(List<MerchantInfo> methods) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w),
            child: Text("Redemption Venue:", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
          ),
          Divider(height: 30.h, thickness: 3.sp, color: Colors.white),
          ...methods.map((e) => Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Text(e.mall??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
          ),).toList(),
          SizedBox(height: 15.h,),
        ],
      ),
    );
  }

  Widget links({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
          Icon(Icons.arrow_forward_ios, color: AppColors.lightBlack, size: 24.sp,),
        ],
      ),
    );
  }

  Widget qrCodeBottomSheet(BuildContext context, MyRewardDetail rewardDetails){
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            width: 60.w,
            height: 5.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.grey,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(rewardDetails.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.textBlack),),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Text("Show this QR / barcode to the cashier when making your purchase", style: TextStyle(fontFamily: "GothamBook", fontSize: 15.sp, color: AppColors.textBlack),),
        ),
        Center(
          child: InkWell(
            onTap: (){
              Clipboard.setData(ClipboardData(text: rewardDetails.qrcode??''));
              AppUtils.showToast("Code copied to clipboard.", color: Colors.green);
            },
            child: Column(
              children: [
                SizedBox(height: 10.h,),
                rewardDetails.qrCode??false ? Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: SvgPicture.string(buildBarcode(Barcode.qrCode(),rewardDetails.qrcode??'', width: size.width/2.8, height: size.width/2.8)),
                  ),
                ) : const SizedBox(),
                rewardDetails.qrCode??false ? SizedBox(height: 30.h,) : const SizedBox(),
                rewardDetails.barCode??false ? Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.h, bottom: 5.h),
                  child: SvgPicture.string(buildBarcode(Barcode.gs128(),rewardDetails.qrcode??'', fontHeight: 0)),
                ) :const SizedBox(),
                rewardDetails.barCode??false ? SizedBox(height: 20.h,) : const SizedBox(),
                rewardDetails.textCode??false ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${"Code: "} ${rewardDetails.qrcode??''}', style: TextStyle(fontFamily: "GothamBold", fontSize: 25.sp, color: const Color(0xFF404040)),),
                    SizedBox(width: 6.w,),
                    Icon(Icons.copy, color: AppColors.lightBlack, size: 20.sp,)
                  ],
                ) : const SizedBox(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Text('This Voucher will be marked as used after the timer ends', style: TextStyle(fontFamily: "GothamBook", fontSize: 15.sp, color: AppColors.textBlack),),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: RoundButton(onPressed: (){
            Navigator.pop(context);
          }, borderRadius: 9, child: Text("OK", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white),)),
        ),
      ],
    );
  }

  openMyRewardsBottomSheet(BuildContext context, MyRewardDetail rewardDetails) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        builder: (context) {
          return qrCodeBottomSheet(context, rewardDetails);
        });
  }
}
