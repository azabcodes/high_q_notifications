import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

import 'firebase_options.dart';
import 'notification_service/exports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    if (kDebugMode) {
      print(error);
    }
  }
  runApp(
    HighQNotifications(
      requestPermissionsOnInitialize: true,
      localNotificationsConfiguration: LocalNotificationsConfigurationModel(
        androidConfig: androidConfig,
        iosConfig: iosConfig,
      ),
      shouldHandleNotification: (_) => true,
      onOpenNotificationArrive: (_) {},
      onTap: HandleNotificationsNavigation.handleNotificationTap,
      onAction: HandleNotificationsActions.handleAction,
      onFcmTokenInitialize: (token) {
        NavigationService().fcmTokenNotifier.value = token;
      },
      onFcmTokenUpdate: (token) {
        NavigationService().fcmTokenNotifier.value = token;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService().navigatorKey,
        scaffoldMessengerKey: NavigationService().scaffoldMessengerState,
        home: Scaffold(appBar: AppBar(title: Text('High Q Notifications'))),
      ),
    ),
  );
}
