import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/notifications_manager/notifications_manager.dart';
import 'package:sogo_flutter/src/managers/rewards_manager/rewards_manager.dart';
import 'package:sogo_flutter/src/models/notifications/notifications_model.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/notifications/notifications_tab_view.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';

enum NotificationFilter {
  Archived,
  All,
  Read,
  Unread
}

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> with SingleTickerProviderStateMixin {

  ScrollController scrollController = ScrollController();
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    notificationsManager.getNotifications(read: "");
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
            title: Text("Notification", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
          ),
          body: rewardBody(context),
        ),
      ],
    );
  }

  Widget rewardBody(BuildContext context) {
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
                    Tab(text: "General", height: 30),
                    Tab(text: "Private", height: 30),
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
          child: notificationsBody(),
        ),
      ],
    );
  }

  Widget notificationTabs() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: OfflineBuilder(
          connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
              ) {
            if (connectivity == ConnectivityResult.none) {
              return const Scaffold(
                // ignore: unnecessary_const
                body: Center(child: const NetworkErrorPage()),
              );
            }
            return child;
          },
          child: StreamBuilder<ApiResponse<NotificationsModel>?>(
              stream: notificationsManager.notifications,
              builder: (BuildContext context, AsyncSnapshot<ApiResponse<NotificationsModel>?> snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.LOADING:
                      debugPrint('Loading');
                      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.primaryRed),));
                    case Status.COMPLETED:
                      debugPrint('Completed');
                      return TabBarView(
                        controller: _controller,
                        children: <Widget>[
                          NotificationsPage(inbox: snapshot.data?.data?.globalInbox, notificationType: NotificationType.global,),
                          NotificationsPage(inbox: snapshot.data?.data?.privateInbox, notificationType: NotificationType.private,),
                        ],
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
              })),
    );
  }
  

  List<String> myRewardsConditions = ["Archived", "All", "Read", "Unread"];

  Widget filters() {
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

  Widget notificationsBody() {
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
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 20.w, top: 20.h),
                    child: PopupMenuButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Filter", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
                          SizedBox(width: 6.sp,),
                          Image.asset("assets/images/ic_filter.png", height: 15.sp, width: 15.sp, fit: BoxFit.contain, color: AppColors.lightBlack,),
                        ],
                      ),
                      itemBuilder:(context) => NotificationFilter.values.map((e) => PopupMenuItem(
                        child: Text(e.name),
                        value: e.index,
                      )).toList(),
                      onSelected: (int value){
                        switch(value){
                          case 0: {
                            notificationsManager.getNotifications(read: "", archive: "1");
                            break;
                          }
                          case 1: {
                            notificationsManager.getNotifications(read: "");
                            break;
                          }
                          case 2: {
                            notificationsManager.getNotifications(read: "1");
                            break;
                          }
                          case 3: {
                            notificationsManager.getNotifications(read: "0");
                            break;
                          }
                          default: {
                            notificationsManager.getNotifications(read: "");
                            break;
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: notificationTabs(),
      ),
    );
  }
}