import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/dashboard_manager/dashboard_manager.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';

class AboutUsView extends StatefulWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {

  List<Mall> allMallsList = [];

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
            title: Text("About Us", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                      return aboutUsBody(context, mallListSnapshot.data?.data?.malls);
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

  Widget aboutUsBody(BuildContext context, List<Mall>? malls) {
    allMallsList = malls ?? [];
    allMallsList.removeWhere((element) => element.name?.toLowerCase().contains("all") ?? false);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: ExpansionPanelList.radio(
          elevation: 0,
          initialOpenPanelValue: allMallsList.first.id,
          children: allMallsList.map((e) {
            return ExpansionPanelRadio(
            value: e.id ?? "",
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) => Align(alignment: Alignment.centerLeft, child: Text(e.name??"", style: TextStyle(fontFamily: "GothamBold", fontSize: 15.sp, color: Colors.black),)),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: CachedNetworkImage(
                    imageUrl: e.logo ?? "", fit: BoxFit.cover,
                    placeholder: (context, url) => LoadingIndicator(
                      indicatorType: Indicator.ballScale,
                      colors: [AppColors.primaryRed, AppColors.secondaryRed],
                    ),
                    errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", fit: BoxFit.cover,),
                  ),
                ),
                SizedBox(height: 20.h,),
                HtmlWidget(e.about ?? "", textStyle: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: Colors.black),),
              ],
            ),
          );
          }).toList(),
        ),
      ),
    );
  }
}