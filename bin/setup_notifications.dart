#!/usr/bin/env dart

// ignore_for_file: avoid_print
import 'dart:io';

Future<void> main() async {
  await addPackageIfMissing(packageName: 'firebase_core');
  await addPackageIfMissing(packageName: 'firebase_messaging');
  await createNotificationServiceFiles();

  /// ========== Android build.gradle.kts Configuration ==========
  final buildGradleKtsPath = 'android/app/build.gradle.kts';
  final buildGradleKtsFile = File(buildGradleKtsPath);

  if (!buildGradleKtsFile.existsSync()) {
    print('❌ build.gradle.kts not found at $buildGradleKtsPath');
  } else {
    var gradleContent = buildGradleKtsFile.readAsStringSync();
    bool updated = false;

    /// 1. Ensure dependencies block exists and inject lines
    final dependenciesRegex = RegExp(r'dependencies\s*{([\s\S]*?)\n}');
    final match = dependenciesRegex.firstMatch(gradleContent);

    const coreKtx = 'implementation("androidx.core:core-ktx:1.12.0")';
    const desugarLib =
        'coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")';

    if (match != null) {
      String fullBlock = match.group(0)!;
      String updatedBlock = fullBlock;

      if (!fullBlock.contains(coreKtx)) {
        updatedBlock = updatedBlock.replaceFirst('{', '{\n    $coreKtx');
      }

      if (!fullBlock.contains(desugarLib)) {
        updatedBlock = updatedBlock.replaceFirst('{', '{\n    $desugarLib');
      }

      if (updatedBlock != fullBlock) {
        gradleContent = gradleContent.replaceFirst(fullBlock, updatedBlock);
        print('✅ Updated existing dependencies block');
        updated = true;
      } else {
        print('ℹ️ Dependencies already present');
      }
    } else {
      // No dependencies block exists — create one
      final newBlock =
          '''
dependencies {
    $coreKtx
    $desugarLib
}
''';

      // Try to insert before closing bracket of android { }
      final androidBlockEnd = gradleContent.lastIndexOf("}"); // crude but works
      if (androidBlockEnd != -1) {
        gradleContent = gradleContent.replaceRange(
          androidBlockEnd,
          androidBlockEnd,
          '\n\n$newBlock\n',
        );
        print('✅ Created new dependencies block');
        updated = true;
      } else {
        // fallback: append to end
        gradleContent += '\n\n$newBlock\n';
        print('✅ Appended new dependencies block at end of file');
        updated = true;
      }
    }

    /// 2. Add multiDexEnabled = true inside defaultConfig
    final defaultConfigRegex = RegExp(r'defaultConfig\s*{');
    if (defaultConfigRegex.hasMatch(gradleContent)) {
      final match = defaultConfigRegex.firstMatch(gradleContent)!;
      final insertIndex = match.end;
      if (!gradleContent.contains('multiDexEnabled = true')) {
        gradleContent = gradleContent.replaceRange(
          insertIndex,
          insertIndex,
          '\n        multiDexEnabled = true',
        );
        print('✅ Added multiDexEnabled = true inside defaultConfig');
        updated = true;
      } else {
        print('ℹ️ multiDexEnabled already exists in defaultConfig');
      }
    } else {
      print('❌ Could not find defaultConfig block');
    }

    /// 3. Add isCoreLibraryDesugaringEnabled = true inside compileOptions
    final compileOptionsRegex = RegExp(r'compileOptions\s*{');
    if (compileOptionsRegex.hasMatch(gradleContent)) {
      final match = compileOptionsRegex.firstMatch(gradleContent)!;
      final insertIndex = match.end;
      if (!gradleContent.contains('isCoreLibraryDesugaringEnabled = true')) {
        gradleContent = gradleContent.replaceRange(
          insertIndex,
          insertIndex,
          '\n        isCoreLibraryDesugaringEnabled = true',
        );
        print(
          '✅ Added isCoreLibraryDesugaringEnabled = true inside compileOptions',
        );
        updated = true;
      } else {
        print('ℹ️ isCoreLibraryDesugaringEnabled already exists');
      }
    } else {
      print('❌ Could not find compileOptions block');
    }

    /// Save file if any changes were made
    if (updated) {
      buildGradleKtsFile.writeAsStringSync(gradleContent);
      print('🎉 build.gradle.kts updated successfully!');
    }
  }

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
      final metaDataAndReceiver = '''
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_channel_id"
        android:value="my_channel_id" />
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_icon"
        android:resource="@drawable/notification_icon" />
        
        
     <!-- Receiver for handling custom actions with Flutter Local Notifications -->
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ActionBroadcastReceiver"
            android:exported="false" />

        <!-- Receiver for scheduling notifications using Flutter Local Notifications -->
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver"
            android:exported="false" />

        <!-- Receiver for handling scheduled notifications after device reboot -->
        <receiver
            android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver"
            android:exported="false">

            <!-- Intent filters for handling boot and package replacement actions -->
            <intent-filter>
                <!-- Action for handling device boot completed -->
                <action android:name="android.intent.action.BOOT_COMPLETED" />

                <!-- Action for handling package replacement (like app updates) -->
                <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />

                <!-- Action for handling quick boot/power on (on certain devices) -->
                <action android:name="android.intent.action.QUICKBOOT_POWERON" />
                <action android:name="com.htc.intent.action.QUICKBOOT_POWERON" />
            </intent-filter>
        </receiver>    
        
  ''';

      if (!content.contains(
        'com.google.firebase.messaging.default_notification_channel_id',
      )) {
        final appTagOpenMatch = RegExp(
          r'<application[^>]*>',
        ).firstMatch(content);
        if (appTagOpenMatch != null) {
          final insertAt = appTagOpenMatch.end;
          content = content.replaceRange(
            insertAt,
            insertAt,
            '\n$metaDataAndReceiver\n',
          );
          print('✅ Added meta-data and receivers inside <application>');
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
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

final AndroidConfigModel androidConfig = AndroidConfigModel(
  channelIdGetter: (RemoteMessage remoteMessage) {
    return 'my_channel_id';
  },
  channelNameGetter: (RemoteMessage remoteMessage) {
    return 'Test App Notification';
  },
  actionsGetter: (RemoteMessage message) {
    final data = message.data['action_buttons'];
    if (data == null) return [];

    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded.map<AndroidNotificationAction>((item) {
      final id = item['action'] ?? 'default_action';
      final title = item['title'] ?? 'Action';

      return AndroidNotificationAction(
        id,
        title,
        showsUserInterface: true,
        inputs: [
          if (id == 'reply_action')
            const AndroidNotificationActionInput(label: 'Type your reply'),
        ],
      );
    }).toList();
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
    return Importance.max;
  },
  priorityGetter: (RemoteMessage remoteMessage) {
    return Priority.max;
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
export 'utils/handle_actions.dart';
''';

  await exportsFile.create(recursive: true);
  await exportsFile.writeAsString(exportContent, mode: FileMode.write);
  print('✅ exports.dart created or updated at $exportsPath');

  final handleActionsPath = '$basePath/utils/handle_actions.dart';
  final handleActionsFile = File(handleActionsPath);

  const handleActionsContent = '''
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:high_q_notifications/high_q_notifications.dart';

class HandleNotificationsActions {
  static void handleAction(
    NotificationResponse response,
    RemoteMessage message,
  ) {
    final actionInfo = NotificationActionInfoModel(
      appState: _getAppState(response),
      firebaseMessage: message,
      response: response,
    );

    switch (response.actionId) {
      case 'add_text':
        if (kDebugMode) {
          print('actionInfo response');
          print(actionInfo.response.data);
          print('actionInfo firebaseMessage');
          print(actionInfo.firebaseMessage.data);
          print('add_text action');
          print(response.actionId);
        }
        break;
      default:
        if (kDebugMode) {
          print('default action');
          print(response.actionId);
        }
    }
  }

  static AppState _getAppState(NotificationResponse response) {
    if (response.notificationResponseType ==
        NotificationResponseType.selectedNotificationAction) {
      // For background actions, we need to determine if the app was in background or terminated
      return PlatformDispatcher.instance.platformBrightness == Brightness.dark
          ? AppState.background
          : AppState.terminated;
    }
    return AppState.open;
  }
}
''';

  await handleActionsFile.create(recursive: true);
  await handleActionsFile.writeAsString(
    handleActionsContent,
    mode: FileMode.write,
  );
  print('✅ handle_actions.dart created or updated at $handleActionsPath');

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
      onAction: HandleNotificationsActions.handleAction,
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
