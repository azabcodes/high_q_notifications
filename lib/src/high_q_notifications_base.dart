// ignore: depend_on_referenced_packages

import 'package:timezone/timezone.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../high_q_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.payload != null) {
    final message = RemoteMessage.fromMap(
      jsonDecode(notificationResponse.payload!),
    );

    if (notificationResponse.notificationResponseType ==
        NotificationResponseType.selectedNotificationAction) {
      // Handle action in background
      if (_HighQNotificationsState._onAction != null) {
        _HighQNotificationsState._onAction!(notificationResponse, message);
      } else {
        // Default behavior if no handler is set
        if (kDebugMode) {
          print('Action ${notificationResponse.actionId} tapped in background');
        }
      }
    } else {
      _HighQNotificationsState._notificationHandler(
        message,
        appState: AppState.background,
      );
    }
  }
}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) {
  return _HighQNotificationsState._notificationHandler(
    message,
    appState: AppState.terminated,
  );
}

class HighQNotifications extends StatefulWidget {
  static bool enableLogs = !kReleaseMode;

  static String? get fcmToken => _HighQNotificationsState._fcmToken;

  static final openedAppFromNotification =
      _HighQNotificationsState._openedAppFromNotification;

  final String? vapidKey;

  final bool handleInitialMessage;

  final bool requestPermissionsOnInitialize;

  final Future<void> Function(FirebaseMessaging)? permissionGetter;

  final LocalNotificationsConfigurationModel localNotificationsConfiguration;

  final BoolGetter? shouldHandleNotification;

  final RemoteMessageGetter? messageModifier;

  final FcmInitializeGetter? onFcmTokenInitialize;

  final FcmUpdateGetter? onFcmTokenUpdate;

  final OnOpenNotificationArrive? onOpenNotificationArrive;

  final OnTapGetter? onTap;
  final OnActionGetter? onAction;

  final Widget child;

  const HighQNotifications({
    super.key,
    this.vapidKey,
    this.onTap,
    this.onAction,
    this.onFcmTokenInitialize,
    this.messageModifier,
    this.shouldHandleNotification,
    this.onFcmTokenUpdate,
    this.onOpenNotificationArrive,
    this.handleInitialMessage = true,
    this.requestPermissionsOnInitialize = true,
    this.permissionGetter,
    this.localNotificationsConfiguration =
        const LocalNotificationsConfigurationModel(),
    required this.child,
  });

  static void setOnTap(OnTapGetter? onTap) {
    _HighQNotificationsState._onTap = onTap;
  }

  static void setOnAction(OnActionGetter? onAction) {
    _HighQNotificationsState._onAction = onAction;
  }

  static void setOnOpenNotificationArrive(
    OnOpenNotificationArrive? onOpenNotificationArrive,
  ) {
    _HighQNotificationsState._onOpenNotificationArrive =
        onOpenNotificationArrive;
  }

  static void setShouldHandleNotification(
    BoolGetter? shouldHandleNotification,
  ) {
    _HighQNotificationsState._shouldHandleNotification =
        shouldHandleNotification;
  }

  static void setOnFcmTokenInitialize(
    FcmInitializeGetter? onFcmTokenInitialize,
  ) {
    _HighQNotificationsState._onFCMTokenInitialize = onFcmTokenInitialize;
  }

  static void setOnFcmTokenUpdate(FcmUpdateGetter? onFcmTokenUpdate) {
    _HighQNotificationsState._onFCMTokenUpdate = onFcmTokenUpdate;
  }

  static void setNotificationIdGetter(
    NotificationIdGetter? notificationIdGetter,
  ) {
    _HighQNotificationsState._notificationIdGetter = notificationIdGetter;
  }

  static void setMessageModifier(RemoteMessageGetter? messageModifier) {
    _HighQNotificationsState._messageModifier = messageModifier;
  }

  static void setAndroidConfig(AndroidConfigModel? androidConfig) {
    _HighQNotificationsState._androidConfig = androidConfig;
  }

