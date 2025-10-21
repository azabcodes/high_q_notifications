import 'dart:typed_data';

/// Flags for Android notifications as per https://developer.android.com/reference/android/app/Notification#flags
enum HighQAndroidNotificationFlag {
  /// The notification sound will repeat until the user interacts with the notification.
  insistent(1),

  /// The notification is ongoing and cannot be dismissed by the user with a swipe.
  ongoingEvent(2),

  /// The notification will only alert once (sound/vibration).
  onlyAlertOnce(4),

  /// The notification will be automatically canceled when the user taps it.
  autoCancel(8),

  /// The notification cannot be cleared by the user manually.
  noClear(16),

  /// Indicates that this notification is for a foreground service.
  foregroundService(32),

  /// Sets high priority for the notification (deprecated).
  highPriority(64),

  /// The notification will show LED lights.
  showLights(128),

  /// This notification is a group summary.
  groupSummary(256),

  /// Use colorized notification style (Android 8+).
  useColorized(512),

  /// Improves colorized notification appearance.
  colorized(1024);

  final int value;

  const HighQAndroidNotificationFlag(this.value);
}

Int32List flagsToInt32List(List<HighQAndroidNotificationFlag> flags) {
  int combinedValue = 0;
  for (var flag in flags) {
    combinedValue |= flag.value;
  }
  return Int32List.fromList([combinedValue]);
}
