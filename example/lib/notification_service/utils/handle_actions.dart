import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:high_q_notifications/high_q_notifications.dart';
import 'navigation_service.dart';

class HandleNotificationsActions {
  static void handleAction(
    NotificationResponse response,
    RemoteMessage message,
  ) {
    final context = NavigationService().navigatorKey.currentContext;
    if (context == null) return;

    switch (response.actionId) {
      case 'reply':
        break;
      case 'snooze':
        break;
      default:
        if (kDebugMode) {
          print('Unknown action: ${response.actionId}');
        }
    }
  }
}
