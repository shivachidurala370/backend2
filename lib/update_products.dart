//import 'dart:html';
import 'dart:io';

import 'package:backend2/home_screen.dart';
import 'package:backend2/manager/home_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'network calls/base_response.dart';

class Updateproducts extends StatefulWidget {
  const Updateproducts({super.key});

  @override
  State<Updateproducts> createState() => _UpdateproductsState();
}

class _UpdateproductsState extends State<Updateproducts> {
  final TextEditingController _productidcontroller = TextEditingController();
  final TextEditingController _productnamecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();

  void updateproducts() async {
    String id = _productidcontroller.text.trim();
    String productName = _productnamecontroller.text.trim();
    String description = _descriptioncontroller.text.trim();

    final formdata = FormData.fromMap({
      "product_id": id,
      "product_name": productName,
      "description": description,
      "image": await MultipartFile.fromFile(image!.path),
    });
    try {
      final response = await homeManager.updateproductsdata(formdata);
      print(response.data);
      if (response.status == ResponseStatus.SUCCESS) {
        print("==========Response after Success${response.data}");
        setState(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homescreen()));
        });
      }
    } catch (e) {
      print("======================> Error");
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF000000),
        title: Text(
          "Update Products",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFFffffff)),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homescreen()));
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              TextField(
                controller: _productidcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Product id"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _productnamecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Product name"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descriptioncontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "description"),
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
                  : SizedBox(
                      height: 20,
                    ),
              TextButton(
                  onPressed: () {
                    updateproducts();
                  },
                  child: Text("Update Product"))
            ],
          ),
        ),
      ),
    );
  }
}
