//import 'dart:html';
//import 'dart:html';
import 'dart:io';

import 'package:backend2/classes/urls.dart';
import 'package:backend2/home_screen.dart';
import 'package:backend2/manager/home_manager.dart';
import 'package:backend2/network%20calls/base_network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Addproducts extends StatefulWidget {
  const Addproducts({super.key});

  @override
  State<Addproducts> createState() => _AddproductsState();
}

class _AddproductsState extends State<Addproducts> {
  final TextEditingController _productnamecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  void addproducts() async {
    String productName = _productnamecontroller.text.trim();
    String description = _descriptioncontroller.text.trim();

    final formdata = FormData.fromMap({
      "product_name": productName,
      "description": description,
      "image": await MultipartFile.fromFile(image!.path),
    });
    try {
      final response = await homeManager.addproductsData(formdata);
      print(response.data);
      if (response.status == 200) {
        print("==========Response after Success${response.data}");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homescreen()));
      }
    } catch (e) {
      print("===============================================>Error");
      print(e);
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Add Products",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFffffff)),
          ),
          centerTitle: true,
          leading: Icon(
            Icons.arrow_back,
            size: 20,
            color: Color(0xFFffffff),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _productnamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter Product name"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descriptioncontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Description"),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => pickImage(ImageSource.gallery),
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Select a image",
                    style: TextStyle(color: Colors.black),
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
                  :
                  // Container(
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: Colors.red,
                  //     image: DecorationImage(
                  //       image: NetworkImage(''),
                  //       fit: BoxFit.cover, // optional
                  //     ),
                  //   ),
                  //   height: 120,
                  //   width: 150,
                  // ),
                  SizedBox(
                      height: 20,
                    ),
              TextButton(
                  onPressed: () {
                    addproducts();
                  },
                  child: Text("Add Product")),
            ],
          ),
        ),
      ),
    );
  }
}