  static void setIosConfig(IosConfigModel? iosConfig) {
    _HighQNotificationsState._iosConfig = iosConfig;
  }

  // ignore: library_private_types_in_public_api
  static GlobalKey<_HighQNotificationsState> get stateKeyGetter =>
      GlobalKey<_HighQNotificationsState>();

  static bool _initialMessageHandled = false;

  static FlutterLocalNotificationsPlugin? get flutterLocalNotificationsPlugin =>
      _HighQNotificationsState._flutterLocalNotificationsPlugin;

  static final requestPermission =
      _HighQNotificationsState._fcm.requestPermission;

  static const initializeFcmToken = _HighQNotificationsState.initializeFcmToken;

  static const sendLocalNotification =
      _HighQNotificationsState.sendLocalNotification;

  /// Creates a notification channel.
  ///
  /// This method is only applicable to Android versions 8.0 or newer.
  static const createAndroidNotificationChannel =
      _HighQNotificationsState.createAndroidNotificationChannel;

  /// Deletes the notification channel and creates a new one.
  ///
  /// This method is only applicable to Android versions 8.0 or newer.
  static const deleteAndCreateAndroidNotificationChannel =
      _HighQNotificationsState.deleteAndCreateAndroidNotificationChannel;

  /// Creates the provided notification channels.
  ///
  /// This method is only applicable to Android versions 8.0 or newer.
  static const createAndroidNotificationChannels =
      _HighQNotificationsState.createAndroidNotificationChannels;

  /// Creates a notification channel group.
  ///
  /// This method is only applicable to Android versions 8.0 or newer.
  static const createAndroidNotificationChannelGroup =
      _HighQNotificationsState.createAndroidNotificationChannelGroup;

  /// Deletes the notification channel with the specified [channelId].
  ///
  /// This method is only applicable to Android versions 8.0 or newer.
  static const deleteAndroidNotificationChannel =
      _HighQNotificationsState.deleteAndroidNotificationChannel;

  /// Deletes all notification channels
  ///
  /// This method is only applicable to Android versions 8.0 or newer.
  static const deleteAllAndroidNotificationChannels =
      _HighQNotificationsState.deleteAllAndroidNotificationChannels;

  /// Deletes the notification channel group with the specified [groupId]
  /// as well as all of the channels belonging to the group.
  ///
  /// This method is only applicable to Android versions 8.0 or newer.
  static const deleteAndroidNotificationChannelGroup =
      _HighQNotificationsState.deleteAndroidNotificationChannelGroup;

  /// Returns the list of all notification channels.
  ///
  /// This method is only applicable on Android 8.0 or newer. On older versions,
  /// it will return an empty list.
  static const getAndroidNotificationChannels =
      _HighQNotificationsState.getAndroidNotificationChannels;

  /// Re-initializes local notifications.
  static const reInitializeLocalNotifications =
      _HighQNotificationsState.reInitializeLocalNotifications;

  /// {@template getInitialMessage}
  ///
  /// Get the initial message if the app was opened from a notification tap
  /// when the app was terminated.
  ///
  /// {@endtemplate}
  static const getInitialMessage = _HighQNotificationsState.getInitialMessage;
  static const requestFcmToken = _HighQNotificationsState.fcmToken;

  /// {@template notificationTapsSubscription}
  ///
  /// Stream of [NotificationInfoModel] which is triggered whenever a
  /// notification is tapped.
  ///
  /// {@endtemplate}
  static Stream<NotificationInfoModel> get notificationTapsSubscription =>
      _HighQNotificationsState._notificationTapsSubscription.stream;

  /// {@template notificationArrivesSubscription}
  ///
  /// Stream of [NotificationInfoModel] which is triggered whenever a
  /// notification arrives, provided the app is in foreground.
  ///
  /// {@endtemplate}
  static Stream<NotificationInfoModel> get notificationArrivesSubscription =>
      _HighQNotificationsState._notificationArriveSubscription.stream;

