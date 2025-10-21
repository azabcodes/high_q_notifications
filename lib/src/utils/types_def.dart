import 'dart:typed_data';
import 'dart:ui';
import '../../high_q_notifications.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart' hide AndroidNotificationPriority;

typedef OnTapGetter = void Function(HighQNotificationInfoModel details);
typedef OnActionGetter = void Function(NotificationResponse response, RemoteMessage message);
typedef OnOpenNotificationArrive = void Function(HighQNotificationInfoModel);
typedef AndroidActionsGetter = List<AndroidNotificationAction> Function(RemoteMessage message);
typedef IosCategoryGetter = List<DarwinNotificationCategory> Function(RemoteMessage message);
typedef FcmInitializeGetter = void Function(String?);
typedef FcmUpdateGetter = void Function(String);
typedef NotificationIdGetter = int Function(RemoteMessage);
typedef NullableIntGetter = int? Function(RemoteMessage);
typedef NullableStringGetter = String? Function(RemoteMessage);
typedef StringGetter = String Function(RemoteMessage);
typedef BoolGetter = bool Function(RemoteMessage);
typedef AndroidFlagGetter = List<HighQAndroidNotificationFlag> Function(RemoteMessage);
typedef RemoteMessageGetter = RemoteMessage Function(RemoteMessage);
typedef NullableColorGetter = Color? Function(RemoteMessage);
typedef IosInterruptionLevelGetter = InterruptionLevel? Function(RemoteMessage);
typedef IosNotificationAttachmentClippingRectGetter = DarwinNotificationAttachmentThumbnailClippingRect? Function(RemoteMessage);
typedef DioEither<T> = Either<HighQFailure, Response<dynamic>>;
typedef FutureEither<T> = Future<Either<HighQFailure, T>>;
typedef AndroidImportanceGetter = Importance Function(RemoteMessage);
typedef AndroidPriorityGetter = Priority Function(RemoteMessage);
typedef GroupAlertBehaviorGetter = GroupAlertBehavior Function(RemoteMessage);
typedef AndroidNotificationChannelActionGetter = AndroidNotificationChannelAction Function(RemoteMessage);
typedef NotificationVisibilityGetter = NotificationVisibility? Function(RemoteMessage);
typedef AndroidNotificationCategoryGetter = AndroidNotificationCategory? Function(RemoteMessage);
typedef AudioAttributesUsageGetter = AudioAttributesUsage Function(RemoteMessage);
typedef NullableInt64ListGetter = Int64List? Function(RemoteMessage);
typedef IntGetter = int Function(RemoteMessage);
/*typedef AndroidImportanceGetter =HighQNotificationsImportance Function(RemoteMessage);
typedef AndroidPriorityGetter =HighQNotificationsPriority Function(RemoteMessage message);*/
