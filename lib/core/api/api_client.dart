import 'package:dio/dio.dart';

class ApiClient {
  static const baseUrl = 'https://api.devshow.yashgaurkar.me';

  final Dio dio;

  ApiClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Accept': 'application/json',
            },
          ),
        );
}