  // Topic subscription methods following the same pattern
  static final subscribeToTopic = _HighQNotificationsState._subscribeToTopic;
  static final unsubscribeFromTopic =
      _HighQNotificationsState._unsubscribeFromTopic;
  static final subscribeToTopics = _HighQNotificationsState._subscribeToTopics;
  static final unsubscribeFromTopics =
      _HighQNotificationsState._unsubscribeFromTopics;

  @override
  State<HighQNotifications> createState() => _HighQNotificationsState();
}

class _HighQNotificationsState extends State<HighQNotifications> {
  static final _fcm = FirebaseMessaging.instance;

  static String? _fcmToken;

  static FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  static StreamSubscription<String>? _fcmTokenStreamSubscription;
  static final _notificationTapsSubscription =
      StreamController<NotificationInfoModel>.broadcast();
  static final _notificationArriveSubscription =
      StreamController<NotificationInfoModel>.broadcast();
  static StreamSubscription<RemoteMessage>? _onMessageSubscription;
  static StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  static final _handledNotifications = <String>{};

  static bool _openedAppFromNotification = false;

  static AndroidConfigModel? _androidConfig;
  static IosConfigModel? _iosConfig;

  static BoolGetter? _shouldHandleNotification;

  static NotificationIdGetter? _notificationIdGetter;
  static OnActionGetter? _onAction;
  static OnTapGetter? _onTap;
  static RemoteMessageGetter? _messageModifier;
  static FcmInitializeGetter? _onFCMTokenInitialize;
  static FcmUpdateGetter? _onFCMTokenUpdate;

  static OnOpenNotificationArrive? _onOpenNotificationArrive;

