import 'package:firebase_messaging/firebase_messaging.dart';
import '../../high_q_notifications.dart';

class NotificationActionInfoModel {
  final AppState appState;
  final RemoteMessage firebaseMessage;
  final NotificationResponse response;

  Map<String, dynamic> get payload => firebaseMessage.data;

  String get actionId => response.actionId ?? 'default';

  const NotificationActionInfoModel({
    required this.appState,
    required this.firebaseMessage,
    required this.response,
  });
}
