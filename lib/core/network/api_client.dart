import 'package:dio/dio.dart';
import 'package:docu_mind/core/config/api_config.dart';

/// Creates and configures the Dio HTTP client.
///
/// NOTE: The backend at ApiConfig.baseUrl must have CORS headers configured
/// for web builds to work. If you see OPTIONS requests failing, the server
/// needs Access-Control-Allow-Origin, Access-Control-Allow-Methods, etc.
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