  static Future<void> _createAndroidNotificationChannel(
    AndroidNotificationChannel channel,
  ) async {
    await _flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _deleteAndroidNotificationChannel(
    String channelId,
  ) async {
    await _flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.deleteNotificationChannel(channelId);
  }

  static Future<void> createAndroidNotificationChannel(
    AndroidNotificationChannel channel,
  ) async {
    if (!Platform.isAndroid) return;

    await _initializeLocalNotifications();

    await _createAndroidNotificationChannel(channel);
  }

  static Future<void> deleteAndCreateAndroidNotificationChannel(
    AndroidNotificationChannel channel,
  ) async {
    if (!Platform.isAndroid) return;

    await _initializeLocalNotifications();

    await _deleteAndroidNotificationChannel(channel.id);
    await _createAndroidNotificationChannel(channel);
  }

  static Future<void> createAndroidNotificationChannels(
    List<AndroidNotificationChannel> channels,
  ) async {
    if (!Platform.isAndroid) return;

    await _initializeLocalNotifications();

    final currChannels = await getAndroidNotificationChannels();

    final currChannelIds = currChannels?.map((e) => e.id).toSet() ?? {};

    final futures = channels
        .where((channel) => !currChannelIds.contains(channel.id))
        .map((channel) => _createAndroidNotificationChannel(channel))
        .toList();

    await Future.wait(futures);
  }

  static Future<void> createAndroidNotificationChannelGroup(
    AndroidNotificationChannelGroup group,
  ) async {
    if (!Platform.isAndroid) return;

    await _initializeLocalNotifications();

    await _flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannelGroup(group);
  }

  static Future<void> deleteAndroidNotificationChannel(String channelId) async {
    if (!Platform.isAndroid) return;

    await _initializeLocalNotifications();

    await _deleteAndroidNotificationChannel(channelId);
  }

  static Future<void> deleteAllAndroidNotificationChannels() async {
    if (!Platform.isAndroid) return;

    await _initializeLocalNotifications();

    final currChannels = await getAndroidNotificationChannels();
    final currChannelIds = currChannels?.map((e) => e.id).toSet() ?? {};

    final futures = currChannelIds.map(_deleteAndroidNotificationChannel);
    await Future.wait(futures);
  }

  static Future<void> deleteAndroidNotificationChannelGroup(
    String groupId,
  ) async {
    if (!Platform.isAndroid) return;

    await _initializeLocalNotifications();

    await _flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.deleteNotificationChannelGroup(groupId);
  }

  static Future<List<AndroidNotificationChannel>?>
  getAndroidNotificationChannels() async {
    if (!Platform.isAndroid) return null;

    await _initializeLocalNotifications();

    return await _flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.getNotificationChannels();
  }

  static Future<void> reInitializeLocalNotifications() async {
    await _initializeLocalNotifications(forceInit: true);
  }

  static Future<void> sendLocalNotification({
    required int id,
    required NotificationDetails notificationDetails,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    TZDateTime? scheduledDateTime,
    bool shouldForceInitNotifications = false,
    AndroidScheduleMode? androidScheduleMode,
    DateTimeComponents? matchDateTimeComponents,
    RepeatInterval? repeatInterval,
    Duration? repeatDurationInterval,
  }) async {
    await _initializeLocalNotifications(
      forceInit: shouldForceInitNotifications,
    );

    final payloadStr = payload == null ? null : jsonEncode(payload);
    try {
      if (repeatDurationInterval != null) {
        assert(
          androidScheduleMode != null,
          'androidScheduleMode cannot be null when using repeatDurationInterval',
        );

        await _flutterLocalNotificationsPlugin!.periodicallyShowWithDuration(
          id,
          title,
          body,
          repeatDurationInterval,
          notificationDetails,
          androidScheduleMode: androidScheduleMode!,
          payload: payloadStr,
        );
      } else if (repeatInterval != null) {
        assert(
          androidScheduleMode != null,
          'androidScheduleMode cannot be null when using repeatInterval',
        );

        await _flutterLocalNotificationsPlugin!.periodicallyShow(
          id,
          title,
          body,
          repeatInterval,
          notificationDetails,
          payload: payloadStr,
          androidScheduleMode: androidScheduleMode!,
        );
      } else if (scheduledDateTime != null) {
        assert(
          androidScheduleMode != null,
          'androidScheduleMode cannot be null when scheduledDateTime is not null',
        );
        await _flutterLocalNotificationsPlugin!.zonedSchedule(
          id,
          title,
          body,
          scheduledDateTime,
          notificationDetails,
          payload: payloadStr,
          androidScheduleMode: androidScheduleMode!,
          matchDateTimeComponents: matchDateTimeComponents,
        );
      } else {
        await _flutterLocalNotificationsPlugin!.show(
          id,
          title,
          body,
          notificationDetails,
          payload: payloadStr,
        );
      }
    } catch (e, s) {
      if (kDebugMode) {
        print(
          'Error:$e'
          'StackTrace:$s',
        );
      }
      rethrow;
    }
  }

  static Future<String?> initializeFcmToken({String? vapidKey}) async {
    final isInitialized = _fcmToken != null;

    try {
      if (Platform.isIOS) {
        _fcmToken ??= await _fcm.getAPNSToken();
      } else {
        _fcmToken ??= await _fcm.getToken(vapidKey: vapidKey);
      }
    } catch (e, s) {
      if (kDebugMode) {
        print(
          'Error:$e'
          'StackTrace:$s',
        );
      }
      rethrow;
    }

    if (!isInitialized) {
      _onFCMTokenInitialize?.call(_fcmToken);
      if (HighQNotifications.enableLogs) {
        if (kDebugMode) {
          print('FCM Token Initialized: $_fcmToken');
        }
      }
    }

    _fcmTokenStreamSubscription = _fcm.onTokenRefresh.listen((token) {
      if (_fcmToken == token) return;

      _fcmToken = token;
      _onFCMTokenUpdate?.call(token);
      if (HighQNotifications.enableLogs) {
        if (kDebugMode) {
          print('FCM Token Updated: $_fcmToken');
        }
      }
    });

    return _fcmToken;
  }

  static Future<void> _onMessage(RemoteMessage message) =>
      _notificationHandler(message, appState: AppState.open);

  static Future<void> _onMessageOpenedApp(RemoteMessage message) =>
      _notificationHandler(message, appState: AppState.background);

  static Future<void> _initializeLocalNotifications({
    String? androidNotificationIcon,
    bool forceInit = false,
  }) async {
    await ServicesLocator.init();
    if (!forceInit && _flutterLocalNotificationsPlugin != null) return;

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        androidNotificationIcon ?? AndroidConfigModel.defaultAppIcon,
      ),
      iOS: DarwinInitializationSettings(
        defaultPresentAlert: IosConfigModel.defaultPresentAlert,
        defaultPresentBadge: IosConfigModel.defaultPresentBadge,
        defaultPresentSound: IosConfigModel.defaultPresentSound,
        defaultPresentBanner: IosConfigModel.defaultPresentBanner,
        defaultPresentList: IosConfigModel.defaultPresentList,
        requestAlertPermission: IosConfigModel.requestAlertPermission,
        requestBadgePermission: IosConfigModel.requestBadgePermission,
        requestSoundPermission: IosConfigModel.requestSoundPermission,
        requestProvisionalPermission:
            IosConfigModel.requestProvisionalPermission,
        requestCriticalPermission: IosConfigModel.requestCriticalPermission,
        notificationCategories: IosConfigModel.defaultCategories,
      ),
    );

