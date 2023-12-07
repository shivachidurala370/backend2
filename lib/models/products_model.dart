// To parse this JSON data, do
//
//     final productsmodel = productsmodelFromJson(jsonString);

import 'dart:convert';

Productsmodel productsmodelFromJson(String str) =>
    Productsmodel.fromJson(json.decode(str));

String productsmodelToJson(Productsmodel data) => json.encode(data.toJson());

class Productsmodel {
  List<Datum>? data;

  Productsmodel({
    this.data,
  });

  factory Productsmodel.fromJson(Map<String, dynamic> json) => Productsmodel(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? productId;
  String? productName;
  String? description;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.productId,
    this.productName,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json["product_id"],
        productName: json["product_name"],
        description: json["description"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "description": description,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
