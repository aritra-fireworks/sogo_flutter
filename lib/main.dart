import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sogo_flutter/src/managers/notifications_manager/push_notification_manager.dart';
import 'package:sogo_flutter/src/screens/onboarding/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging?.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 829),
      builder: (child) => MaterialApp(
        title: 'SOGO',
        debugShowCheckedModeBanner: false,
        scrollBehavior: const ScrollBehavior(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
        ),
        theme: ThemeData(
          primarySwatch: Colors.red,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: child,
      ),
      child: const LoadingScreen(),
    );
  }
}
