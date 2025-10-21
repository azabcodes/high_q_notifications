import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../high_q_notifications.dart';

final GetIt highQSl = GetIt.instance;

class HighQServicesLocator {
  static Future<void> init() async {
    if (!highQSl.isRegistered<Dio>()) {
      highQSl.registerLazySingleton<Dio>(() => Dio());
    }

    if (!highQSl.isRegistered<HighQApiClient>()) {
      highQSl.registerLazySingleton<HighQApiClient>(() => HighQApiClient(client: highQSl()));
    }
  }
}

