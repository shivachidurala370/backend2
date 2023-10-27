//import 'dart:html';
import 'dart:io';

import 'package:backend2/models/products_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

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

  // @override
  void initState() {
    // TODO: implement initState
    productsData();
  }

  Future<void> addproductsData() async {
    setState(() {
      _fetching = true;
    });
    try {
      final response = await homeManager.addproductsData();
      // setState(() {
      //   _fetching = false;
      // });

      print("==================================)");

      // if (response.status == ResponseStatus.SUCCESS) {
      if (response.status == ResponseStatus.SUCCESS) {
        //Fluttertoast.showToast(msg: response.message);

        //print((response.data as ProductsListModel).toJson());

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

  File? image;

  void pickImage(ImageSource source) async {
    try {
      final pickerFile = await ImagePicker().pickImage(source: source);
      setState(() {
        image = File(pickerFile!.path);
      });
    } catch (e) {
      print(e);
    }

    final TextEditingController _productnamecontroller =
        TextEditingController();
    final TextEditingController _descriptioncontroller =
        TextEditingController();

    void addProducts() async {
      String productName = _productnamecontroller.text.trim();
      String description = _descriptioncontroller.text.trim();

      final formdata = FormData.fromMap({
        "product_name": productName,
        "description": description,
        "image": await MultipartFile.fromFile(image!.path),
      });

      @override
      Widget build(BuildContext context) {
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  TextField(
                    controller: _productnamecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter the product name",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _descriptioncontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter the product name",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Select a image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  image != null
                      ? SizedBox(
                          height: 120,
                          width: 120,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              )),
                        )
                      : SizedBox(
                          height: 20,
                        ),
                  TextButton(
                      onPressed: () {
                        addProducts();
                      },
                      child: Text("Add Product")),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
}
