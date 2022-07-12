import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/dashboard_manager/dashboard_manager.dart';
import 'package:sogo_flutter/src/managers/promotions_manager/promotions_manager.dart';
import 'package:sogo_flutter/src/managers/ui_manager/nav_bar_manager.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/models/promotions/promotions_list_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/promotions/promotion_details.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/widgets/promotion_card_view.dart';

class PromotionsView extends StatefulWidget {
  const PromotionsView({Key? key}) : super(key: key);

  @override
  State<PromotionsView> createState() => _PromotionsViewState();
}

class _PromotionsViewState extends State<PromotionsView> {

  Mall? selectedMall;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    promotionsManager.getPromotionsList(start: 0, offset: 0);
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
                navManager.updateNavIndex(0);
              },
            ),
            centerTitle: true,
            title: Text("Promotions", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
          ),
          body: StreamBuilder<ApiResponse<MallListModel>?>(
              stream: dashboardManager.mallList,
              builder: (BuildContext context, AsyncSnapshot<ApiResponse<MallListModel>?> mallListSnapshot) {
                if (mallListSnapshot.hasData) {
                  switch (mallListSnapshot.data!.status) {
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
                      selectedMall ??= ApplicationGlobal.selectedMall ?? mallListSnapshot.data!.data!.malls!.firstWhere((element) => element.defaultMall == true);
                      return StreamBuilder<ApiResponse<PromotionsListModel>?>(
                          stream: promotionsManager.promotionsList,
                          builder: (BuildContext context, AsyncSnapshot<ApiResponse<PromotionsListModel>?> eventsListSnapshot) {
                            if (eventsListSnapshot.hasData) {
                              switch (eventsListSnapshot.data!.status) {
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
                                  debugPrint('Dashboard Loaded');
                                  return eventsListBody(mallListSnapshot.data?.data?.malls, eventsListSnapshot.data?.data, context);
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
        ),
      ],
    );
  }

  Widget eventsListBody(List<Mall>? malls, PromotionsListModel? promotions, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                floating: true,
                pinned: false,
                snap: true,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          showDropdown(context: context, malls: malls!, onTap: (selected){
                            setState(() {
                              selectedMall = selected;
                              ApplicationGlobal.selectedMall = selected;
                              promotionsManager.getPromotionsList(start: 0, offset: 0);
                            });
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Select Outlet", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
                            SizedBox(width: 6.sp,),
                            SizedBox(
                              height: 20.sp,
                              width: 20.sp,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: CachedNetworkImage(
                                  imageUrl: selectedMall!.mallIconWhite!, fit: BoxFit.cover,
                                  placeholder: (context, url) => LoadingIndicator(
                                    indicatorType: Indicator.ballScale,
                                    colors: [AppColors.primaryRed, AppColors.secondaryRed],
                                  ),
                                  errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: AppColors.lightBlack, size: 28.sp,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            if(promotions?.news != null && promotions!.news!.isNotEmpty){
              return ListView.builder(
                itemCount: promotions.news?.length??0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PromotionDetails(promotionId: promotions.news![index].id!,),));
                    },
                    child: PromotionCardView(promotion: promotions.news![index], locationIcon: selectedMall!.mallIconWhite!,),
                  );
                },
              );
            } else {
              return Center(child: Text("No promotions found.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),));
            }
          }
        ),
      ),
    );
  }

  Widget dropdownView({required List<Mall> malls, required Function(Mall) onTap}) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.only(top: 55 + 65.sp, left: 10.w, right: 10.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text("Select Outlet", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamBold", fontSize: 18.sp, color: Colors.black),),
                  ),
                  ...malls.map((e) => InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      onTap(e);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Divider(height: 1, thickness: 1, color: Colors.grey, indent: 20, endIndent: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(e.name!, textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamMedium", fontSize: 20.sp, color: AppColors.textBlack),),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showDropdown({required BuildContext context, required List<Mall> malls, required Function(Mall) onTap}) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.topCenter,
          child: dropdownView(malls: malls, onTap: onTap),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}