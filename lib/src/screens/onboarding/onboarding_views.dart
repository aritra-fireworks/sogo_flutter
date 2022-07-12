import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/screens/auth/auth_screen.dart';


class OnboardingViews extends StatefulWidget {
  const OnboardingViews({Key? key}) : super(key: key);

  @override
  State<OnboardingViews> createState() => _OnboardingViewsState();
}

class _OnboardingViewsState extends State<OnboardingViews> {

  List<List<String>> imagePaths = [
    ["assets/images/onboarding_1.png", "Rewards", "Amazing deal and rewards waiting for you to redeem."],
    ["assets/images/onboarding_2.png", "Welcome to \nSogo Loyalty App", "To our Loyalty app discover our amazing benefit & rewards."],
    ["assets/images/onboarding_3.png", "News & Events", "See what’s going on and get the latest news & events!"],
    ["assets/images/onboarding_4.png", "Rewards", "Amazing deal and rewards waiting for you to redeem."],
  ];

  final PageController _controller = PageController();

  double page = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        page = _controller.page??0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: GestureDetector(
        onTap: (){
          if(page != imagePaths.length) {
            _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        },
        child: PageView.builder(
          controller: _controller,
          itemCount: imagePaths.length + 1,
          itemBuilder: (context, index) {
            if(index == imagePaths.length) {
              return const AuthScreen();
            }
            return PageItem(pageContent: imagePaths[index],);
          },
        ),
      ),
    );
  }
}


class PageItem extends StatelessWidget {
  final List<String> pageContent;
  const PageItem({Key? key, required this.pageContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(pageContent[0]), fit: BoxFit.cover),
        color: Colors.white,
      ),
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 100.h),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Text(pageContent[1], style: const TextStyle(fontFamily: "GothamBold", color: AppColors.textBlack, fontSize: 22),),
      //     SizedBox(height: 15.sp,),
      //     Text(pageContent[2], style: const TextStyle(fontFamily: "MyriadRegular", color: AppColors.textGrey, fontSize: 16),),
      //   ],
      // ),
    );
  }
}

