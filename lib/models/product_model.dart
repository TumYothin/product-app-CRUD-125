import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.id,
    this.productName,
    this.price,
    this.productType,
  });

  int? id;
  String? productName;
  int? price;
  int? productType;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        productName: json["productName"],
        price: json["price"],
        productType: json["productType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productName": productName,
        "price": price,
        "productType": productType,
      };
}
