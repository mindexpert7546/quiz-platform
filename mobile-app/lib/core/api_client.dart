import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dioProvider = Provider<Dio>((ref) {
  // Replace 'localhost' with your machine IP when running on a real device.
  // Current host IP detected on this machine: 10.54.208.25
  final dio = Dio(BaseOptions(baseUrl: 'http://10.54.208.25:8080/api', connectTimeout: const Duration(seconds: 12)));
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('student_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }));
  return dio;
});
