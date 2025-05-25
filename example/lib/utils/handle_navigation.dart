import 'package:flutter/foundation.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

import 'notifications_type.dart';

class HandleNotificationsNavigation {
  static void handleNotificationTap(NotificationInfoModel info) {
    final payload = info.payload;
    final appState = info.appState;
    final firebaseMessage = info.firebaseMessage.toMap();

    if (payload['type'] != null) {
      try {
        final notificationType = NotificationsTypes.values.firstWhere(
          (e) => e.toString().split('.').last == payload['type'],
        );

        if (kDebugMode) {
          print('Notification Type: $notificationType');
        }

        switch (notificationType) {
          case NotificationsTypes.notificationScreen:
          /* SLServices.navigationLocator.toPage(
              page: ScreenName(
                id: int.tryParse(payload['id'])!,
              ),
            );*/
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing notification type: $e');
        }
      }
    }

    for (var key in ['url', 'sound', 'image']) {
      if (payload[key] != null) {
        if (kDebugMode) {
          print('${key.toUpperCase()}: ${payload[key]}');
        }
      }
    }
    if (kDebugMode) {
      print(
        'Notification tapped with $appState & payload $payload. Firebase message: $firebaseMessage',
      );
    }
  }
}
