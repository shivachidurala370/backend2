//import 'dart:html';
import 'dart:io';

import 'package:backend2/add_products.dart';
import 'package:backend2/delete_products.dart';
import 'package:backend2/main.dart';
import 'package:backend2/models/products_model.dart';
import 'package:backend2/update_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  Productsmodel? products;
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

        print((response.data as Productsmodel).toJson());

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              "List Products",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFffffff)),
            ),
            centerTitle: true,
            leading: InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
              right: 16,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                products == null
                    ? CircularProgressIndicator()
                    : Container(
                        height: 300,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.all(20),
                                height: 200,
                                width: 280,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 4,
                                          color: Colors.grey.shade300)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              "http://jayanthi10.pythonanywhere.com/${products!.data![index].image}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      "${products!.data![index].productName}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF000000)),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "${products!.data![index].description}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                width: 24,
                              );
                            },
                            itemCount: products!.data!.length),
                      ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Addproducts()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    //width: 160,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Products",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFffffff),
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Updateproducts()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    //width: 160,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Update Products",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFffffff),
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeleteProduct()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    //width: 160,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Delete Products",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFffffff),
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

// return Container(
// padding: EdgeInsets.all(10),
// height: 100,
// width: 160,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(10),
// boxShadow: [
// BoxShadow(
// blurRadius: 6,
// color: Colors.grey.shade400)
// ],
// ),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Container(
// height: 100,
// width: 100,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// image: DecorationImage(
// image: CachedNetworkImageProvider(
// "http://jayanthi10.pythonanywhere.com/${products!.data![index].image}"),
// fit: BoxFit.cover),
// ),
// ),
// SizedBox(
// height: 10,
// ),
// Text(
// "${products!.data![index].productName}",
// style: TextStyle(
// fontSize: 14,
// fontWeight: FontWeight.w600,
// color: Color(0xFF000000)),
// ),
// SizedBox(
// height: 10,
// ),
// Text(
// "${products!.data![index].description}",
// style: TextStyle(
// fontSize: 12,
// fontWeight: FontWeight.w300,
// color: Color(0xFF676b6e)),
// ),
// ],
// ),
//);
