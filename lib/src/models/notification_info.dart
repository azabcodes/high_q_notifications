import 'package:firebase_messaging/firebase_messaging.dart';

import '../../high_q_notifications.dart';

class NotificationInfoModel {
  final AppState appState;

  final RemoteMessage firebaseMessage;

  Map<String, dynamic> get payload => firebaseMessage.data;

  const NotificationInfoModel({
    required this.appState,
    required this.firebaseMessage,
  });
}
