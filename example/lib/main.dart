import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

import 'init/init_android.dart';
import 'init/init_ios.dart';

void main() {
  runApp(
    HighQNotifications(
      requestPermissionsOnInitialize: true,
      localNotificationsConfiguration: LocalNotificationsConfigurationModel(
        androidConfig: androidConfig,
        iosConfig: iosConfig,
      ),
      shouldHandleNotification: (RemoteMessage msg) {
        return true;
      },
      onOpenNotificationArrive: (NotificationInfoModel info) {},
      onTap: (details) {},
      onFcmTokenInitialize: (String? token) {},
      onFcmTokenUpdate: (String token) {},
      child: Scaffold(),
    ),
  );
}
