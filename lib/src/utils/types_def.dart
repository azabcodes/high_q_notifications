import 'dart:ui';
import '../../high_q_notifications.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart' hide AndroidNotificationPriority;

typedef OnTapGetter = void Function(NotificationInfoModel details);
typedef OnActionGetter =
    void Function(NotificationResponse response, RemoteMessage message);

typedef OnOpenNotificationArrive = void Function(NotificationInfoModel);

typedef FcmInitializeGetter = void Function(String?);
typedef FcmUpdateGetter = void Function(String);
typedef NotificationIdGetter = int Function(RemoteMessage);

typedef NullableIntGetter = int? Function(RemoteMessage);
typedef NullableStringGetter = String? Function(RemoteMessage);
typedef StringGetter = String Function(RemoteMessage);
typedef BoolGetter = bool Function(RemoteMessage);
typedef RemoteMessageGetter = RemoteMessage Function(RemoteMessage);
typedef NullableColorGetter = Color? Function(RemoteMessage);

typedef IosInterruptionLevelGetter = InterruptionLevel? Function(RemoteMessage);
typedef IosNotificationAttachmentClippingRectGetter =
    DarwinNotificationAttachmentThumbnailClippingRect? Function(RemoteMessage);
typedef DioEither<T> = Either<Failure, Response<dynamic>>;
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef AndroidImportanceGetter = Importance Function(RemoteMessage);
typedef AndroidPriorityGetter = Priority Function(RemoteMessage);

/*typedef AndroidImportanceGetter =HighQNotificationsImportance Function(RemoteMessage);
typedef AndroidPriorityGetter =HighQNotificationsPriority Function(RemoteMessage message);*/
