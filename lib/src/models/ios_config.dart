import 'package:firebase_messaging/firebase_messaging.dart';
import '../../high_q_notifications.dart';

class IosConfigModel {
  late IosCategoryGetter? categoryGetter;
  static List<DarwinNotificationCategory> defaultCategories = [];

  static String? defaultSound;

  static String? defaultSubtitle;

  static String? defaultImageUrl;

  static int? defaultBadgeNumber;

  static String? defaultCategoryIdentifier;

  static String? defaultThreadIdentifier;

  static InterruptionLevel? defaultInterruptionLevel;

  static bool defaultPresentSound = true;

  static bool defaultPresentAlert = true;

  static bool defaultPresentBadge = true;

  static bool defaultHideThumbnail = false;

  static bool defaultPresentList = true;

  static bool defaultPresentBanner = true;

  static bool requestAlertPermission = true;

  static bool requestSoundPermission = true;

  static bool requestBadgePermission = true;

  static bool requestProvisionalPermission = false;

  static bool requestCriticalPermission = false;

  static DarwinNotificationAttachmentThumbnailClippingRect?
  defaultThumbnailClippingRectGetter;

  late NullableStringGetter soundGetter;

  late NullableStringGetter subtitleGetter;

  late NullableStringGetter imageUrlGetter;

  late NullableIntGetter badgeNumberGetter;

  late NullableStringGetter categoryIdentifierGetter;

  late NullableStringGetter threadIdentifierGetter;

  late IosInterruptionLevelGetter interruptionLevelGetter;

  late BoolGetter presentSoundGetter;

  late BoolGetter presentAlertGetter;

  late BoolGetter presentBadgeGetter;

  late BoolGetter hideThumbnailGetter;

  late BoolGetter presentListGetter;

  late BoolGetter presentBannerGetter;

  late IosNotificationAttachmentClippingRectGetter? thumbnailClippingRectGetter;

  IosConfigModel({
    NullableStringGetter? soundGetter,
    NullableStringGetter? subtitleGetter,
    NullableStringGetter? imageUrlGetter,
    NullableIntGetter? badgeNumberGetter,
    NullableStringGetter? categoryIdentifierGetter,
    NullableStringGetter? threadIdentifierGetter,
    IosInterruptionLevelGetter? interruptionLevelGetter,
    BoolGetter? presentSoundGetter,
    BoolGetter? presentAlertGetter,
    BoolGetter? presentBadgeGetter,
    BoolGetter? presentBannerGetter,
    BoolGetter? presentListGetter,
    BoolGetter? hideThumbnailGetter,
    IosNotificationAttachmentClippingRectGetter? thumbnailClippingRectGetter,
    IosCategoryGetter? categoryGetter,
  }) {
    final soundGetterRef =
        soundGetter ??
        (msg) => msg.notification?.apple?.sound?.name ?? defaultSound;

    this.soundGetter = (msg) {
      final sound = soundGetterRef(msg);

      if (sound != null) {
        assert(
          sound.contains('.'),
          'The sound name must contain the extension',
        );
      }

      return sound;
    };

    this.subtitleGetter =
        subtitleGetter ??
        (msg) => msg.notification?.apple?.subtitle ?? defaultSubtitle;
    this.imageUrlGetter =
        imageUrlGetter ??
        (msg) => msg.notification?.apple?.imageUrl ?? defaultImageUrl;
    this.badgeNumberGetter = badgeNumberGetter ?? (_) => defaultBadgeNumber;
    this.categoryIdentifierGetter =
        categoryIdentifierGetter ?? (_) => defaultCategoryIdentifier;
    this.threadIdentifierGetter =
        threadIdentifierGetter ?? (_) => defaultThreadIdentifier;
    this.interruptionLevelGetter =
        interruptionLevelGetter ?? (_) => defaultInterruptionLevel;
    this.hideThumbnailGetter =
        hideThumbnailGetter ?? (_) => defaultHideThumbnail;
    this.thumbnailClippingRectGetter =
        thumbnailClippingRectGetter ??
        (_) => defaultThumbnailClippingRectGetter;
    this.presentSoundGetter = presentSoundGetter ?? (_) => defaultPresentSound;
    this.presentAlertGetter = presentAlertGetter ?? (_) => defaultPresentAlert;
    this.presentBadgeGetter = presentBadgeGetter ?? (_) => defaultPresentBadge;
    this.presentBannerGetter =
        presentBannerGetter ?? (_) => defaultPresentBanner;
    this.presentListGetter = presentListGetter ?? (_) => defaultPresentList;
    this.categoryGetter = categoryGetter ?? (_) => defaultCategories;
  }

  DarwinNotificationDetails toSpecifics(
    RemoteMessage message, {
    List<DarwinNotificationAttachment>? attachments,
  }) {
    return DarwinNotificationDetails(
      attachments: attachments,
      sound: soundGetter(message),
      subtitle: subtitleGetter(message),
      badgeNumber: badgeNumberGetter(message),
      interruptionLevel: interruptionLevelGetter(message),
      threadIdentifier: threadIdentifierGetter(message),
      categoryIdentifier: categoryIdentifierGetter(message),
      presentSound: presentSoundGetter(message),
      presentAlert: presentAlertGetter(message),
      presentBadge: presentBadgeGetter(message),
      presentBanner: presentBannerGetter(message),
      presentList: presentListGetter(message),
    );
  }
}
