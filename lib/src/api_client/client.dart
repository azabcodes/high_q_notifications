import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../high_q_notifications.dart';

class ApiClient extends BaseClient {
  final Dio client;

  ApiClient({required this.client}) {
    if (!kIsWeb) {
      _setupHttpClientAdapter();
    }

    _setupClientOptions();
    _setupInterceptors();
  }

  void _setupHttpClientAdapter() {
    (client.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback = (_, __, ___) => true;
      return httpClient;
    };
  }

  void _setupClientOptions() {
    client.options
      ..receiveTimeout = Duration(seconds: 25)
      ..responseType = ResponseType.json
      ..followRedirects = false;
  }

  void _setupInterceptors() {
    client.interceptors.addAll([]);
  }

  @override
  FutureEither<Response> get({
    required String endPoint,
    Object? body,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    void Function(int count, int total)? onReceiveProgress,
  }) async {
    try {
      final response = await client.get(
        endPoint,
        data: body,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return Right(response);
    } on DioException catch (error) {
      throw Exception(error);
    } catch (error) {
      final errorMessage = error is Exception
          ? error.toString()
          : "An unexpected error occurred";
      return Left(ApiFailure(message: errorMessage));
    }
  }
}
