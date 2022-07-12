import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/profile_manager/profile_manager.dart';
import 'package:sogo_flutter/src/managers/rewards_manager/rewards_manager.dart';
import 'package:sogo_flutter/src/models/rewards/claim_reward_model.dart';
import 'package:sogo_flutter/src/models/rewards/reward_details_model.dart';
import 'package:sogo_flutter/src/models/profile/user_profile_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/rewards_merchant_details.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/rewards_more_details.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/custom_radio_list_tile.dart';
import 'package:sogo_flutter/src/widgets/round_button.dart';

class RewardDetails extends StatefulWidget {
  final String rewardId;
  const RewardDetails({Key? key, required this.rewardId}) : super(key: key);

  @override
  State<RewardDetails> createState() => _RewardDetailsState();
}

class _RewardDetailsState extends State<RewardDetails> {

  CollectionMethod? _selectedMethod;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    rewardsManager.getRewardDetails(rewardId: widget.rewardId);
  }

  @override
  Widget build(BuildContext buildContext) {
    return ModalProgressHUD(
      progressIndicator: LoadingIndicator(
        indicatorType: Indicator.ballScale,
        colors: [AppColors.primaryRed, AppColors.secondaryRed],
      ),
      inAsyncCall: isLoading,
      child: Stack(
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
                  Navigator.pop(buildContext);
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
                StreamBuilder<ApiResponse<UserProfileModel>?>(
                    stream: profileManager.profile,
                    builder: (BuildContext streamContext, AsyncSnapshot<ApiResponse<UserProfileModel>?> profileSnapshot) {
                      if (profileSnapshot.hasData) {
                        switch (profileSnapshot.data!.status) {
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
                            debugPrint('Profile Loaded');
                            return StreamBuilder<ApiResponse<RewardDetailsModel>?>(
                                stream: rewardsManager.rewardDetails,
                                builder: (BuildContext context, AsyncSnapshot<ApiResponse<RewardDetailsModel>?> snapshot) {
                                  if (snapshot.hasData) {
                                    switch (snapshot.data!.status) {
                                      case Status.LOADING:
                                        debugPrint('Loading');
                                        return const SizedBox();
                                      case Status.COMPLETED:
                                        debugPrint('Mall List Loaded');
                                        if(snapshot.data?.data?.details != null && snapshot.data!.data!.details!.isNotEmpty){
                                          return rewardDetailsBody(buildContext, snapshot.data!.data!.details!.first, profileSnapshot.data?.data);
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
                                });
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
    );
  }

  Widget rewardDetailsBody(BuildContext context, Detail rewardDetails, UserProfileModel? data) {
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
                  Text(rewardDetails.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  Text(rewardDetails.merchantInfo?.first.mall??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  (rewardDetails.description??"").isNotEmpty ? SizedBox(height: 20.h,) : const SizedBox(),
                  HtmlWidget(rewardDetails.description??"", textStyle: TextStyle(fontFamily: "MyriadRegular", color: AppColors.textGrey, fontSize: 15.sp),),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  Text("Validity period till ${rewardDetails.purchaseEnd}", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)),
                  Text(rewardDetails.points??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
                  rewardDetails.collectionMethod != null ? Divider(height: 30.h, thickness: 1.sp, color: AppColors.grey.withOpacity(0.14)) : const SizedBox(),
                  rewardDetails.collectionMethod != null ? redemptionMode(rewardDetails.collectionMethod!) : const SizedBox(),
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
                    if(_selectedMethod == null){
                      AppUtils.showMessage(context: context, title: "Error!", message: "Please select a collection method first!");
                    } else if(int.tryParse(data?.profile?.redeemablePoints??"") != null && rewardDetails.pointsRaw != null && int.parse(data?.profile?.redeemablePoints??"0") < rewardDetails.pointsRaw!){
                      AppUtils.showMessage(context: context, title: "Error!", message: "You have insufficient points for this redemption!");
                    } else {
                      debugPrint("Redeemable points ${data?.profile?.redeemablePoints}, raw points ${rewardDetails.pointsRaw}");
                      AppUtils.openBottomSheet(context: context, cornerRadius: 20, child: redeemDetails(context: context, name: rewardDetails.title??"", id: rewardDetails.id??"", price: rewardDetails.points??"", balance: data?.profile?.redeemablePoints??"", quantity: 1, onClaimClicked: () async {
                        setState(() {
                          isLoading = true;
                        });
                        ClaimRewardModel? response = await rewardsManager.rewardCheckout(rewardId: rewardDetails.id??"", qty: 1, collectionMethod: _selectedMethod?.id??"");
                        setState(() {
                          isLoading = false;
                        });
                        if(response?.status == "success") {
                          rewardsManager.getMyRewardsList(start: 0, offset: 0);
                          AppUtils.showCustomDialog(context: context, dialogBox: rewardRedeemed(context: context, onClick: (){
                            Navigator.pop(context);
                            rewardsManager.updateRewardsIndex(1);
                          },),);
                        }
                      }));
                    }
                  }, borderRadius: 9, child: Text("Claim Reward", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget redemptionMode(List<CollectionMethod> methods) {
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
            child: Text("Redemption Mode:", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
          ),
          Divider(height: 30.h, thickness: 3.sp, color: Colors.white),
          ...methods.map((e) => CustomRadioListTile<CollectionMethod>(
            dense: true,
            visualDensity: VisualDensity.compact,
            activeColor: AppColors.lightBlack,
            selectedTileColor: AppColors.lightBlack,
            tileColor: AppColors.grey,
            title: Text(e.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: _selectedMethod?.title == e.title ? AppColors.lightBlack : AppColors.grey),),
            value: e,
            groupValue: _selectedMethod,
            onChanged: (CollectionMethod? value) {
              setState(() {
                _selectedMethod = value;
              });
            },
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

  Widget redeemDetails({required BuildContext context, required String id, required String name, required int quantity, required String price, required String balance, required VoidCallback onClaimClicked}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("You Are Now Redeeming", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
          Divider(height: 40.sp, thickness: 1.sp, color: AppColors.grey.withOpacity(0.2),),
          Text(name, style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),),
          SizedBox(height: 20.h,),
          Text("Quantity: $quantity", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),),
          SizedBox(height: 20.h,),
          Text("Usage Points: $price", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),),
          SizedBox(height: 30.h,),
          Text("Points Balance: $balance Pts", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
          SizedBox(height: 30.h,),
          RoundButton(onPressed: (){
            Navigator.pop(context);
            onClaimClicked();
          }, borderRadius: 9, child: Text("Claim Reward", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white),)),
        ],
      ),
    );
  }

  Widget rewardRedeemed({required BuildContext context, required VoidCallback onClick}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
      child: Material(
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/ic_checked_in.png", height: 110.sp, width: 110.sp, fit: BoxFit.fitWidth,),
              SizedBox(height: 20.h,),
              Text("Reward Claimed", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamBold", fontSize: 20.sp, color: AppColors.lightBlack),),
              SizedBox(height: 20.h,),
              Text("Go to “My Rewards” to view.", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamBook", fontSize: 13.sp, color: AppColors.lightBlack),),
              SizedBox(height: 20.h,),
              RoundButton(onPressed: (){
                Navigator.pop(context);
                onClick();
              }, borderRadius: 9, child: Text("My Reward", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.white),)),
            ],
          ),
        ),
      ),
    );
  }
}
