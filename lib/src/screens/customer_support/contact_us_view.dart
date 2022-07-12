import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/managers/dashboard_manager/dashboard_manager.dart';
import 'package:sogo_flutter/src/models/malls_and_merchants/mall_list_model.dart';
import 'package:sogo_flutter/src/services/web_service_components/api_response.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {

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
            title: Text("Contact Us", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
          children: allMallsList.map((mall) {
            return ExpansionPanelRadio(
              value: mall.id ?? "",
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) => Align(alignment: Alignment.centerLeft, child: Text(mall.name??"", style: TextStyle(fontFamily: "GothamBold", fontSize: 15.sp, color: Colors.black),)),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(mall.contactUs ?? "", textStyle: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: Colors.black),),
                  SizedBox(height: 20.h,),
                  openWithApps(mall: mall),
                  links(icon: "ic_phone", title: "Toll Free Number - ${mall.phone}", onTap: (){
                    _makePhoneCall(mall.phone??"");
                  }),
                  links(icon: "ic_mail", title: "Email - ${mall.email}", onTap: (){
                    _sendEmail(mall.email??"");
                  }),
                  links(icon: "ic_feedback", title: "Send feedback", onTap: (){

                  }),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget openWithApps({required Mall mall}) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: (){
                _launchUrl("${mall.whatsapp}");
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset("assets/images/ic_whatsapp.png", height: 35.sp, width: 35.sp, fit: BoxFit.contain,),
                  ),
                  SizedBox(width: 15.w,),
                  Text("WhatsApp", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: (){
                _launchUrl("${mall.waze}");
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset("assets/images/ic_waze.png", height: 35.sp, width: 35.sp, fit: BoxFit.contain,),
              ),
            ),
            SizedBox(width: 10.w),
            InkWell(
              onTap: (){
                _launchUrl("${mall.googleMaps}");
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset("assets/images/ic_gmap.png", height: 35.sp, width: 35.sp, fit: BoxFit.contain,),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h,),
        Divider(height: 1.sp, thickness: 1.sp, color: AppColors.grey.withOpacity(0.2),),
      ],
    );
  }

  Widget links({required String icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Row(
              children: [
                Image.asset("assets/images/$icon.png", width: 36.sp, height: 36.sp, fit: BoxFit.contain,),
                SizedBox(width: 15.w,),
                Text(title, style: TextStyle(fontFamily: "GothamRegular", fontSize: 14.sp, color: AppColors.lightBlack),),
              ],
            ),
          ),
          Divider(height: 1.sp, thickness: 1.sp, color: AppColors.grey.withOpacity(0.2),),
        ],
      ),
    );
  }

  void _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      AppUtils.showMessage(context: context, title: "Error!", message: "Could not launch $_url");
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
          scheme: 'mailto',
          path: email,
          query: encodeQueryParameters(<String, String>{
            'subject': 'Enquiry'
          },
        ),
    );
    await launchUrl(launchUri);
  }


}