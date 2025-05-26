#!/usr/bin/env dart

import 'dart:io';

void main() {
  final manifestPath = 'android/app/src/main/AndroidManifest.xml';
  final file = File(manifestPath);

  if (!file.existsSync()) {
    print('❌ AndroidManifest.xml not found at $manifestPath');
    return;
  }

  var content = file.readAsStringSync();

  /// 1. Add permissions before <application> if missing
  final permissions = [
    '<uses-permission android:name="android.permission.INTERNET" />',
    '<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />',
    '<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />',
    '<uses-permission android:name="android.permission.VIBRATE" />',
    '<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />',
    '<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />',
  ];

  final appTagIndex = content.indexOf('<application');
  if (appTagIndex == -1) {
    print('❌ <application> tag not found in AndroidManifest.xml');
    return;
  }

  final missingPermissions = permissions
      .where((perm) => !content.contains(perm))
      .toList();

  if (missingPermissions.isNotEmpty) {
    final permissionsString = '${missingPermissions.join('\n    ')}\n\n';
    content = content.replaceRange(appTagIndex, appTagIndex, permissionsString);
    print('✅ Added missing permissions');
  } else {
    print('ℹ️ All permissions already exist');
  }

  /// 2. Add meta-data inside <application> if missing
  final metaData = '''
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_channel_id"
        android:value="default" />
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_icon"
        android:resource="@drawable/notification_icon" />
  ''';

  if (!content.contains(
    'com.google.firebase.messaging.default_notification_channel_id',
  )) {
    final appTagOpenMatch = RegExp(r'<application[^>]*>').firstMatch(content);
    if (appTagOpenMatch != null) {
      final insertAt = appTagOpenMatch.end;
      content = content.replaceRange(insertAt, insertAt, '\n$metaData\n');
      print('✅ Added meta-data inside <application>');
    } else {
      print('❌ Could not find <application> tag to insert meta-data');
    }
  } else {
    print('ℹ️ Meta-data already exist');
  }

  /// 3. Add intent-filter inside <activity> (MainActivity) if missing
  final intentFilter = '''
        <intent-filter>
            <action android:name="FLUTTER_NOTIFICATION_CLICK" />
            <category android:name="android.intent.category.DEFAULT" />
        </intent-filter>
  ''';

  // Find the MainActivity start tag <activity ... >
  final activityRegex = RegExp(
    r'<activity[^>]*android:name="\.MainActivity"[^>]*>',
  );
  final activityMatch = activityRegex.firstMatch(content);

  if (activityMatch == null) {
    print('❌ <activity android:name=".MainActivity"> tag not found');
  } else {
    final activityStart = activityMatch.end;

    // Find the corresponding </activity> closing tag for MainActivity
    // We will insert the intent-filter before </activity>
    final activityEndIndex = content.indexOf('</activity>', activityStart);
    if (activityEndIndex == -1) {
      print('❌ Closing </activity> tag not found for MainActivity');
    } else {
      if (!content.contains(
        '<action android:name="FLUTTER_NOTIFICATION_CLICK" />',
      )) {
        // Insert intent-filter before </activity>
        content = content.replaceRange(
          activityEndIndex,
          activityEndIndex,
          '\n$intentFilter\n',
        );
        print('✅ Added intent-filter inside <activity>');
      } else {
        print('ℹ️ intent-filter inside <activity> already exists');
      }
    }
  }

  // Write back to file
  file.writeAsStringSync(content);
  print('🎉 AndroidManifest.xml updated successfully!');
}
