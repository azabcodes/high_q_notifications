import 'dart:typed_data';
import 'dart:ui';
import '../../high_q_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HighQAndroidConfigModel {
  late AndroidActionsGetter? actionsGetter;

  static String defaultChannelId = 'default';
  static String defaultChannelName = 'Default';
  static String defaultChannelDescription =
      'Default channel for all notifications';
  static String defaultAppIcon = '@mipmap/ic_launcher';
  static String? defaultSound;
  static Importance defaultImportance = Importance.defaultImportance;
  static Priority defaultPriority = Priority.defaultPriority;
  static String? defaultGroupKey;
  static String? defaultIcon;
  static String? defaultImageUrl;
  static String? defaultSmallIcon;
  static Color? defaultColor;
  static bool autoCancel = true;
  static bool silent = false;
  static bool fullScreenIntent = true;
  static Int32List additionalFlags = Int32List.fromList([]);
  static String? defaultTag;
  static bool defaultHideExpandedLargeIcon = true;
  static bool defaultPlaySound = true;
  static bool defaultEnableVibration = true;
  static List<AndroidNotificationAction> defaultActions = [];
  static bool defaultEnableLights = true;
  static bool channelBypassDnd = false;
  static bool setAsGroupSummary = false;
  static GroupAlertBehavior groupAlertBehavior = GroupAlertBehavior.all;
  static bool ongoing = false;
  static bool onlyAlertOnce = false;
  static bool showWhen = true;
  static int? when;
  static bool usesChronometer = false;
  static bool chronometerCountDown = false;
  static bool showProgress = false;
  static int maxProgress = 0;
  static int progress = 0;
  static bool indeterminate = false;
  static Color? ledColor;
  static int? ledOnMs;
  static int? ledOffMs;
  static String? ticker;
  static AndroidNotificationChannelAction channelAction =
      AndroidNotificationChannelAction.createIfNotExists;
  static NotificationVisibility? visibility;
  static int? timeoutAfter;
  static AndroidNotificationCategory? category;
  static String? shortcutId;
  static String? subText;
  static bool colorized = false;
  static int? number;
  static AudioAttributesUsage audioAttributesUsage =
      AudioAttributesUsage.notification;
  static Int64List? vibrationPattern;
  static bool channelShowBadge = true;

  late StringGetter channelIdGetter;
  late StringGetter channelNameGetter;
  late StringGetter channelDescriptionGetter;
  late StringGetter appIconGetter;
  late NullableStringGetter soundGetter;
  late AndroidImportanceGetter importanceGetter;
  late AndroidPriorityGetter priorityGetter;
  late NullableStringGetter groupKeyGetter;
  late AndroidFlagGetter additionalFlagsGetter;
  late NullableStringGetter iconGetter;
  late NullableStringGetter imageUrlGetter;
  late NullableStringGetter smallIconUrlGetter;
  late NullableColorGetter colorGetter;
  late BoolGetter autoCancelGetter;
  late BoolGetter silentGetter;
  late BoolGetter fullScreenIntentGetter;
  late NullableStringGetter tagGetter;
  late BoolGetter hideExpandedLargeIconGetter;
  late BoolGetter playSoundGetter;
  late BoolGetter enableVibrationGetter;
  late BoolGetter enableLightsGetter;
  late BoolGetter channelBypassDndGetter;
  late BoolGetter setAsGroupSummaryGetter;
  late GroupAlertBehaviorGetter groupAlertBehaviorGetter;
  late BoolGetter ongoingGetter;
  late BoolGetter onlyAlertOnceGetter;
  late BoolGetter showWhenGetter;
  late NullableIntGetter whenGetter;
  late BoolGetter usesChronometerGetter;
  late BoolGetter chronometerCountDownGetter;
  late BoolGetter showProgressGetter;
  late IntGetter maxProgressGetter;
  late IntGetter progressGetter;
  late BoolGetter indeterminateGetter;
  late NullableColorGetter ledColorGetter;
  late NullableIntGetter ledOnMsGetter;
  late NullableIntGetter ledOffMsGetter;
  late NullableStringGetter tickerGetter;
  late AndroidNotificationChannelActionGetter channelActionGetter;
  late NotificationVisibilityGetter visibilityGetter;
  late NullableIntGetter timeoutAfterGetter;
  late AndroidNotificationCategoryGetter categoryGetter;
  late NullableStringGetter shortcutIdGetter;
  late NullableStringGetter subTextGetter;
  late BoolGetter colorizedGetter;
  late NullableIntGetter numberGetter;
  late AudioAttributesUsageGetter audioAttributesUsageGetter;
  late NullableInt64ListGetter vibrationPatternGetter;
  late BoolGetter channelShowBadgeGetter;

  HighQAndroidConfigModel({
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
    BoolGetter? silentGetter,
    BoolGetter? fullScreenIntentGetter,
    AndroidActionsGetter? actionsGetter,
    AndroidFlagGetter? additionalFlagsGetter,
    BoolGetter? channelBypassDndGetter,
    BoolGetter? setAsGroupSummaryGetter,
    GroupAlertBehaviorGetter? groupAlertBehaviorGetter,
    BoolGetter? ongoingGetter,
    BoolGetter? onlyAlertOnceGetter,
    BoolGetter? showWhenGetter,
    NullableIntGetter? whenGetter,
    BoolGetter? usesChronometerGetter,
    BoolGetter? chronometerCountDownGetter,
    BoolGetter? showProgressGetter,
    IntGetter? maxProgressGetter,
    IntGetter? progressGetter,
    BoolGetter? indeterminateGetter,
    NullableColorGetter? ledColorGetter,
    NullableIntGetter? ledOnMsGetter,
    NullableIntGetter? ledOffMsGetter,
    NullableStringGetter? tickerGetter,
    AndroidNotificationChannelActionGetter? channelActionGetter,
    NotificationVisibilityGetter? visibilityGetter,
    NullableIntGetter? timeoutAfterGetter,
    AndroidNotificationCategoryGetter? categoryGetter,
    NullableStringGetter? shortcutIdGetter,
    NullableStringGetter? subTextGetter,
    BoolGetter? colorizedGetter,
    NullableIntGetter? numberGetter,
    AudioAttributesUsageGetter? audioAttributesUsageGetter,
    NullableInt64ListGetter? vibrationPatternGetter,
    BoolGetter? channelShowBadgeGetter,
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
    this.silentGetter = silentGetter ?? (_) => silent;
    this.fullScreenIntentGetter =
        fullScreenIntentGetter ?? (_) => fullScreenIntent;
    this.additionalFlagsGetter = additionalFlagsGetter ?? (_) => [];
    this.maxProgressGetter = maxProgressGetter ?? (_) => maxProgress;
    this.progressGetter = progressGetter ?? (_) => progress;
    this.channelBypassDndGetter =
        channelBypassDndGetter ?? (_) => channelBypassDnd;
    this.setAsGroupSummaryGetter =
        setAsGroupSummaryGetter ?? (_) => setAsGroupSummary;
    this.groupAlertBehaviorGetter =
        groupAlertBehaviorGetter ?? (_) => groupAlertBehavior;
    this.ongoingGetter = ongoingGetter ?? (_) => ongoing;
    this.onlyAlertOnceGetter = onlyAlertOnceGetter ?? (_) => onlyAlertOnce;
    this.showWhenGetter = showWhenGetter ?? (_) => showWhen;
    this.whenGetter = whenGetter ?? (_) => when;
    this.usesChronometerGetter =
        usesChronometerGetter ?? (_) => usesChronometer;
    this.chronometerCountDownGetter =
        chronometerCountDownGetter ?? (_) => chronometerCountDown;
    this.showProgressGetter = showProgressGetter ?? (_) => showProgress;
    this.indeterminateGetter = indeterminateGetter ?? (_) => indeterminate;
    this.ledColorGetter = ledColorGetter ?? (_) => ledColor;
    this.ledOnMsGetter = ledOnMsGetter ?? (_) => ledOnMs;
    this.ledOffMsGetter = ledOffMsGetter ?? (_) => ledOffMs;
    this.tickerGetter = tickerGetter ?? (_) => ticker;
    this.channelActionGetter = channelActionGetter ?? (_) => channelAction;
    this.visibilityGetter = visibilityGetter ?? (_) => visibility;
    this.timeoutAfterGetter = timeoutAfterGetter ?? (_) => timeoutAfter;
    this.categoryGetter = categoryGetter ?? (_) => category;
    this.shortcutIdGetter = shortcutIdGetter ?? (_) => shortcutId;
    this.subTextGetter = subTextGetter ?? (_) => subText;
    this.colorizedGetter = colorizedGetter ?? (_) => colorized;
    this.numberGetter = numberGetter ?? (_) => number;
    this.audioAttributesUsageGetter =
        audioAttributesUsageGetter ?? (_) => audioAttributesUsage;
    this.vibrationPatternGetter =
        vibrationPatternGetter ?? (_) => vibrationPattern;
    this.channelShowBadgeGetter =
        channelShowBadgeGetter ?? (_) => channelShowBadge;

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

  AndroidNotificationDetails toSpecifics(
    RemoteMessage message, {
    StyleInformation? styleInformation,
    AndroidBitmap<Object>? largeIcon,
  }) {
    final androidSound = soundGetter(message);
    final additionalFlagsMap = flagsToInt32List(additionalFlagsGetter(message));

    return AndroidNotificationDetails(
      channelIdGetter(message),
      channelNameGetter(message),
      channelDescription: channelDescriptionGetter(message),
      styleInformation: styleInformation,
      importance: importanceGetter(message),
      priority: priorityGetter(message),
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
      additionalFlags: additionalFlagsMap,
      fullScreenIntent: fullScreenIntentGetter(message),
      silent: silentGetter(message),
      channelBypassDnd: channelBypassDndGetter(message),
      setAsGroupSummary: setAsGroupSummaryGetter(message),
      groupAlertBehavior: groupAlertBehaviorGetter(message),
      ongoing: ongoingGetter(message),
      onlyAlertOnce: onlyAlertOnceGetter(message),
      showWhen: showWhenGetter(message),
      when: whenGetter(message),
      usesChronometer: usesChronometerGetter(message),
      chronometerCountDown: chronometerCountDownGetter(message),
      showProgress: showProgressGetter(message),
      maxProgress: maxProgressGetter(message),
      progress: progressGetter(message),
      indeterminate: indeterminateGetter(message),
      ledColor: ledColorGetter(message),
      ledOnMs: ledOnMsGetter(message),
      ledOffMs: ledOffMsGetter(message),
      ticker: tickerGetter(message),
      channelAction: channelActionGetter(message),
      visibility: visibilityGetter(message),
      timeoutAfter: timeoutAfterGetter(message),
      category: categoryGetter(message),
      shortcutId: shortcutIdGetter(message),
      subText: subTextGetter(message),
      colorized: colorizedGetter(message),
      number: numberGetter(message),
      audioAttributesUsage: audioAttributesUsageGetter(message),
      vibrationPattern: vibrationPatternGetter(message),
      channelShowBadge: channelShowBadgeGetter(message),
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
      bypassDnd: androidSpecifics.channelBypassDnd,
    );
  }
}
