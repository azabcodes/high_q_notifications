#!/usr/bin/env dart

import 'dart:io';

Future<void> main() async {
  await addPackageIfMissing(packageName: 'firebase_core');
  await addPackageIfMissing(packageName: 'firebase_messaging');
  await createNotificationServiceFiles();

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

  /// ========== Android raw folder & keep.xml ==========
  final rawDir = Directory('android/app/src/main/res/raw');
  if (!rawDir.existsSync()) {
    rawDir.createSync(recursive: true);
    print('✅ Created raw directory at ${rawDir.path}');
  } else {
    print('ℹ️ raw directory already exists');
  }

  final keepFile = File('${rawDir.path}/keep.xml');
  if (!keepFile.existsSync()) {
    keepFile.writeAsStringSync('''<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@drawable/*,@raw/notification_sound" />''');
    print('✅ Created keep.xml in raw directory');
  } else {
    print('ℹ️ keep.xml already exists in raw directory');
  }
}

Future<void> addPackageIfMissing({required String packageName}) async {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found!');
    return;
  }
  final content = pubspecFile.readAsStringSync();
  if (content.contains(packageName)) {
    print('ℹ️ $packageName already exists in pubspec.yaml');
    return;
  }

  print('⬇️ Adding $packageName using flutter pub add...');
  final result = await Process.run('flutter', ['pub', 'add', packageName]);

  if (result.exitCode == 0) {
    print('✅ Successfully added $packageName');
  } else {
    print('❌ Failed to add $packageName');
    print(result.stdout);
    print(result.stderr);
  }
}

Future<void> createNotificationServiceFiles() async {
  final basePath = 'lib/notification_service';

  final files = <String, String>{
    '$basePath/configs/android_config.dart': '''
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

final AndroidConfigModel androidConfig = AndroidConfigModel(
  channelIdGetter: (RemoteMessage remoteMessage) {
    return '_testId';
  },
  channelNameGetter: (RemoteMessage remoteMessage) {
    return 'Test App Notification';
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
''',
    '$basePath/configs/ios_config.dart': '''
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

final IosConfigModel iosConfig = IosConfigModel(
  presentSoundGetter: (RemoteMessage remoteMessage) {
    return true;
  },
  soundGetter: (RemoteMessage remoteMessage) {
    return 'notification_sound.caf';
  },
);
''',

    '$basePath/utils/handle_navigation.dart': '''
import 'package:flutter/foundation.dart';
import 'package:high_q_notifications/high_q_notifications.dart';
import 'notifications_type.dart';

class HandleNotificationsNavigation {
  static void handleNotificationTap(NotificationInfoModel info) {
    final payload = info.payload;
    final appState = info.appState;
    final firebaseMessage = info.firebaseMessage.toMap();

    if (payload['type'] != null) {
      try {
        final notificationType = NotificationsTypes.values.firstWhere(
          (e) => e.toString().split('.').last == payload['type'],
        );

        if (kDebugMode) {
          print('Notification Type: \$notificationType');
        }

        switch (notificationType) {
          case NotificationsTypes.notificationScreen:
          /* SLServices.navigationLocator.toPage(
              page: ScreenName(
                id: int.tryParse(payload['id'])!,
              ),
            );*/
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing notification type: \$e');
        }
      }
    }

    for (var key in ['url', 'sound', 'image']) {
      if (payload[key] != null) {
        if (kDebugMode) {
          print('\${key.toUpperCase()}: \${payload[key]}');
        }
      }
    }
    if (kDebugMode) {
      print(
        'Notification tapped with \$appState & payload \$payload. Firebase message: \$firebaseMessage',
      );
    }
  }
}
''',

    '$basePath/utils/navigation_service.dart': '''
import 'package:flutter/material.dart';

class NavigationService {
  bool showNotification = true;

  GlobalKey<NavigatorState>? _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerStateKey =
      GlobalKey<ScaffoldMessengerState>();

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerState =>
      _scaffoldMessengerStateKey;

  ValueNotifier<String?> fcmTokenNotifier = ValueNotifier(null);

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey!;

  set navigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;
}
''',

    '$basePath/utils/notifications_type.dart': '''
enum NotificationsTypes { notificationScreen }
''',
  };

  for (final entry in files.entries) {
    final file = File(entry.key);
    final parentDir = file.parent;

    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }

    await file.writeAsString(entry.value, mode: FileMode.write);
    print('✅ File written: ${entry.key}');
  }

  final exportsPath = '$basePath/exports.dart';
  final exportsFile = File(exportsPath);

  const exportContent = '''
export 'configs/android_config.dart';
export 'configs/ios_config.dart';
export 'utils/handle_navigation.dart';
export 'utils/navigation_service.dart';
export 'utils/notifications_type.dart';
''';

  await exportsFile.create(recursive: true);
  await exportsFile.writeAsString(exportContent, mode: FileMode.write);
  print('✅ exports.dart created or updated at $exportsPath');

  final mainCopyPath = 'lib/main_notifications.dart';
  final mainCopyFile = File(mainCopyPath);

  const mainCopyContent = '''
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

import 'notification_service/exports.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    HighQNotifications(
      requestPermissionsOnInitialize: true,
      localNotificationsConfiguration: LocalNotificationsConfigurationModel(
        androidConfig: androidConfig,
        iosConfig: iosConfig,
      ),
      shouldHandleNotification: (_) => true,
      onOpenNotificationArrive: (_) {},
      onTap: HandleNotificationsNavigation.handleNotificationTap,
      onFcmTokenInitialize: (token) {
        NavigationService().fcmTokenNotifier.value = token;
      },
      onFcmTokenUpdate: (token) {
        NavigationService().fcmTokenNotifier.value = token;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService().navigatorKey,
        scaffoldMessengerKey: NavigationService().scaffoldMessengerState,
        home: Scaffold(appBar: AppBar(title: Text('High Q Notifications'))),
      ),
    ),
  );
}
''';

  await mainCopyFile.writeAsString(mainCopyContent, mode: FileMode.write);
  print('✅ main_copy.dart created at $mainCopyPath');
}
