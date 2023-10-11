import 'dart:convert';
import 'package:dio/dio.dart';

import '../classes/urls.dart';
import '../models/products_model.dart';
import '../network calls/base_network.dart';
import '../network calls/base_response.dart';
// import 'package:farm_robo_service_app/home/models/available_services_model.dart';
// import 'package:farm_robo_service_app/home/models/carousel_list_model.dart';
// import 'package:farm_robo_service_app/home/models/frequent_services_model.dart';
// import 'package:farm_robo_service_app/home/models/our_crops_model.dart';
// import 'package:farm_robo_service_app/home/models/services_list_model.dart';
// import 'package:farm_robo_service_app/home/models/testimonials_list_model.dart';
// import 'package:farm_robo_service_app/network_calls/base_networks.dart';
// import 'package:farm_robo_service_app/network_calls/base_response.dart';
// import 'package:farm_robo_service_app/utils/urls.dart';

class HomeManager {
  factory HomeManager() {
    return _singleton;
  }

  HomeManager._internal();

  static final HomeManager _singleton = HomeManager._internal();

  Future<ResponseData> productsData() async {
    Response response;
    try {
      response = await dioClient.ref!.get<dynamic>(URLS.products);
      print("services data ----> ${response.data}");

      if (response.statusCode == 200) {
        print("services data is ----> ${response.data}");

        final services = productsListModelFromJson(jsonEncode(response.data));

        //final products = ProductsListModel.fromJson(response.data);
        // final products = productsListModelFromJson(response.data);

        print("services data are ----> ${response.data}");

        return ResponseData("success", ResponseStatus.SUCCESS, data: services);
      } else {
        var message = "Unknown error";
        if (response.data?.containsKey("message") == true) {
          message = response.data['message'];
        }
        return ResponseData(message, ResponseStatus.FAILED);
      }
    } on Exception catch (err) {
      print(err);
      var msg = ParseError.parse(err);
      return ResponseData<dynamic>(
          "Something Server Problem", ResponseStatus.FAILED);
    }
  }
}

HomeManager homeManager = HomeManager();