    try {
      await _flutterLocalNotificationsPlugin!.initialize(
        initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
        onDidReceiveNotificationResponse: (details) async {
          if (details.payload == null || details.payload!.isEmpty) return;

          dynamic decoded;
          try {
            decoded = jsonDecode(details.payload!);
          } catch (e) {
            if (kDebugMode) {
              print('Invalid payload JSON: $e');
            }
            decoded = {};
          }

          Map<String, dynamic> safeMap = {};
          if (decoded is Map) {
            safeMap = decoded.map(
              (key, value) => MapEntry(key.toString(), value),
            );
          }

          RemoteMessage message;
          try {
            if (safeMap.containsKey('messageId') ||
                safeMap.containsKey('data')) {
              message = RemoteMessage.fromMap(safeMap);
            } else {
              message = RemoteMessage.fromMap({'data': safeMap});
            }
          } catch (e) {
            if (kDebugMode) {
              print('Failed to parse RemoteMessage: $e');
            }
            message = RemoteMessage.fromMap({'data': safeMap});
          }

          final appState = AppState.open;

          if (details.notificationResponseType ==
              NotificationResponseType.selectedNotification) {
            final tapDetails = NotificationInfoModel(
              appState: appState,
              firebaseMessage: message, rawData: safeMap,
            );
            _onTap?.call(tapDetails);
            _notificationTapsSubscription.add(tapDetails);
          } else if (details.notificationResponseType ==
              NotificationResponseType.selectedNotificationAction) {
            if (_onAction != null) {
              _onAction!(details, message);
            } else {
              if (kDebugMode) {
                print('Action ${details.actionId} tapped');
              }
            }
          }
        },
      );
    } catch (e, s) {
      if (kDebugMode) {
        print(
          'Error:$e'
          'StackTrace:$s',
        );
      }

      rethrow;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _notificationHandler(
    RemoteMessage message, {
    required AppState appState,
  }) async {
    if (message.notification == null && message.data.isEmpty) {
      if (kDebugMode) {
        print('Empty notification received - ignoring');
      }
      return;
    }
    final receivedMsg = message;

    if (_messageModifier != null) {
      message = _messageModifier!(message);
    }

    bool shouldIgnoreNotification = false;

    if (_shouldHandleNotification != null &&
        !_shouldHandleNotification!(message)) {
      shouldIgnoreNotification = true;
    }

    String logMsg =
        '''\n
    ************************************************************************ 
      NEW NOTIFICATION   ${shouldIgnoreNotification ? '[IGNORED]' : ''}
    ************************************************************************ 
      Title: ${message.notification?.title}
      Body: ${message.notification?.body}
      App State: ${appState.name}''';

    if (_messageModifier == null) {
      logMsg += '\nMessage: ${receivedMsg.toMap()}';
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String prettyPrint = encoder.convert(receivedMsg.toMap());

      if (kDebugMode) {
        print(prettyPrint);
      }
    } else {
      logMsg += '\nMessage[MODIFIED]: ${message.toMap()}';
      logMsg += '\nMessage[RAW]: ${receivedMsg.toMap()}';
    }

    logMsg += '''
    ************************************************************************ 
''';

    if (kDebugMode) {
      print(logMsg);
    }

    if (shouldIgnoreNotification) return;

    final notifInfo = NotificationInfoModel(
      appState: appState,
      firebaseMessage: message, rawData: message.toMap(),
    );

    if (appState == AppState.open) {
      StyleInformation? androidStyleInformation;

      final notificationId = _notificationIdGetter!(message);

      String? notificationImageRes;
      String? notificationIconRes;

      Future<void> initNotificationImageRes() async {
        String? imageUrl;

        if (!kIsWeb) {
          if (Platform.isAndroid) {
            imageUrl = _androidConfig!.imageUrlGetter(message);
          } else if (Platform.isIOS) {
            imageUrl = _iosConfig!.imageUrlGetter(message);
          }
        }

        if (imageUrl == null || imageUrl.isEmpty) {
          return;
        }

        try {
          notificationImageRes = await downloadImage(
            url: imageUrl,
            fileName: '_image__${notificationId}_.png',
          );
        } catch (e) {
          if (kDebugMode) {
            print('Error downloading image: $e');
          }
        }
      }

      Future<void> initNotificationIconRes() async {
        final iconUrl = _androidConfig!.smallIconUrlGetter(message);

        if (iconUrl == null) return;

        notificationIconRes = await downloadImage(
          url: iconUrl,
          fileName: '_icon__${notificationId}_.png',
        );
      }

      await Future.wait([
        initNotificationImageRes(),
        initNotificationIconRes(),
      ]);

      notificationIconRes ??= notificationImageRes;

      if (notificationImageRes != null) {
        androidStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(notificationImageRes!),
          largeIcon: notificationIconRes == null
              ? null
              : FilePathAndroidBitmap(notificationIconRes!),
          hideExpandedLargeIcon: _androidConfig!.hideExpandedLargeIconGetter(
            message,
          ),
        );
      } else if (message.notification?.body != null) {
        androidStyleInformation = BigTextStyleInformation(
          message.notification!.body!,
        );
      }

      final largeIcon = notificationIconRes == null
          ? null
          : FilePathAndroidBitmap(notificationIconRes!);

      final androidSpecifics = _androidConfig!.toSpecifics(
        message,
        largeIcon: largeIcon,
        styleInformation: androidStyleInformation,
      );

      List<DarwinNotificationAttachment>? attachments;

      if (notificationImageRes != null) {
        attachments = [
          DarwinNotificationAttachment(
            notificationImageRes!,
            hideThumbnail: _iosConfig!.hideThumbnailGetter(message),
            thumbnailClippingRect: _iosConfig!.thumbnailClippingRectGetter
                ?.call(message),
          ),
          // TODO: add support for multiple attachments
        ];
      }

      final iOsSpecifics = _iosConfig!.toSpecifics(
        message,
        attachments: attachments,
      );

      final notificationPlatformSpecifics = NotificationDetails(
        android: androidSpecifics,
        iOS: iOsSpecifics,
      );

      final currAndroidAppIcon = _androidConfig!.appIconGetter(message);

      await _initializeLocalNotifications(
        forceInit: currAndroidAppIcon != AndroidConfigModel.defaultAppIcon,
        androidNotificationIcon: currAndroidAppIcon,
      );

      await sendLocalNotification(
        id: notificationId,
        title: message.notification?.title,
        body: message.notification?.body,
        payload: message.toMap(),
        shouldForceInitNotifications: false,
        notificationDetails: notificationPlatformSpecifics,
      );

      _onOpenNotificationArrive?.call(notifInfo);
      _notificationArriveSubscription.add(notifInfo);
    }
    // if AppState is open, do not handle onTap here because it will
    // trigger as soon as notification arrives, instead handle in
    // initialize method in onSelectNotification callback.
    else {
      _onTap?.call(notifInfo);
      _notificationTapsSubscription.add(notifInfo);
    }
  }

