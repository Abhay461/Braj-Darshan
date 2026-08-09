import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../config/constants.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: const Duration(seconds: 35),
            receiveTimeout: const Duration(seconds: 35),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint('🌐 HTTP Request: ${options.method} ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('✅ HTTP Response [${response.statusCode}]: ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (kDebugMode) {
            debugPrint('❌ HTTP Error [${error.response?.statusCode}]: ${error.requestOptions.uri} - ${error.message}');
          }

          // Render free tier cold-start auto-retry (if timeout and hasn't been retried yet)
          if ((error.type == DioExceptionType.connectionTimeout ||
                  error.type == DioExceptionType.receiveTimeout ||
                  error.type == DioExceptionType.sendTimeout) &&
              error.requestOptions.extra['retried'] != true) {
            if (kDebugMode) {
              debugPrint('🔄 Retrying request after cold start timeout: ${error.requestOptions.uri}');
            }
            try {
              final options = error.requestOptions;
              options.extra['retried'] = true;
              final response = await dio.fetch(options);
              return handler.resolve(response);
            } catch (retryError) {
              if (retryError is DioException) {
                return handler.next(retryError);
              }
            }
          }

          return handler.next(error);
        },
      ),
    );
    // SSL Pinning - validate server certificate against pinned SHA-256 hash
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          const String expectedPin = 'BB7Exp9mdxl7TvHAZ0IRZPSyadon8vUwKSyruwUfwbE='; // Production pin
          final digest = sha256.convert(cert.der);
          final pin = base64Encode(digest.bytes);
          return pin == expectedPin;
        };
        return client;
      },
    );
  }
}


