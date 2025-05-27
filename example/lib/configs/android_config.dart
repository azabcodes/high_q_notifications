import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

final AndroidConfigModel androidConfig = AndroidConfigModel(
  channelIdGetter: (RemoteMessage remoteMessage) {
    return '_appId';
  },
  channelNameGetter: (RemoteMessage remoteMessage) {
    return 'App  Notification';
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
    return HighQNotificationsImportance.max;
  },
  priorityGetter: (RemoteMessage remoteMessage) {
    return HighQNotificationsPriority.max;
  },

  imageUrlGetter: (RemoteMessage remoteMessage) {
    if (remoteMessage.data.containsKey('image') &&
        remoteMessage.data['image'] != null) {
      return remoteMessage.data['image'];
    }
    return null;
  },
);