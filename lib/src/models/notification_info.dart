import 'package:firebase_messaging/firebase_messaging.dart';

import '../../high_q_notifications.dart';

class NotificationInfoModel {
  final AppState appState;
  final RemoteMessage firebaseMessage;

  final Map<String, dynamic> rawData;

  Map<String, dynamic> get payload =>
      firebaseMessage.data.isNotEmpty ? firebaseMessage.data : rawData;

  const NotificationInfoModel({
    required this.appState,
    required this.firebaseMessage,
    required this.rawData,
  });
}
