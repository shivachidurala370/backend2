//import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';

class URLS {
  static String baseUrl = "http://jayanthi10.pythonanywhere.com";

  //static String baseUrl = "http://jayanthi10.pythonanywhere.com";
  static String login = "/api/v1/login/";
  static String verifyOTP = "/api/v1/accounts/verify_otp/";
  static String resendOTP = "/api/v1/accounts/resend_otp/";
  static String tokenRefresh = "/api/v1/accounts/token_refresh/";
  static String products = "/api/v1/list_products/";
  static String addproducts = "/api/v1/add_products/";

  static String parseImage(String? url) {
    if (url == null) return "";
    // return  url;
    return baseUrl + url;
  }
}

class stateless extends StatelessWidget {
  const stateless({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
