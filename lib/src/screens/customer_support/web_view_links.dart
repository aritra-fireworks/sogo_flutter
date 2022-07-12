import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sogo_flutter/src/constants/app_colors.dart';
import 'package:sogo_flutter/src/screens/network_error_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLinks extends StatefulWidget {
  final String title;
  final String webViewUrl;
  const WebViewLinks({Key? key, required this.webViewUrl, required this.title}) : super(key: key);

  @override
  State<WebViewLinks> createState() => _WebViewLinksState();
}

class _WebViewLinksState extends State<WebViewLinks> {

  bool isLoading = true;

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
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                ),
              ),
              ModalProgressHUD(
                progressIndicator: CircularProgressIndicator(color: AppColors.primaryRed,),
                inAsyncCall: isLoading,
                child: Scaffold(
                    backgroundColor: Colors.transparent,
                    resizeToAvoidBottomInset: false,
                    body: WillPopScope(
                        onWillPop: () async => true,
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
                          child: rewardMoreDetailsBody(context),
                        ))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rewardMoreDetailsBody(BuildContext context) {
    return Builder(
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
        child: WebView(
          backgroundColor: Colors.transparent,
          initialUrl: widget.webViewUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (value){
            setState(() {
              isLoading = false;
            });
          },
        ),
      ),
    );
  }
}
