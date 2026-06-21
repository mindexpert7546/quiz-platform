import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: AppConfig.connectTimeoutSeconds),
  ));

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConfig.authTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }));

  return dio;
});
