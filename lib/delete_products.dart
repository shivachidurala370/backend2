import 'package:backend2/home_screen.dart';
import 'package:backend2/manager/home_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'network calls/base_response.dart';

class DeleteProduct extends StatefulWidget {
  const DeleteProduct({super.key});

  @override
  State<DeleteProduct> createState() => _DeleteProductState();
}

class _DeleteProductState extends State<DeleteProduct> {
  final TextEditingController _productidcontroller = TextEditingController();

  void deleteProduct() async {
    String productid = _productidcontroller.text.trim();

    final formdata = FormData.fromMap({
      "product_id": productid,
    });
    try {
      final response = await homeManager.deleteproductsdata(formdata);
      print(response.data);

      if (response.status == ResponseStatus.SUCCESS) {
        print("==========Response after Success${response.data}");
        setState(() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Homescreen()));
        });
      }
    } catch (e) {
      print("================> Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF000000),
          title: Text(
            "Delete Products",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFFffffff)),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Homescreen()));
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        body: Padding(
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
              TextButton(
                  onPressed: () {
                    deleteProduct();
                  },
                  child: Text("Delete Product"))
            ],
          ),
        ),
      ),
    );
  }
}
