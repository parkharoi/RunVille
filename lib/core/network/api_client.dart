import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:run_ville/core/config/env.dart';

final Logger _logger = Logger();

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<String> healthCheck() async {
    final Response<dynamic> response = await _dio.get<dynamic>('/todos/1');
    return response.statusCode == 200 ? 'ok' : 'failed';
  }
}

Dio buildDioClient() {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('[REQ] ${options.method} ${options.baseUrl}${options.path}');
        handler.next(options);
      },
      onError: (error, handler) {
        _logger.e('[ERR] ${error.requestOptions.path}', error: error);
        handler.next(error);
      },
    ),
  );

  return dio;
}
