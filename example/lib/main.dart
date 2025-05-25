import 'package:example/utils/handle_navigation.dart';
import 'package:example/utils/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';
import 'configs/android_config.dart';
import 'configs/ios_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        home: Scaffold(appBar: AppBar(title: Text('Azab Codes'))),
      ),
    ),
  );
}
