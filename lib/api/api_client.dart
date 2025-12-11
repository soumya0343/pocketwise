// lib/api/api_client.dart
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:dio/dio.dart';

class ApiClient {
  // For Android emulator use 10.0.2.2 -> host machine
  // For iOS simulator use localhost
  // For physical device use your machine IP (e.g. http://192.168.1.42:4000)
  String get baseUrl {
    // Temporarily hardcoded for iOS simulator - change back to platform detection after testing
    // For iOS simulator, use 127.0.0.1 (sometimes localhost doesn't resolve correctly)
    // For Android emulator, use http://10.0.2.2:4000
    return 'http://127.0.0.1:4000';

    // Original platform detection code (uncomment after verifying it works):
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   return 'http://10.0.2.2:4000';
    // } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   return 'http://localhost:4000';
    // } else {
    //   return 'http://localhost:4000';
    // }
  }

  late final Dio _dio;

  ApiClient() {
    print('[ApiClient] ========== PLATFORM DETECTION ==========');
    print('[ApiClient] defaultTargetPlatform: $defaultTargetPlatform');
    print('[ApiClient] TargetPlatform.android: ${TargetPlatform.android}');
    print('[ApiClient] TargetPlatform.iOS: ${TargetPlatform.iOS}');
    print(
      '[ApiClient] Is Android: ${defaultTargetPlatform == TargetPlatform.android}',
    );
    print('[ApiClient] Is iOS: ${defaultTargetPlatform == TargetPlatform.iOS}');
    print('[ApiClient] baseUrl getter will return: $baseUrl');
    print('[ApiClient] ========================================');

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    print(
      '[ApiClient] Dio instance created with baseUrl: ${_dio.options.baseUrl}',
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    print('[ApiClient.get] Making request to: ${_dio.options.baseUrl}$path');
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }
}
