import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/dashboard_manager/dashboard_manager.dart';
import 'package:sogo_flutter/src/managers/rewards_manager/rewards_manager.dart';
import 'package:sogo_flutter/src/managers/ui_manager/nav_bar_manager.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/models/rewards/my_rewards_list_model.dart';
import 'package:sogo_flutter/src/models/rewards/reward_category_list_model.dart';
import 'package:sogo_flutter/src/models/rewards/rewards_list_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/my_muti_wallet_rewards.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/my_reward_details.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/rewards/reward_details.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/my_reward_card_view.dart';
import 'package:sogo_flutter/src/widgets/reward_card_view.dart';

class RewardsView extends StatefulWidget {
  const RewardsView({Key? key}) : super(key: key);

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> with SingleTickerProviderStateMixin {

  Mall? selectedMall;
  ScrollController scrollController = ScrollController();
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    rewardsManager.getRewardsList(start: 0, offset: 0).then((value) => rewardsManager.getRewardsCategory());
    rewardsManager.getMyRewardsList(start: 0, offset: 0);
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
            title: Text("Rewards", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                      return rewardBody(mallListSnapshot.data?.data?.malls, context);
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

  Widget rewardBody(List<Mall>? malls, BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: const EdgeInsets.all(2),
          child: StreamBuilder<int?>(
              stream: rewardsManager.rewardsIndexStream,
              builder: (context, snapshot) {
                if(snapshot.hasData && snapshot.data != null){
                  _controller.animateTo(snapshot.data!);
                  rewardsManager.reset();
                }
              return TabBar(
                controller: _controller,
                tabs: const [
                  Tab(text: "Rewards", height: 30),
                  Tab(text: "My Rewards", height: 30),
                ],
                isScrollable: false,
                indicator: BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.secondaryRed.withAlpha(220), AppColors.secondaryRed.withAlpha(250)]),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                labelStyle: TextStyle(fontSize: 15.sp, fontFamily: "GothamBold", height: 1.4),
                unselectedLabelStyle: TextStyle(fontSize: 15.sp, fontFamily: "GothamMedium", height: 1.4),
                labelColor: Colors.white,
                labelPadding: EdgeInsets.zero,
                unselectedLabelColor: AppColors.lightBlack,
                indicatorSize: TabBarIndicatorSize.tab,
              );
            }
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              StreamBuilder<ApiResponse<RewardsListModel>?>(
                  stream: rewardsManager.rewardsList,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<RewardsListModel>?> rewardsListSnapshot) {
                    if (rewardsListSnapshot.hasData) {
                      switch (rewardsListSnapshot.data!.status) {
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
                          return rewardsList(rewardsListSnapshot.data?.data, malls);
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
              StreamBuilder<ApiResponse<MyRewardsListModel>?>(
                  stream: rewardsManager.myRewardsList,
                  builder: (BuildContext context, AsyncSnapshot<ApiResponse<MyRewardsListModel>?> rewardsListSnapshot) {
                    if (rewardsListSnapshot.hasData) {
                      switch (rewardsListSnapshot.data!.status) {
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
                          return myRewardsList(rewardsListSnapshot.data?.data, malls);
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
    );
  }

  Widget rewardsList(RewardsListModel? rewards, List<Mall>? malls) {
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
                leadingWidth: 0,
                titleSpacing: 0,
                title: Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 20.h),
                  child: InkWell(
                    onTap: (){
                      AppUtils.openBottomSheet(context: context, child: categoryList(),);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Filter", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
                        SizedBox(width: 6.sp,),
                        Image.asset("assets/images/ic_filter.png", height: 15.sp, width: 15.sp, fit: BoxFit.contain, color: AppColors.lightBlack,),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 20.w, top: 20.h),
                    child: InkWell(
                      onTap: (){
                        showDropdown(context: context, malls: malls!, onTap: (selected){
                          setState(() {
                            selectedMall = selected;
                            ApplicationGlobal.selectedMall = selected;
                            rewardsManager.getRewardsList(start: 0, offset: 0);
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
                ],
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            if(rewards?.rewards != null && rewards!.rewards!.isNotEmpty){
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                itemCount: rewards.rewards?.length??0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RewardDetails(rewardId: rewards.rewards![index].id!,),));
                    },
                    child: RewardCardView(reward: rewards.rewards![index], malls: malls ?? [],),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(height: 40.h, thickness: 1.sp, color: Colors.grey);
                },
              );
            } else {
              return Center(child: Text("No rewards found.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),));
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
          margin: EdgeInsets.only(top: 55 + 130.sp, left: 10.w, right: 10.w),
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

  Widget categoryList() {
    return StreamBuilder<ApiResponse<RewardCategoryListModel>?>(
        stream: rewardsManager.rewardsCategoryList,
        builder: (BuildContext context, AsyncSnapshot<ApiResponse<RewardCategoryListModel>?> snapshot) {
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
                debugPrint('Rewards Category Loaded');
                List<Category>? category = snapshot.data?.data?.category;
                if(category != null){
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    itemCount: category.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        rewardsManager.getRewardsList(start: 0, offset: 0, categoryId: category[index].categoryId);
                      },
                      child: Text(category[index].category??"", textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamRegular", fontSize: 19.sp, color: AppColors.lightBlack),),
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 30.h, thickness: 1.sp, color: Colors.grey.withOpacity(0.4));
                    },
                  );
                } else {
                  return const SizedBox();
                }
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

  List<String> myRewardsConditions = ["Purchased", "Used", "Expired"];

  Widget myRewardFilters() {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      itemCount: myRewardsConditions.length,
      itemBuilder: (context, index) => InkWell(
        onTap: (){
          Navigator.pop(context);
          rewardsManager.getMyRewardsList(start: 0, offset: 0, condition: myRewardsConditions[index]);
        },
        child: Text(myRewardsConditions[index], textAlign: TextAlign.center, style: TextStyle(fontFamily: "GothamRegular", fontSize: 19.sp, color: AppColors.lightBlack),),
      ),
      separatorBuilder: (BuildContext context, int index) {
        return Divider(height: 30.h, thickness: 1.sp, color: Colors.grey.withOpacity(0.4));
      },
    );
  }

  Widget myRewardsList(MyRewardsListModel? rewards, List<Mall>? malls) {
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
                leadingWidth: 0,
                titleSpacing: 0,
                title: Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 20.h),
                  child: InkWell(
                    onTap: (){
                      AppUtils.openBottomSheet(context: context, child: myRewardFilters(),);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Filter", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
                        SizedBox(width: 6.sp,),
                        Image.asset("assets/images/ic_filter.png", height: 15.sp, width: 15.sp, fit: BoxFit.contain, color: AppColors.lightBlack,),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 20.w, top: 20.h),
                    child: InkWell(
                      onTap: (){
                        showDropdown(context: context, malls: malls!, onTap: (selected){
                          setState(() {
                            selectedMall = selected;
                            ApplicationGlobal.selectedMall = selected;
                            rewardsManager.getMyRewardsList(start: 0, offset: 0);
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
                ],
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            if(rewards?.wallet != null && rewards!.wallet!.isNotEmpty){
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                itemCount: rewards.wallet?.length??0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      if(rewards.wallet![index].units == "1"){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyRewardDetails(rewardId: rewards.wallet![index].id!, rewardType: rewards.wallet![index].type!,),));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyMultiWalletView(id: rewards.wallet![index].cid!, type: rewards.wallet![index].type!, condition: "", malls: malls ?? [],),));
                      }
                    },
                    child: MyRewardCardView(wallet: rewards.wallet![index], malls: malls ?? [],),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(height: 40.h, thickness: 1.sp, color: Colors.grey);
                },
              );
            } else {
              return Center(child: Text("You don't have any rewards yet.", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),));
            }

          }
        ),
      ),
    );
  }
}