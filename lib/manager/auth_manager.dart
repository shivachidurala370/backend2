//import 'dart:convert';
import 'package:backend2/classes/urls.dart';
import 'package:dio/dio.dart';
// import 'package:farm_robo_service_app/misc/navigation_service.dart';
// import 'package:farm_robo_service_app/network_calls/base_networks.dart';
// import 'package:farm_robo_service_app/network_calls/base_response.dart';
// import 'package:farm_robo_service_app/splash_screen.dart';
// import 'package:farm_robo_service_app/utils/storage_keys.dart';
// import 'package:farm_robo_service_app/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/storagekeys.dart';
import '../network calls/base_network.dart';
import '../network calls/base_response.dart';

class AuthManager {
  factory AuthManager() {
    return _singleton;
  }

  AuthManager._internal();

  static final AuthManager _singleton = AuthManager._internal();

  // Future<ResponseData> performLogin(
  //   String? phone,
  // ) async {
  //   final formData = FormData.fromMap({
  //     // "phone_number": phone,
  //     "phone_number": phone,
  //     // "password":password,
  //     // "is_customer": true
  //   });
  //
  //   Response response;
  //   try {
  //     response =
  //         await dioClient.tokenRef!.post<dynamic>(URLS.login, data: formData);
  //
  //     if (response.statusCode == 200) {
  //       print("data of response is --${response.data}");
  //
  //       return ResponseData(response.data.toString(), ResponseStatus.SUCCESS);
  //     } else {
  //       String? message = "Unknown error";
  //       if (response.data?.containsKey("message") == true) {
  //         message = response.data['message'];
  //       }
  //       return ResponseData(message!, ResponseStatus.FAILED);
  //     }
  //   } on Exception catch (err) {
  //     return ResponseData<dynamic>(
  //         "Something Server Problem", ResponseStatus.FAILED);
  //   }
  // }

  Future<ResponseData> performlogin(String? username, String? password) async {
    final formData = FormData.fromMap({
      "username": username,
      "password": password,
    });
    final sharedPreferences = await SharedPreferences.getInstance();

    Response response;
    try {
      response =
          await dioClient.tokenRef!.post<dynamic>(URLS.login, data: formData);

      print("------response before success ${response.data}");

      if (response.statusCode == 200) {
        print("------response after success ${response.data}");
        sharedPreferences.setString(
            StorageKeys.token, response.data["data"]['access_token']);
        sharedPreferences.setString(
            StorageKeys.refreshToken, response.data["data"]['refresh_token']);
        //sharedPreferences.setInt(StorageKeys.userId, response.data["user_id"]);

        // sharedPreferences.setInt(StorageKeys.userNumber, response.data["phone_number"]);

        // sharedPreferences.setBool(StorageKeys.isB2B, response.data["is_B2B"]);
        // profileManager.fetchProfile();
        // FirebaseNotifications.updateFCM();
        return ResponseData(response.data.toString(), ResponseStatus.SUCCESS);
      } else {
        String? message = "Unknown error";
        if (response.data?.containsKey("message") == true) {
          message = response.data['message'];
        }
        return ResponseData(message!, ResponseStatus.FAILED);
      }
    } on Exception catch (err) {
      return ResponseData<dynamic>(
          "Something Server Problem", ResponseStatus.FAILED);
    }
  }

  Future<ResponseData> resendOTP(
    String? phone,
  ) async {
    final formData = FormData.fromMap({
      // "phone_number": phone,
      "phone_number": phone,
      // "password":password,
      // "is_customer": true
    });

    Response response;
    try {
      response = await dioClient.tokenRef!
          .post<dynamic>(URLS.resendOTP, data: formData);

      if (response.statusCode == 200) {
        print("data of response is --${response.data}");

        return ResponseData(response.data.toString(), ResponseStatus.SUCCESS);
      } else {
        String? message = "Unknown error";
        if (response.data?.containsKey("message") == true) {
          message = response.data['message'];
        }
        return ResponseData(message!, ResponseStatus.FAILED);
      }
    } on Exception catch (err) {
      return ResponseData<dynamic>(
          "Something Server Problem", ResponseStatus.FAILED);
    }
  }

  Future<ResponseData> refreshToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String refresh =
        sharedPreferences.getString(StorageKeys.refreshToken) ?? "";
    final formData = FormData.fromMap({
      "refresh": refresh,
    });

    Response response;
    try {
      response = await dioClient.tokenRef!
          .post<dynamic>(URLS.tokenRefresh, data: formData);

      if (response.statusCode == 200) {
        sharedPreferences.setString(StorageKeys.token, response.data["access"]);
        return ResponseData("", ResponseStatus.SUCCESS);
      } else {
        authManager?.logout();
        String? message = "Unknown error";
        if (response.data?.containsKey("message") == true) {
          message = response.data['message'];
        }
        return ResponseData(message!, ResponseStatus.FAILED);
      }
    } on Exception catch (err) {
      return ResponseData<dynamic>(err.toString(), ResponseStatus.FAILED);
    }
  }

  Future<void> logout() async {
    await (await SharedPreferences.getInstance()).clear();
    //NavigationService().navigatePage(SplashScreen());
  }
}

AuthManager authManager = AuthManager();