  static Future<RemoteMessage?> getInitialMessage({
    bool runMessageModifier = true,
    bool checkShouldHandleNotification = true,
    bool updateOpenedAppFromNotification = true,
  }) async {
    if (HighQNotifications._initialMessageHandled) return null;

    HighQNotifications._initialMessageHandled = true;

    Future<RemoteMessage?> handleFcmInitialMsg() async {
      final bgMessage = await _fcm.getInitialMessage();
      if (bgMessage != null) {
        if (updateOpenedAppFromNotification) _openedAppFromNotification = true;
        return bgMessage;
      }

      return null;
    }

    Future<RemoteMessage?> handleLocalInitialMsg() async {
      await _initializeLocalNotifications();

      final details = await _flutterLocalNotificationsPlugin
          ?.getNotificationAppLaunchDetails();
      if (details?.didNotificationLaunchApp ?? false) {
        if (updateOpenedAppFromNotification) _openedAppFromNotification = true;

        if (details?.notificationResponse?.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          return RemoteMessage.fromMap(
            jsonDecode(details!.notificationResponse!.payload!),
          );
        }
      }

      return null;
    }

    final res = await Future.wait([
      handleFcmInitialMsg(),
      handleLocalInitialMsg(),
    ]);

    RemoteMessage? initialMessage;
    initialMessage = res.firstWhere((e) => e != null, orElse: () => null);

    if (initialMessage != null) {
      if (runMessageModifier && _messageModifier != null) {
        initialMessage = _messageModifier!(initialMessage);
      }

      if (checkShouldHandleNotification &&
          _shouldHandleNotification != null &&
          !_shouldHandleNotification!(initialMessage)) {
        if (kDebugMode) {
          print(
            'Initial message ignored because shouldHandleNotification returned false',
          );
        }

        return null;
      }
    }

    return initialMessage;
  }

