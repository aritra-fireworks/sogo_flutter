import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/rewards_manager/rewards_manager.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/merchant_details_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/related_rewards_card.dart';

class MerchantDetails extends StatefulWidget {
  final String merchantId;
  final Mall mall;
  const MerchantDetails({Key? key, required this.merchantId, required this.mall}) : super(key: key);

  @override
  State<MerchantDetails> createState() => _MerchantDetailsState();
}

class _MerchantDetailsState extends State<MerchantDetails> {


  @override
  void initState() {
    super.initState();
    rewardsManager.getMerchantDetails(mall: widget.mall.id??"0", merchantId: widget.merchantId);
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
            title: Text("About Merchant", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
              StreamBuilder<ApiResponse<MerchantDetailsModel>?>(
                  stream: rewardsManager.merchantDetails,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<MerchantDetailsModel>?> snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data!.status) {
                        case Status.LOADING:
                          debugPrint('Loading');
                          return const SizedBox();
                        case Status.COMPLETED:
                          debugPrint('Mall List Loaded');
                          if(snapshot.data?.data != null){
                            return rewardDetailsBody(context, snapshot.data!.data!);
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

  Widget rewardDetailsBody(BuildContext context, MerchantDetailsModel merchantDetailsModel, ) {
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
                  imageUrl: merchantDetailsModel.merchantDetails?.featuredImage??"", fit: BoxFit.fitWidth,
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
                  Text(merchantDetailsModel.merchantDetails?.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  SizedBox(height: 15.h,),
                  HtmlWidget(merchantDetailsModel.merchantDetails?.description??"", textStyle: TextStyle(fontFamily: "MyriadRegular", color: AppColors.textGrey, fontSize: 15.sp),),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  tiles(icon: CupertinoIcons.location_solid, title: "Where", subtitle: merchantDetailsModel.merchantDetails?.address??"", onTap: (){}),
                  tiles(icon: CupertinoIcons.time_solid, title: "Opening Hours", subtitle: "${merchantDetailsModel.merchantDetails?.openTime??''} - ${merchantDetailsModel.merchantDetails?.closeTime??''}", onTap: (){}),
                  tiles(icon: CupertinoIcons.phone_solid, title: "Contact Number", subtitle: merchantDetailsModel.merchantDetails?.contact??"", onTap: (){}),
                  tiles(icon: CupertinoIcons.globe, title: "Website", subtitle: merchantDetailsModel.merchantDetails?.weburl??"", onTap: (){}),
                  SizedBox(height: 15.h,),
                  otherRewards(merchantDetailsModel.relatedRewards),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget tiles({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 26.sp, color: const Color(0xFF28603E),),
      minLeadingWidth: 26.sp,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      title: Text(title, style: TextStyle(color: const Color(0xFF262626), fontFamily: "GothamBook", fontSize: 15.sp),),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h,),
          Text(subtitle, style: TextStyle(color: const Color(0xFF262626), fontFamily: "GothamMedium", fontSize: 15.sp),),
          SizedBox(height: 10.h,),
          Divider(height: 10.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
        ],
      ),
    );
  }

  Widget otherRewards(List<RelatedReward>? relatedRewards) {
    if(relatedRewards != null && relatedRewards.isNotEmpty){
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: relatedRewards.length + 1,
        itemBuilder: (context, index) {
          if(index == 0){
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text("Other Rewards", style: TextStyle(color: const Color(0xFF262626), fontFamily: "GothamMedium", fontSize: 15.sp),),
            );
          }
          index--;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: RelatedRewardsCard(reward: relatedRewards[index]),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
