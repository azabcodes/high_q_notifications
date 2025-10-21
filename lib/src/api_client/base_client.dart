
import 'package:dio/dio.dart';
import '../../high_q_notifications.dart';


abstract class HighQBaseClient {
  FutureEither<Response> get({
    required String endPoint,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int count, int total)? onReceiveProgress,
  });
}
