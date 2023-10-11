import 'package:dio/dio.dart';
// import 'package:farm_robo_service_app/authentications/managers/auth_manager.dart';
// import 'package:farm_robo_service_app/network_calls/base_response.dart';
// import 'package:farm_robo_service_app/utils/storage_keys.dart';
// import 'package:farm_robo_service_app/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/storagekeys.dart';
import '../classes/urls.dart';
import '../manager/auth_manager.dart';
import 'base_response.dart';

class DioClient {
  factory DioClient() {
    return _singleton;
  }

  DioClient._internal() {
    init();
  }

  static final DioClient _singleton = DioClient._internal();

  Dio? _dio;
  Dio? _tokenDio;

  static SharedPreferences? prefs;

  int authFailCount = 0;

  String token = "";

  Future<String> _getAuthorizationToken() async {
    prefs ??= await SharedPreferences.getInstance();
    token = prefs?.getString(StorageKeys.token) ?? "";
    print(token);
    return token;
  }

  String getAuthorizationToken() {
    return token;
  }

  dynamic init() {
    _dio = Dio();
    _dio!.options = BaseOptions(
        validateStatus: (status) => status! < 500, baseUrl: URLS.baseUrl);
    // Used to get token
    _tokenDio = Dio();
    _tokenDio!.options = BaseOptions(
      validateStatus: (status) => status! < 500,
      baseUrl: URLS.baseUrl,
    );
    _tokenDio!.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        return handler.next(options);
      }, onResponse: (response, handler) async {
        debugPrint(response.realUri.toString());
        debugPrint(response.statusCode.toString());
        return handler.next(response);
      }, onError: (error, handler) {
        debugPrint(error.response?.realUri.toString());
        debugPrint(error.response?.statusCode.toString());
        return handler.next(error);
      }),
    );

    _dio!.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await _getAuthorizationToken();
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      return handler.next(options);
    }, onResponse: (response, handler) async {
      // Do something with response data
      // TODO: Remove Print Statements
      debugPrint(response.realUri.toString());
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 401) {
        // _dio.interceptors.requestLock.lock();
        // _dio.interceptors.responseLock.lock();
        final options = response.requestOptions;

        final fetchStatus = await authManager.refreshToken();

        if (fetchStatus.status != ResponseStatus.SUCCESS) {
          authManager.logout();
          return handler.resolve(response);
        }

        options.headers["Authorization"] =
            "Bearer ${await _getAuthorizationToken()}";

        // _dio.interceptors.requestLock.unlock();
        // _dio.interceptors.responseLock.unlock();

        if (options.data is FormData) {
          final formData = FormData();
          formData.fields.addAll(options.data.fields);
          options.data = formData;
        }

        final Response responses = await _dio!.fetch(options);

        return handler.resolve(responses);
      } else {
        return handler.resolve(response);
      }
    }, onError: (error, handler) async {
      // TODO: Remove Print Statements
      debugPrint('Error');
      debugPrint(error.response?.realUri.toString());
      debugPrint(error.response?.data.toString());
      debugPrint(error.response?.statusCode?.toString() ?? '');

      if (error.response?.statusCode == 401) {
        final options = error.response!.requestOptions;

        final fetchStatus = await authManager.refreshToken();

        if (fetchStatus.status != ResponseStatus.SUCCESS) {
          authManager.logout();
          return handler.resolve(error.response!);
        }

        options.headers["Authorization"] =
            "Bearer ${await _getAuthorizationToken()}";

        if (options.data is FormData) {
          final formData = FormData();
          formData.fields.addAll(options.data.fields);
          options.data = formData;
        }

        final Response responses = await _dio!.fetch(options);

        return handler.resolve(responses);
      } else {
        return handler.reject(error);
      }
    }));
  }

  Dio? get ref => _dio;

  Dio? get tokenRef => _tokenDio;
}

final dioClient = DioClient();
