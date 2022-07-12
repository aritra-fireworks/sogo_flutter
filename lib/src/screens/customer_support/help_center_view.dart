import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/screens/customer_support/feedback_form.dart';

class HelpCenterView extends StatefulWidget {
  const HelpCenterView({Key? key}) : super(key: key);

  @override
  State<HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<HelpCenterView> {

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
            title: Text("Help Center", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
          ),
          body: helpCenterBody(context),
        ),
      ],
    );
  }

  Widget helpCenterBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reach out us", style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.lightBlack),),
            SizedBox(height: 15.h,),
            Text("Your feedback, general or side issues are welcome for us to give you a better experiences.", style: TextStyle(fontFamily: "GothamRegular", fontSize: 15.sp, color: AppColors.lightBlack),),
            SizedBox(height: 25.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                link(icon: "ic_app", title: "App", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackFormView(type: IssueType(0, "App Crash")),));
                }),
                link(icon: "ic_membership", title: "Membership", onTap: (){}),
                link(icon: "ic_others", title: "Others", onTap: (){}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget link({required String icon, required String title, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                child: Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Image.asset("assets/images/$icon.png"),
                ),
              ),
            ),
            Text(title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 13.sp, color: AppColors.textGrey),),
          ],
        ),
      ),
    );
  }
}