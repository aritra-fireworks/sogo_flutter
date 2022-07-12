import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/screens/customer_support/about_us_view.dart';
import 'package:sogo_flutter/src/screens/customer_support/contact_us_view.dart';
import 'package:sogo_flutter/src/screens/customer_support/help_center_view.dart';
import 'package:sogo_flutter/src/screens/customer_support/web_view_links.dart';
import 'package:sogo_flutter/src/services/base_url/url_controller.dart';


class CustomerSupportView extends StatefulWidget {
  const CustomerSupportView({Key? key}) : super(key: key);

  @override
  State<CustomerSupportView> createState() => _CustomerSupportViewState();
}

class _CustomerSupportViewState extends State<CustomerSupportView> {

  @override
  Widget build(BuildContext buildContext) {
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
                Navigator.pop(buildContext);
              },
            ),
            centerTitle: true,
            title: Text("Customer Support", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
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
              customerSupportBody(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget customerSupportBody(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.asset("assets/images/ic_customer_support.png", fit: BoxFit.fitWidth),
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
                  link(title: "About Us", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutUsView(),));
                  }),
                  link(title: "Contact Us", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactUsView(),));
                  }),
                  link(title: "Help", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpCenterView(),));
                  }),
                  link(title: "FAQs", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinks(webViewUrl: "${UrlController.kUserBaseURL}/membership/faqs.php?app_view=1", title: "FAQs"),));
                  }),
                  link(title: "Privacy Policy", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinks(webViewUrl: "${UrlController.kUserBaseURL}/membership/privacy_policy.php?app_view=1", title: "Privacy Policy"),));
                  }),
                  link(title: "Terms & Conditions", onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewLinks(webViewUrl: "${UrlController.kUserBaseURL}/membership/tnc.php?app_view=1", title: "Terms & Conditions"),));
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget link({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
                Icon(Icons.arrow_forward_ios, color: AppColors.lightBlack, size: 24.sp,),
              ],
            ),
          ),
          Divider(height: 1.sp, thickness: 1.sp, color: AppColors.grey.withOpacity(0.2),),
        ],
      ),
    );
  }

}
