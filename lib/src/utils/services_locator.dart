import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../high_q_notifications.dart';

final GetIt sl = GetIt.instance;

class ServicesLocator {
  static Future<void> init() async {
    if (!sl.isRegistered<Dio>()) {
      sl.registerLazySingleton<Dio>(() => Dio());
    }

    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(() => ApiClient(client: sl()));
    }
  }
}

