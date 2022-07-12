import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/directory_manager/directory_manager.dart';
import 'package:sogo_flutter/src/models/directory/directory_details_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';

class DirectoryDetails extends StatefulWidget {
  final String directoryId;
  const DirectoryDetails({Key? key, required this.directoryId}) : super(key: key);

  @override
  State<DirectoryDetails> createState() => _DirectoryDetailsState();
}

class _DirectoryDetailsState extends State<DirectoryDetails> {


  @override
  void initState() {
    super.initState();
    directoryManager.getDirectoryDetails(directoryId: widget.directoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/home_banner_top.png'), fit: BoxFit.fill)),
        ),
        StreamBuilder<ApiResponse<DirectoryDetailsModel>?>(
            stream: directoryManager.directoryDetails,
            builder: (BuildContext context, AsyncSnapshot<ApiResponse<DirectoryDetailsModel>?> snapshot) {
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
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        centerTitle: true,
                        title: Text(snapshot.data?.data?.merchantDetails?.title ?? "Directory", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
                          Builder(builder: (context) {
                            if(snapshot.data?.data?.merchantDetails != null){
                              return facilityDetailsBody(context, snapshot.data?.data?.merchantDetails);
                            }
                            return Center(
                              child: Text("No details found", style: TextStyle(fontFamily: "GothamMedium", fontSize: 18.sp, color: Colors.grey),),
                            );
                          },),
                        ],
                      ),
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
            }),
      ],
    );
  }

  Widget facilityDetailsBody(BuildContext context, MerchantDetails? merchantDetails) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: CachedNetworkImage(
                imageUrl: merchantDetails?.featuredImage??"", fit: BoxFit.fitWidth,
                placeholder: (context, url) => LoadingIndicator(
                  indicatorType: Indicator.ballScale,
                  colors: [AppColors.primaryRed, AppColors.secondaryRed],
                ),
                errorWidget: (context, url, error) => Image.asset("assets/images/pic_placeholder.png", height: 200.h, width: double.infinity, fit: BoxFit.cover, alignment: Alignment.center,),
              ),
            ),
            SizedBox(height: 20.h,),
            Text(merchantDetails?.title??"", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: Colors.black),),
            SizedBox(height: 15.h,),
            HtmlWidget(merchantDetails?.description??"", textStyle: TextStyle(fontFamily: "MyriadRegular", color: AppColors.textGrey, fontSize: 15.sp),),
            SizedBox(height: 10.h,),
            Divider(color: AppColors.grey.withOpacity(0.2), height: 20.h, thickness: 1.sp,),
            facilityTile(iconPath: "assets/images/ic_location_red.png", title: "Location", subtitle: merchantDetails?.address??""),
            SizedBox(height: 10.h,),
            facilityTile(iconPath: "assets/images/ic_time_red.png", title: "Opening Hours", subtitle: "${merchantDetails?.openTime ?? '10:00 AM'} - ${merchantDetails?.closeTime ?? '10:00 PM'}"),
            SizedBox(height: 10.h,),
            facilityTile(icon: Icons.phone, title: "Contact Number", subtitle: merchantDetails?.contact??"-"),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }

  Widget facilityTile({String? iconPath, IconData? icon, required String title, required String subtitle}) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: iconPath != null ? Image.asset(iconPath, width: 15.w, fit: BoxFit.fitWidth, color: const Color(0xFF28603E),) : Icon(icon ?? Icons.phone, size: 20.sp, color: const Color(0xFF28603E),),
        ),
        SizedBox(width: 15.w,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h,),
              Flexible(child: Text(title, style: TextStyle(fontFamily: "GothamBook", fontSize: 15.sp, color: AppColors.lightBlack),)),
              SizedBox(height: 10.h,),
              Flexible(child: Text(subtitle, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),)),
              SizedBox(height: 20.h,),
              Divider(color: AppColors.grey.withOpacity(0.2), height: 1.sp, thickness: 1.sp,),
            ],
          ),
        ),
      ],
    );
  }
}
