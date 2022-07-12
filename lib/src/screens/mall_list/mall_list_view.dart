import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/constants/global.dart';
import 'package:sogo_flutter/src/managers/dashboard_manager/dashboard_manager.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/screens/mall_list/directory/directory_view.dart';
import 'package:sogo_flutter/src/screens/mall_list/facilities_and_services/facilities_view.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';

enum MallType {
  facility,
  directory
}

class MallListView extends StatefulWidget {
  final String title;
  final MallType type;
  const MallListView({Key? key, required this.title, required this.type}) : super(key: key);

  @override
  State<MallListView> createState() => _MallListViewState();
}

class _MallListViewState extends State<MallListView> {

  List<Mall>? allMallsList;

  @override
  void dispose() {
    super.dispose();
    ApplicationGlobal.selectedMall = allMallsList?.firstWhere((element) => element.defaultMall == true);
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
            title: Text(widget.title, style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                      return facilitiesBody(context, mallListSnapshot.data?.data?.malls);
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

  Widget facilitiesBody(BuildContext context, List<Mall>? malls) {
    allMallsList = malls;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        itemCount: malls?.length??0,
        itemBuilder: (context, index) {
          if(malls?[index].name?.toLowerCase().contains("all") ?? false){
            return const SizedBox();
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(13),
              child: InkWell(
                borderRadius: BorderRadius.circular(13),
                onTap: (){
                  ApplicationGlobal.selectedMall = malls?[index];
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    switch(widget.type){
                      case MallType.facility: {
                        return const FacilitiesAndServicesView();
                      }
                      case MallType.directory: {
                        return DirectoryView(title: malls?[index].name ?? "Directory",);
                      }
                    }
                  },));
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: CachedNetworkImage(
                        imageUrl: malls![index].logo??"", fit: BoxFit.fitWidth,
                        placeholder: (context, url) => LoadingIndicator(
                          indicatorType: Indicator.ballScale,
                          colors: [AppColors.primaryRed, AppColors.secondaryRed],
                        ),
                        width: 100.w,
                        errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", width: 25.sp, fit: BoxFit.fitWidth,),
                      ),
                    ),
                    SizedBox(width: 15.w,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(child: Text(malls[index].name ?? "", style: TextStyle(fontFamily: "GothamBold", fontSize: 15.sp, color: Colors.black),)),
                            SizedBox(height: 10.h,),
                            Flexible(child: Text(malls[index].shortDesc ?? "", style: TextStyle(fontFamily: "GothamRegular", fontSize: 12.sp, color: Colors.black),)),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black, size: 22.sp,)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}