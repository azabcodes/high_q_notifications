import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

class HandleNotificationsActions {
  static void handleAction(
    NotificationResponse response,
    RemoteMessage message,
  ) {
    final actionInfo = NotificationActionInfoModel(
      appState: _getAppState(response),
      firebaseMessage: message,
      response: response,
    );

    switch (response.actionId) {
      case 'add_text':
        if (kDebugMode) {
          print('actionInfo response');
          print(actionInfo.response.data);
          print('actionInfo firebaseMessage');
          print(actionInfo.firebaseMessage.data);
          print('add_text action');
          print(response.actionId);
        }
        break;
      default:
        if (kDebugMode) {
          print('default action');
          print(response.actionId);
        }
    }
  }

  static AppState _getAppState(NotificationResponse response) {
    if (response.notificationResponseType ==
        NotificationResponseType.selectedNotificationAction) {
      // For background actions, we need to determine if the app was in background or terminated
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark
          ? AppState.background
          : AppState.terminated;
    }
    return AppState.open;
  }
}
