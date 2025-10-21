import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

final IosConfigModel iosConfig = IosConfigModel(
  presentSoundGetter: (RemoteMessage remoteMessage) {
    return true;
  },
  soundGetter: (RemoteMessage remoteMessage) {
    return 'notification_sound.caf';
  },
  categoryGetter: (RemoteMessage message) {
    final data = message.data['categories'];
    if (data == null) return IosConfigModel.defaultCategories;

    final decoded = jsonDecode(data) as List<dynamic>;

    return decoded.map<DarwinNotificationCategory>((item) {
      final id = item['id'] ?? 'default_category_id';

      final List<DarwinNotificationAction> actions = [];

      if (item['actions'] != null) {
        final decodedActions = item['actions'] as List<dynamic>;
        for (var actionItem in decodedActions) {
          actions.add(
            DarwinNotificationAction.text(
              actionItem['id'] ?? 'reply_action',
              actionItem['title'] ?? 'Reply',
              buttonTitle: 'Send',
              placeholder: 'Type your reply here',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          );
        }
      }

      return DarwinNotificationCategory(
        id,
        actions: actions,
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.customDismissAction,
        },
      );
    }).toList();
  },
);

