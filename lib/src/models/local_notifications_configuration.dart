
import '../../high_q_notifications.dart';

class HighQConfigurationModel {
  final HighQAndroidConfigModel? androidConfig;

  final HighQIosConfigModel? iosConfig;

  final NotificationIdGetter? notificationIdGetter;

  const HighQConfigurationModel({
    this.androidConfig,
    this.iosConfig,
    this.notificationIdGetter,
  });
}
