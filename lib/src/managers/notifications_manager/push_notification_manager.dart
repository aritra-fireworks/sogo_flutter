import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sogo_flutter/src/managers/auth_manager/auth_manager.dart';
import 'package:sogo_flutter/src/screens/navigation_bar_view/notifications/notifications_view.dart';


FlutterLocalNotificationsPlugin notificationsPlugin =
FlutterLocalNotificationsPlugin();

void showNotification({required String? title, required String? body}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('general', 'General notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showWhen: false,
      category: "General",
      icon: '@mipmap/launcher_icon',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await notificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  showNotification(title: message.notification?.title, body: message.notification?.body);
}

class NotificationManager {

  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  late BuildContext context;

  void init(BuildContext context) async {
    this.context = context;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    String? token = await messaging.getToken();
    debugPrint("Push Token: $token");

    if(token != null) {
      authManager.addDeviceToken(token: token);
    }
    String transId = "";
    RemoteMessage? initialMessage =
    await messaging.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    debugPrint('Initial message: ${initialMessage?.data.toString()}');
    if(initialMessage?.data != null){

    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(title: message.notification?.title, body: message.notification?.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Opened message stream: ${message.data.toString()}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsView(),));
      // showNotification(title: message.notification?.title, body: message.notification?.body);
    });
  }


}

final NotificationManager notificationManager = NotificationManager();