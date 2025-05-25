
import '../../high_q_notifications.dart';

class LocalNotificationsConfigurationModel {
  final AndroidConfigModel? androidConfig;

  final IosConfigModel? iosConfig;

  final NotificationIdGetter? notificationIdGetter;

  const LocalNotificationsConfigurationModel({
    this.androidConfig,
    this.iosConfig,
    this.notificationIdGetter,
  });
}
