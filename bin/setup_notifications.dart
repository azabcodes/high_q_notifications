import 'dart:io';

import 'package:flutter/foundation.dart';

void main() {
  final manifestPath = 'android/app/src/main/AndroidManifest.xml';
  final file = File(manifestPath);

  if (!file.existsSync()) {
    if (kDebugMode) {
      print('❌ AndroidManifest.xml not found at $manifestPath');
    }
    return;
  }

  var content = file.readAsStringSync();

  /// 1. Add permissions before <application>
  final permissions = '''
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
  ''';

  if (!content.contains('android.permission.INTERNET')) {
    content = content.replaceFirst(
      '<application',
      '$permissions\n  <application',
    );
    print('✅ Added permissions');
  } else {
    print('ℹ️ Permissions already exist');
  }

  /// 2. Add meta-data and intent-filter inside <application>
  final metaDataAndIntent = '''
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="default" />
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/notification_icon" />
        <intent-filter>
            <action android:name="FLUTTER_NOTIFICATION_CLICK" />
            <category android:name="android.intent.category.DEFAULT" />
        </intent-filter>
  ''';

  if (!content.contains(
    'com.google.firebase.messaging.default_notification_channel_id',
  )) {
    final appTag = RegExp(r'<application[^>]*>');
    final match = appTag.firstMatch(content);
    if (match != null) {
      final insertAt = match.end;
      content = content.replaceRange(
        insertAt,
        insertAt,
        '\n$metaDataAndIntent',
      );
      if (kDebugMode) {
        print('✅ Added meta-data and intent-filter');
      }
    }
  } else {
    if (kDebugMode) {
      print('ℹ️ Meta-data and intent-filter already exist');
    }
  }

  file.writeAsStringSync(content);
  if (kDebugMode) {
    print('🎉 AndroidManifest.xml updated successfully!');
  }
}

