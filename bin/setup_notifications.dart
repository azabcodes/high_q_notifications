#!/usr/bin/env dart

import 'dart:io';

void main() {
  /// ========== Android Configuration ==========
  final manifestPath = 'android/app/src/main/AndroidManifest.xml';
  final file = File(manifestPath);

  if (!file.existsSync()) {
    print('❌ AndroidManifest.xml not found at $manifestPath');
  } else {
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
    } else {
      final missingPermissions = permissions
          .where((perm) => !content.contains(perm))
          .toList();

      if (missingPermissions.isNotEmpty) {
        final permissionsString = '${missingPermissions.join('\n    ')}\n\n';
        content = content.replaceRange(
          appTagIndex,
          appTagIndex,
          permissionsString,
        );
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
        final appTagOpenMatch = RegExp(
          r'<application[^>]*>',
        ).firstMatch(content);
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

      final activityRegex = RegExp(
        r'<activity[^>]*android:name="\.MainActivity"[^>]*>',
      );
      final activityMatch = activityRegex.firstMatch(content);

      if (activityMatch == null) {
        print('❌ <activity android:name=".MainActivity"> tag not found');
      } else {
        final activityStart = activityMatch.end;
        final activityEndIndex = content.indexOf('</activity>', activityStart);
        if (activityEndIndex == -1) {
          print('❌ Closing </activity> tag not found for MainActivity');
        } else {
          if (!content.contains(
            '<action android:name="FLUTTER_NOTIFICATION_CLICK" />',
          )) {
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

      file.writeAsStringSync(content);
      print('🎉 AndroidManifest.xml updated successfully!');
    }
  }

  /// ========== iOS Configuration (Info.plist) ==========
  final plistPath = 'ios/Runner/Info.plist';
  final plistFile = File(plistPath);

  if (!plistFile.existsSync()) {
    print('❌ Info.plist not found at $plistPath');
  } else {
    var plistContent = plistFile.readAsStringSync();
    bool updated = false;

    void insertIfMissing(String key, String value) {
      if (!plistContent.contains('<key>$key</key>')) {
        final insertBefore = '</dict>';
        plistContent = plistContent.replaceFirst(
          insertBefore,
          '  <key>$key</key>\n  <string>$value</string>\n$insertBefore',
        );
        print('✅ Added $key to Info.plist');
        updated = true;
      } else {
        print('ℹ️ $key already exists in Info.plist');
      }
    }

    insertIfMissing('UIBackgroundModes', '''
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
''');

    insertIfMissing('FirebaseAppDelegateProxyEnabled', 'false');

    insertIfMissing(
      'NSPushNotificationsUsageDescription',
      'We need permission to send you important updates.',
    );

    insertIfMissing(
      'NSUserNotificationUsageDescription',
      'We need your permission to send you notifications about important updates.',
    );

    if (updated) {
      plistFile.writeAsStringSync(plistContent);
      print('🎉 Info.plist updated successfully!');
    }
  }

  /// ========== iOS Configuration (AppDelegate.swift) ==========
  final appDelegatePath = 'ios/Runner/AppDelegate.swift';
  final appDelegateFile = File(appDelegatePath);

  if (!appDelegateFile.existsSync()) {
    print('❌ AppDelegate.swift not found at $appDelegatePath');
  } else {
    var appDelegateContent = appDelegateFile.readAsStringSync();

    if (appDelegateContent.contains('FirebaseApp.configure()')) {
      print('ℹ️ Firebase setup already present in AppDelegate.swift');
    } else {
      final newAppDelegateCode = '''
import UIKit
import Flutter
import flutter_local_notifications
import Firebase
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Configure Firebase
    FirebaseApp.configure()

    // Setup Local Notifications
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
''';

      appDelegateFile.writeAsStringSync(newAppDelegateCode);
      print('✅ AppDelegate.swift updated successfully!');
    }
  }
}
