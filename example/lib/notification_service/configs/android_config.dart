import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

final HighQAndroidConfigModel androidConfig = HighQAndroidConfigModel(
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
);

