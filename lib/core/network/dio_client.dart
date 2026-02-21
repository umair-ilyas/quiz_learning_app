import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.triviaBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        // NOTE: Do NOT set Content-Type for GET requests — this triggers
        // a CORS preflight (OPTIONS) that opentdb.com does not support,
        // causing XMLHttpRequest connection errors on Flutter Web.
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (log) => debugPrint(log.toString()),
      ),
    );

    return dio;
  }
}

void debugPrint(String message) {
  // ignore: avoid_print
  print('[DioClient] $message');
}
