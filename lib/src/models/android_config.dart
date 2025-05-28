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
    NullableStringGetter? groupKeyGetter,
    NullableStringGetter? iconGetter,
    NullableStringGetter? smallIconUrlGetter,
    BoolGetter? hideExpandedLargeIconGetter,
    BoolGetter? playSoundGetter,
    BoolGetter? enableLightsGetter,
    BoolGetter? enableVibrationGetter,
  }) {
    this.channelIdGetter =
        channelIdGetter ??
        (msg) => msg.notification?.android?.channelId ?? defaultChannelId;
    this.channelNameGetter = channelNameGetter ?? (_) => defaultChannelName;
    this.channelDescriptionGetter =
        channelDescriptionGetter ?? (_) => defaultChannelDescription;
    this.appIconGetter = appIconGetter ?? (_) => defaultAppIcon;
    this.colorGetter = colorGetter ?? (_) => defaultColor;
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
  }

  /// {@template channelIdGetter}
  ///
  /// If [message.notification?.android?.channelId] exists in the map,
  /// then it is used, if not then the default value is used, else the value
  /// passed will be used.
  ///
  /// The notification channel's id. Defaults to 'default'.
  ///
  /// Required for Android 8.0 or newer.
  ///
  /// {@endtemplate}
  static String defaultChannelId = 'default';

  /// {@template channelNameGetter}
  ///
  /// The notification channel's name. Defaults to 'Default'.
  ///
  /// Required for Android 8.0 or newer.
  ///
  /// {@endtemplate}
  static String defaultChannelName = 'Default';

  /// {@template channelDescriptionGetter}
  ///
  /// The notification channel's description. Defaults to 'Default channel for all notifications'.
  ///
  /// Required for Android 8.0 or newer.
  ///
  /// {@endtemplate}
  static String defaultChannelDescription =
      'Default channel for all notifications';

  /// {@template appIconGetter}
  ///
  /// The app icon to display in the notification.
  ///
  /// Defaults to '@mipmap/ic_launcher'.
  ///
  /// {@endtemplate}
  static String defaultAppIcon = '@mipmap/ic_launcher';

  /// {@template soundGetter}
  ///
  /// The sound to play for the notification.
  ///
  /// Pass in the name of the audio file as a string if you
  /// want a custom sound for the notification.
  ///
  /// Android: Add the audio file in android/app/src/main/res/raw/___audio-file-here___
  ///
  /// The string may not have an extension.
  ///
  /// The [playSoundGetter] callback should return true for this to work.
  /// If [playSoundGetter] returns true, but this is not specified then the default
  /// sound is played.
  ///
  /// Add the default channelId in the AndroidManifest file in your project.
  ///
  ///   <meta-data
  ///      android:name="com.google.firebase.messaging.default_notification_channel_id"
  ///      android:value="ID" />
  ///
  /// Pass in the same "ID" in the [channelId] parameter.
  ///
  /// For Android 8.0 or newer, this is tied to the specified channel and cannot
  /// be changed after the channel has been created for the first time.
  ///
  /// {@endtemplate}
  static String? defaultSound;

  /// {@template importanceGetter}
  ///
  /// The importance of the notification.
  ///
  /// {@endtemplate}

  static Importance defaultImportance = Importance.defaultImportance;

  /*  static HighQNotificationsImportance defaultImportance =
      HighQNotificationsImportance.max;*/

  /// {@template priorityGetter}
  ///
  /// The priority of the notification.
  ///
  /// {@endtemplate}

  static Priority defaultPriority = Priority.defaultPriority;

  /* static HighQNotificationsPriority defaultPriority =
      HighQNotificationsPriority.max;*/

  /// {@template groupKeyGetter}
  ///
  /// Specifies the group that this notification belongs to.
  ///
  /// For Android 7.0 or newer.
  ///
  /// {@endtemplate}
  static String? defaultGroupKey;

  /// {@template iconGetter}
  ///
  // The icon that should be used when displaying the notification.
  ///
  /// {@endtemplate}
  static String? defaultIcon;

  /// {@template imageUrlGetter}
  ///
  /// Specifies the url of the image to display in the notification.
  ///
  /// {@endtemplate}
  static String? defaultImageUrl;

  /// {@template smallIconUrlGetter}
  ///
  /// Specifies the url of the small icon to display in the notification.
  ///
  /// {@endtemplate}
  static String? defaultSmallIcon;

  /// {@template colorGetter}
  ///
  /// Specifies the color.
  ///
  /// {@endtemplate}
  static Color? defaultColor;

  /// {@template tagGetter}
  ///
  /// The notification tag.
  ///
  /// Showing notification with the same (tag, id) pair as a currently visible
  /// notification will replace the old notification with the new one, provided
  /// the old notification was one that was not one that was scheduled. In other
  /// words, the (tag, id) pair is only applicable for notifications that were
  /// requested to be shown immediately. This is because the Android
  /// AlarmManager APIs used for scheduling notifications only allow for using
  /// the id to uniquely identify alarms.
  ///
  /// {@endtemplate}
  static String? defaultTag;

  /// {@template hideExpandedLargeIconGetter}
  ///
  /// Hides the large icon when showing the expanded notification.
  ///
  /// {@endtemplate}
  static bool defaultHideExpandedLargeIcon = true;

  /// {@template playSoundGetter}
  ///
  /// Indicates if a sound should be played when the notification is displayed.
  ///
  /// For Android 8.0 or newer, this is tied to the specified channel and cannot
  /// be changed after the channel has been created for the first time.
  ///
  /// {@endtemplate}
  static bool defaultPlaySound = true;

  /// {@template enableVibrationGetter}
  ///
  /// Indicates if vibration should be enabled when the notification is
  /// displayed.
  ///
  /// For Android 8.0 or newer, this is tied to the specified channel and cannot
  /// be changed after the channel has been created for the first time.
  ///
  /// {@endtemplate}
  static bool defaultEnableVibration = true;

  /// {@template enableLightsGetter}
  ///
  /// Indicates if lights should be enabled when the notification is displayed.
  ///
  /// For Android 8.0 or newer, this is tied to the specified channel and cannot
  /// be changed after the channel has been created for the first time.
  ///
  /// {@endtemplate}
  static bool defaultEnableLights = true;

  /// {@macro channelIdGetter}
  late StringGetter channelIdGetter;

  /// {@macro channelNameGetter}
  late StringGetter channelNameGetter;

  /// {@macro channelDescriptionGetter}
  late StringGetter channelDescriptionGetter;

  /// {@macro appIconGetter}
  late StringGetter appIconGetter;

  /// {@macro soundGetter}
  late NullableStringGetter soundGetter;

  /// {@macro importanceGetter}
  late AndroidImportanceGetter importanceGetter;

  /// {@macro priorityGetter}
  late AndroidPriorityGetter priorityGetter;

  /// {@macro groupKeyGetter}
  late NullableStringGetter groupKeyGetter;

  /// {@macro iconGetter}
  late NullableStringGetter iconGetter;

  /// {@macro imageUrlGetter}
  late NullableStringGetter imageUrlGetter;

  /// {@macro smallIconUrlGetter}
  late NullableStringGetter smallIconUrlGetter;

  /// {@macro colorGetter}
  late NullableColorGetter colorGetter;

  /// {@macro tagGetter}
  late NullableStringGetter tagGetter;

  /// {@macro hideExpandedLargeIconGetter}
  late BoolGetter hideExpandedLargeIconGetter;

  /// {@macro playSoundGetter}
  late BoolGetter playSoundGetter;

  /// {@macro enableVibrationGetter}
  late BoolGetter enableVibrationGetter;

  /// {@macro enableLightsGetter}
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
