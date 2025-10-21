import 'package:firebase_messaging/firebase_messaging.dart';

import '../../high_q_notifications.dart';

class NotificationInfoModel {
  final AppState appState;
  final RemoteMessage firebaseMessage;
  final Map<String, dynamic> payload;

  const NotificationInfoModel({
    required this.appState,
    required this.firebaseMessage,
    this.payload = const {},
  });
}

