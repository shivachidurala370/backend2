import 'package:backend2/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'manager/home_manager.dart';
import 'network calls/base_response.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  ProductsListModel? products;
  bool _fetching = false;

  Future<void> productsData() async {
    setState(() {
      _fetching = true;
    });
    try {
      final response = await homeManager.productsData();
      // setState(() {
      //   _fetching = false;
      // });

      print("==================================)");

      // if (response.status == ResponseStatus.SUCCESS) {
      if (response.status == ResponseStatus.SUCCESS) {
        //Fluttertoast.showToast(msg: response.message);

        print((response.data as ProductsListModel).toJson());

        setState(() {
          products = response.data;
        });
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    } catch (err) {
      print(err);
      setState(() {
        _fetching = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    productsData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                "Home Page",
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
