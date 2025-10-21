import 'package:firebase_messaging/firebase_messaging.dart';

import '../../high_q_notifications.dart';

class HighQNotificationInfoModel {
  final HighQAppState appState;
  final RemoteMessage firebaseMessage;

  final Map<String, dynamic> rawData;

  Map<String, dynamic> get payload =>
      firebaseMessage.data.isNotEmpty ? firebaseMessage.data : rawData;

  const HighQNotificationInfoModel({
    required this.appState,
    required this.firebaseMessage,
    required this.rawData,
  });
}
