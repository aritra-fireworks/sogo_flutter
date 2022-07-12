import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/manage_password/change_password.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/profile/manage_password/reset_password_popup.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:sogo_flutter/src/utils/app_utils.dart';
import 'package:sogo_flutter/src/widgets/keyboard_dismiss_wrapper.dart';

class ManagePasswordView extends StatefulWidget {
  const ManagePasswordView({Key? key}) : super(key: key);

  @override
  State<ManagePasswordView> createState() => _ManagePasswordViewState();
}

class _ManagePasswordViewState extends State<ManagePasswordView> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext buildContext) {
    return KeyboardDismissWrapper(
      child: OfflineBuilder(
        connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
            ) {
          if (connectivity == ConnectivityResult.none) {
            return const Scaffold(
              body: Center(child: NetworkErrorPage()),
            );
          }
          return child;
        },
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
                title: Text("Manage Password", style: TextStyle(fontFamily: "GothamBold", fontSize: 16.sp, color: Colors.white),),
              ),
              body: managePasswordBody(buildContext),
            ),
          ],
        ),
      ),
    );
  }

  Widget managePasswordBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
      ),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          children: [
            linkTile(title: "Change Password", onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordView(),));
            }),
            linkTile(title: "Reset Password", onTap: (){
              AppUtils.showCustomDialog(context: context, dialogBox: ResetPasswordPopUp(previousContext: context,));
            }),
          ],
        ),
      ),
    );
  }

  Widget linkTile({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60.h,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFFEDEDED), width: 1.sp))),
            child: Text(title, style: TextStyle(fontFamily: "GothamMedium", fontSize: 15.sp, color: AppColors.textBlack),),
          ),
        ],
      ),
    );
  }
}