  static Future<String?> fcmToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (exception) {
      debugPrint('requestFcmToken exception ==$exception');
    }
    return '';
  }

  // Topic subscription implementation
  static Future<void> _subscribeToTopic({required String topic}) async {
    try {
      if (topic.isEmpty) {
        throw ArgumentError('Topic cannot be empty');
      }

      if (HighQNotifications.enableLogs && kDebugMode) {
        if (kDebugMode) {
          print('Subscribing to topic: $topic');
        }
      }

      await FirebaseMessaging.instance.subscribeToTopic(topic);

      if (HighQNotifications.enableLogs && kDebugMode) {
        if (kDebugMode) {
          print('Successfully subscribed to topic: $topic');
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Failed to subscribe to topic $topic: $e\n$stack');
      }
      rethrow;
    }
  }

  static Future<void> _unsubscribeFromTopic({required String topic}) async {
    try {
      if (topic.isEmpty) {
        throw ArgumentError('Topic cannot be empty');
      }

      if (HighQNotifications.enableLogs && kDebugMode) {
        if (kDebugMode) {
          print('Unsubscribing from topic: $topic');
        }
      }

      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);

      if (HighQNotifications.enableLogs && kDebugMode) {
        if (kDebugMode) {
          print('Successfully unsubscribed from topic: $topic');
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Failed to unsubscribe from topic $topic: $e\n$stack');
      }
      rethrow;
    }
  }

  static Future<void> _subscribeToTopics({required List<String> topics}) async {
    try {
      if (topics.isEmpty) {
        throw ArgumentError('Topics list cannot be empty');
      }

      if (HighQNotifications.enableLogs && kDebugMode) {
        if (kDebugMode) {
          print('Subscribing to topics: $topics');
        }
      }

      await Future.wait(topics.map((topic) => _subscribeToTopic(topic: topic)));

      if (HighQNotifications.enableLogs && kDebugMode) {
        if (kDebugMode) {
          print('Successfully subscribed to topics: $topics');
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Failed to subscribe to topics $topics: $e\n$stack');
      }
      rethrow;
    }
  }

  static Future<void> _unsubscribeFromTopics({
    required List<String> topics,
  }) async {
    try {
      if (topics.isEmpty) {
        throw ArgumentError('Topics list cannot be empty');
      }

      if (HighQNotifications.enableLogs && kDebugMode) {
        if (kDebugMode) {
          print('Unsubscribing from topics: $topics');
        }
      }

      await Future.wait(
        topics.map((topic) => _unsubscribeFromTopic(topic: topic)),
      );

      if (HighQNotifications.enableLogs && kDebugMode) {
        if (kDebugMode) {
          print('Successfully unsubscribed from topics: $topics');
        }
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Failed to unsubscribe from topics $topics: $e\n$stack');
      }
      rethrow;
    }
  }

  void _initVariables() {
    _onFCMTokenInitialize = widget.onFcmTokenInitialize;
    _onFCMTokenUpdate = widget.onFcmTokenUpdate;

    _androidConfig =
        widget.localNotificationsConfiguration.androidConfig ??
        AndroidConfigModel();
    _iosConfig =
        widget.localNotificationsConfiguration.iosConfig ?? IosConfigModel();

    _onTap = widget.onTap;
    _onAction = widget.onAction;
    _onOpenNotificationArrive = widget.onOpenNotificationArrive;

    _messageModifier = widget.messageModifier == null
        ? null
        : (msg) {
            final newMessage = widget.messageModifier!(msg);

            if (kDebugMode) {
              print('Message modified: $newMessage');
            }

            return newMessage;
          };

    _shouldHandleNotification = widget.shouldHandleNotification;

    _notificationIdGetter =
        widget.localNotificationsConfiguration.notificationIdGetter ??
        (_) => DateTime.now().hashCode;
  }

  void _deactivate() {
    _fcmToken = null;

    _onFCMTokenInitialize = null;
    _onFCMTokenUpdate = null;
    _androidConfig = null;
    _iosConfig = null;
    _onTap = null;
    _onOpenNotificationArrive = null;
    _messageModifier = null;
    _shouldHandleNotification = null;
    _notificationIdGetter = null;

    _fcmTokenStreamSubscription?.cancel();
    _fcmTokenStreamSubscription = null;

    _onMessageSubscription?.cancel();
    _onMessageSubscription = null;

    _onMessageOpenedAppSubscription?.cancel();
    _onMessageOpenedAppSubscription = null;

    _handledNotifications.clear();

    _flutterLocalNotificationsPlugin = null;
  }

  @override
  void initState() {
    _initVariables();

    /// _handledNotifications used to prevent
    /// multiple calls to the same notification.
    void onMessageListener(RemoteMessage msg) {
      if (msg.messageId == null) return;

      if (_handledNotifications.contains(msg.messageId)) return;

      _handledNotifications.add(msg.messageId!);

      _onMessage(msg);
    }

    /// Registering the listeners
    _onMessageSubscription = FirebaseMessaging.onMessage.listen(
      onMessageListener,
    );
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen(_onMessageOpenedApp);

    (() async {
      if (widget.requestPermissionsOnInitialize) {
        await (widget.permissionGetter?.call(_fcm) ?? _fcm.requestPermission());
      }

      try {
        _fcmToken = await initializeFcmToken(vapidKey: widget.vapidKey);
      } catch (e, s) {
        if (kDebugMode) {
          print(
            'Error:$e'
            'StackTrace:$s',
          );
        }
      }

      if (widget.handleInitialMessage) {
        final initialMessage = await getInitialMessage();

        if (initialMessage != null) {
          myBackgroundMessageHandler(initialMessage);
        }
      } else {
        await _initializeLocalNotifications();
      }
    })();

    super.initState();
  }

  @override
  void deactivate() {
    _deactivate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
