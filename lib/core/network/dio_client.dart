import 'package:dio/dio.dart';

//Timeout and generic logging
class DioClient {
  DioClient._();

  static Dio create(){
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        sendTimeout:  const Duration(minutes: 2),
        receiveTimeout: const Duration(seconds: 20)
      )
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: true,
        logPrint: (obj){
          print(obj);
        }
      ),
    );
    return dio;
  }
}