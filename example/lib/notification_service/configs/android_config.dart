import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

final AndroidConfigModel androidConfig = AndroidConfigModel(
  channelIdGetter: (RemoteMessage remoteMessage) {
    return 'my_channel_id';
  },
  channelNameGetter: (RemoteMessage remoteMessage) {
    return 'Test App Notification';
  },
  autoCancelGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  actionsGetter: (RemoteMessage message) {
    final data = message.data['action_buttons'];
    if (data == null) return [];

    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded.map<AndroidNotificationAction>((item) {
      final id = item['action'] ?? 'default_action';
      final title = item['title'] ?? 'Action';

      return AndroidNotificationAction(
        id,
        title,
        showsUserInterface: true,
        inputs: [
          if (id == 'reply_action')
            const AndroidNotificationActionInput(label: 'Type your reply'),
        ],
      );
    }).toList();
  },
  colorGetter: (RemoteMessage remoteMessage) {
    return Colors.red;
  },
  channelDescriptionGetter: (RemoteMessage remoteMessage) {
    return 'This channel to allow us to send you the notifications';
  },
  appIconGetter: (RemoteMessage remoteMessage) {
    return '@drawable/notification_icon';
  },
  soundGetter: (RemoteMessage remoteMessage) {
    return 'notification_sound';
  },
  importanceGetter: (RemoteMessage remoteMessage) {
    return Importance.low;
  },
  priorityGetter: (RemoteMessage remoteMessage) {
    return Priority.low;
  },
  fullScreenIntentGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  silentGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  imageUrlGetter: (RemoteMessage remoteMessage) {
    if (remoteMessage.data.containsKey('image') && remoteMessage.data['image'] != null) {
      return remoteMessage.data['image'];
    }
    if (remoteMessage.data.containsKey('imageUrl') && remoteMessage.data['imageUrl'] != null) {
      return remoteMessage.data['imageUrl'];
    }
    return null;
  },
  additionalFlagsGetter: (RemoteMessage remoteMessage) {
    return [
      /* AndroidNotificationFlag.autoCancel,
      AndroidNotificationFlag.showLights, */
    ];
  },
  channelBypassDndGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  setAsGroupSummaryGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  groupAlertBehaviorGetter: (RemoteMessage remoteMessage) {
    return GroupAlertBehavior.all;
  },
  ongoingGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  onlyAlertOnceGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  showWhenGetter: (RemoteMessage remoteMessage) {
    return true;
  },
  whenGetter: (RemoteMessage remoteMessage) {
    return null;
  },
  usesChronometerGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  chronometerCountDownGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  showProgressGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  maxProgressGetter: (RemoteMessage remoteMessage) {
    return 100;
  },
  progressGetter: (RemoteMessage remoteMessage) {
    return 0;
  },
  indeterminateGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  ledColorGetter: (RemoteMessage remoteMessage) {
    return Colors.blue;
  },
  ledOnMsGetter: (RemoteMessage remoteMessage) {
    return 1000;
  },
  ledOffMsGetter: (RemoteMessage remoteMessage) {
    return 1000;
  },
  tickerGetter: (RemoteMessage remoteMessage) {
    return 'New notification';
  },
  channelActionGetter: (RemoteMessage remoteMessage) {
    return AndroidNotificationChannelAction.createIfNotExists;
  },
  visibilityGetter: (RemoteMessage remoteMessage) {
    return NotificationVisibility.public;
  },
  timeoutAfterGetter: (RemoteMessage remoteMessage) {
    return null;
  },
  categoryGetter: (RemoteMessage remoteMessage) {
    return AndroidNotificationCategory.message;
  },
  shortcutIdGetter: (RemoteMessage remoteMessage) {
    return null;
  },
  subTextGetter: (RemoteMessage remoteMessage) {
    return null;
  },
  colorizedGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  numberGetter: (RemoteMessage remoteMessage) {
    return null;
  },
  audioAttributesUsageGetter: (RemoteMessage remoteMessage) {
    return AudioAttributesUsage.notification;
  },
  vibrationPatternGetter: (RemoteMessage remoteMessage) {
    return Int64List.fromList([0, 500, 1000, 500]);
  },
  channelShowBadgeGetter: (RemoteMessage remoteMessage) {
    return true;
  },
  iconGetter: (RemoteMessage remoteMessage) {
    return '@drawable/notification_icon';
  },
  /* smallIconUrlGetter: (RemoteMessage remoteMessage) {
    return '@drawable/notification_icon';
  },*/
  tagGetter: (RemoteMessage remoteMessage) {
    return 'notification_tag';
  },
  hideExpandedLargeIconGetter: (RemoteMessage remoteMessage) {
    return false;
  },
  playSoundGetter: (RemoteMessage remoteMessage) {
    return true;
  },
  enableLightsGetter: (RemoteMessage remoteMessage) {
    return true;
  },
  enableVibrationGetter: (RemoteMessage remoteMessage) {
    return true;
  },
  groupKeyGetter: (RemoteMessage remoteMessage) {
    return null;
  },
);
