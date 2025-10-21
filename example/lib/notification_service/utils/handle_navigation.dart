import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:high_q_notifications/high_q_notifications.dart';
import 'notifications_type.dart';

class HandleNotificationsNavigation {
  static void handleNotificationTap(NotificationInfoModel info) {
    dynamic payload = info.payload;

    if (payload is String && payload.isNotEmpty) {
      try {
        payload = jsonDecode(payload);
      } catch (e) {
        if (kDebugMode) {
          print('Error decoding payload JSON: $e');
        }
        payload = {};
      }
    }

    if (payload is Map) {
      payload = payload.map((key, value) => MapEntry(key.toString(), value));
    } else {
      if (kDebugMode) {
        print('Invalid payload format');
      }
      payload = {};
    }

    final appState = info.appState;
    final firebaseMessage = info.firebaseMessage.toMap();

    if (kDebugMode) {
      print('Received payload: $payload');
    }

    final type = payload['type']?.toString();
    if (type == null || type.isEmpty) {
      if (kDebugMode) {
        print('No type found in payload');
      }
      return;
    }

    try {
      final notificationType = NotificationsTypes.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toLowerCase() ==
            type.toString().toLowerCase(),
        orElse: () => NotificationsTypes.notificationScreen,
      );

      if (kDebugMode) {
        print('Notification Type: \$notificationType');
      }

      switch (notificationType) {
        case NotificationsTypes.notificationScreen:
          final id = payload['id'];
          if (id != null) {
            //Navigation
          } else {
            if (kDebugMode) {
              print('Missing borrowerId or addedByUid');
            }
          }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing notification type: $e');
      }
    }

    if (kDebugMode) {
      print(
      'Notification tapped with $appState & payload $payload. Firebase message: $firebaseMessage',
    );
    }
  }
}
