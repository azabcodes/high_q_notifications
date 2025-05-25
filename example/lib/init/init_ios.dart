import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

final IosConfigModel iosConfig = IosConfigModel(
  presentSoundGetter: (RemoteMessage remoteMessage) {
    return true;
  },
  soundGetter: (RemoteMessage remoteMessage) {
    return 'elevator.caf';
  },
);
