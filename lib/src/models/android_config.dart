import 'dart:ui';
import '../../high_q_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AndroidConfigModel {
  AndroidConfigModel({
    StringGetter? channelIdGetter,
    StringGetter? channelNameGetter,
    StringGetter? channelDescriptionGetter,
    StringGetter? appIconGetter,
    AndroidImportanceGetter? importanceGetter,
    AndroidPriorityGetter? priorityGetter,
    NullableStringGetter? imageUrlGetter,
    NullableStringGetter? tagGetter,
    NullableStringGetter? soundGetter,
    NullableColorGetter? colorGetter,
    BoolGetter? autoCancelGetter,
    NullableStringGetter? groupKeyGetter,
    NullableStringGetter? iconGetter,
    NullableStringGetter? smallIconUrlGetter,
    BoolGetter? hideExpandedLargeIconGetter,
    BoolGetter? playSoundGetter,
    BoolGetter? enableLightsGetter,
    BoolGetter? enableVibrationGetter,
    AndroidActionsGetter? actionsGetter,
  }) {
    this.channelIdGetter =
        channelIdGetter ??
        (msg) => msg.notification?.android?.channelId ?? defaultChannelId;
    this.channelNameGetter = channelNameGetter ?? (_) => defaultChannelName;
    this.channelDescriptionGetter =
        channelDescriptionGetter ?? (_) => defaultChannelDescription;
    this.appIconGetter = appIconGetter ?? (_) => defaultAppIcon;
    this.colorGetter = colorGetter ?? (_) => defaultColor;
    this.autoCancelGetter = autoCancelGetter ?? (_) => autoCancel;
    this.groupKeyGetter = groupKeyGetter ?? (_) => defaultGroupKey;
    this.tagGetter =
        tagGetter ?? (msg) => msg.notification?.android?.tag ?? defaultTag;
    this.smallIconUrlGetter =
        smallIconUrlGetter ??
        (msg) => msg.notification?.android?.smallIcon ?? defaultSmallIcon;
    this.importanceGetter = importanceGetter ?? (_) => defaultImportance;
    this.priorityGetter = priorityGetter ?? (_) => defaultPriority;
    this.soundGetter =
        soundGetter ??
        (msg) => msg.notification?.android?.sound ?? defaultSound;
    this.iconGetter = iconGetter ?? (_) => defaultIcon;
    this.imageUrlGetter =
        imageUrlGetter ??
        (msg) => msg.notification?.android?.imageUrl ?? defaultImageUrl;
    this.hideExpandedLargeIconGetter =
        hideExpandedLargeIconGetter ?? (_) => defaultHideExpandedLargeIcon;
    this.playSoundGetter = playSoundGetter ?? (_) => defaultPlaySound;
    this.enableLightsGetter = enableLightsGetter ?? (_) => defaultEnableLights;
    this.enableVibrationGetter =
        enableVibrationGetter ?? (_) => defaultEnableVibration;
    this.actionsGetter = actionsGetter ?? (_) => defaultActions;
  }

  late AndroidActionsGetter? actionsGetter;

  static String defaultChannelId = 'default';

  static String defaultChannelName = 'Default';

  static String defaultChannelDescription =
      'Default channel for all notifications';

  static String defaultAppIcon = '@mipmap/ic_launcher';

  static String? defaultSound;

  static Importance defaultImportance = Importance.defaultImportance;

  /*  static HighQNotificationsImportance defaultImportance =
      HighQNotificationsImportance.max;*/

  static Priority defaultPriority = Priority.defaultPriority;

  /* static HighQNotificationsPriority defaultPriority =
      HighQNotificationsPriority.max;*/

  static String? defaultGroupKey;

  // The icon that should be used when displaying the notification.
  static String? defaultIcon;

  static String? defaultImageUrl;

  static String? defaultSmallIcon;

  static Color? defaultColor;
  static bool autoCancel = true;

  static String? defaultTag;

  static bool defaultHideExpandedLargeIcon = true;

  static bool defaultPlaySound = true;

  static bool defaultEnableVibration = true;
  static List<AndroidNotificationAction> defaultActions = [];

  static bool defaultEnableLights = true;

  late StringGetter channelIdGetter;

  late StringGetter channelNameGetter;

  late StringGetter channelDescriptionGetter;

  late StringGetter appIconGetter;

  late NullableStringGetter soundGetter;

  late AndroidImportanceGetter importanceGetter;

  late AndroidPriorityGetter priorityGetter;

  late NullableStringGetter groupKeyGetter;

  late NullableStringGetter iconGetter;

  late NullableStringGetter imageUrlGetter;

  late NullableStringGetter smallIconUrlGetter;

  late NullableColorGetter colorGetter;
  late BoolGetter autoCancelGetter;

  late NullableStringGetter tagGetter;

  late BoolGetter hideExpandedLargeIconGetter;

  late BoolGetter playSoundGetter;

  late BoolGetter enableVibrationGetter;

  late BoolGetter enableLightsGetter;

  Importance _mapImportance(HighQNotificationsImportance importance) {
    switch (importance) {
      case HighQNotificationsImportance.min:
        return Importance.min;
      case HighQNotificationsImportance.low:
        return Importance.low;
      case HighQNotificationsImportance.defaultImportance:
        return Importance.defaultImportance;
      case HighQNotificationsImportance.high:
        return Importance.high;
      case HighQNotificationsImportance.max:
        return Importance.max;
    }
  }

  Priority _mapPriority(HighQNotificationsPriority priority) {
    switch (priority) {
      case HighQNotificationsPriority.min:
        return Priority.min;
      case HighQNotificationsPriority.low:
        return Priority.low;
      case HighQNotificationsPriority.defaultPriority:
        return Priority.defaultPriority;
      case HighQNotificationsPriority.high:
        return Priority.high;
      case HighQNotificationsPriority.max:
        return Priority.max;
    }
  }

  AndroidNotificationDetails toSpecifics(
    RemoteMessage message, {
    StyleInformation? styleInformation,
    AndroidBitmap<Object>? largeIcon,
  }) {
    final androidSound = soundGetter(message);
    /* final importance = _mapImportance(importanceGetter(message));
    final priority = _mapPriority(priorityGetter(message));*/
    return AndroidNotificationDetails(
      channelIdGetter(message),
      channelNameGetter(message),
      channelDescription: channelDescriptionGetter(message),
      styleInformation: styleInformation,
      importance: importanceGetter(message),
      priority: priorityGetter(message),
      /*priority: priority,
      importance: importance,*/
      color: colorGetter(message),
      largeIcon: largeIcon,
      tag: tagGetter(message),
      groupKey: groupKeyGetter(message),
      sound: androidSound == null
          ? null
          : RawResourceAndroidNotificationSound(androidSound),
      icon: iconGetter(message),
      playSound: playSoundGetter(message),
      enableLights: enableLightsGetter(message),
      enableVibration: enableVibrationGetter(message),
      actions: actionsGetter?.call(message),
      autoCancel: autoCancelGetter(message),
      // TODO: add other params
    );
  }

  AndroidNotificationChannel toNotificationChannel(
    RemoteMessage message, {
    StyleInformation? styleInformation,
    AndroidBitmap<Object>? largeIcon,
  }) {
    final androidSpecifics = toSpecifics(
      message,
      styleInformation: styleInformation,
      largeIcon: largeIcon,
    );

    return AndroidNotificationChannel(
      androidSpecifics.channelId,
      androidSpecifics.channelName,
      description: androidSpecifics.channelDescription,
      importance: androidSpecifics.importance,
      enableLights: androidSpecifics.enableLights,
      enableVibration: androidSpecifics.enableVibration,
      vibrationPattern: androidSpecifics.vibrationPattern,
      ledColor: androidSpecifics.ledColor,
      playSound: androidSpecifics.playSound,
      audioAttributesUsage: androidSpecifics.audioAttributesUsage,
      sound: androidSpecifics.sound,
      groupId: androidSpecifics.groupKey,
      showBadge: androidSpecifics.channelShowBadge,
    );
  }
}
