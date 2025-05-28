import 'dart:convert';
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
    return Importance.max;
  },
  priorityGetter: (RemoteMessage remoteMessage) {
    return Priority.max;
  },
  imageUrlGetter: (RemoteMessage remoteMessage) {
    if (remoteMessage.data.containsKey('image') &&
        remoteMessage.data['image'] != null) {
      return remoteMessage.data['image'];
    }
    return null;
  },
);
