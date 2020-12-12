import 'package:flutter/material.dart';

class ProductDetail {
  String name;
  String image;
  double price;
  double id;
  String description;

  ProductDetail({
    this.name,
    this.description,
    this.price,
    this.image,
    this.id,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> item) {
    return ProductDetail(
            id: item['id'],
            name: item['name'],
            description: item['description'],
            price: item['price'],
            image: item['image'],
      );
  }
}