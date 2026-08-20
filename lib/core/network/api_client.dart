import 'package:dio/dio.dart';
import 'package:docu_mind/core/config/api_config.dart';

/// Creates and configures the Dio HTTP client.
class ApiClient {
  ApiClient._();

  static Dio get instance {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Request/Response logging interceptor
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    return dio;
  }
}
