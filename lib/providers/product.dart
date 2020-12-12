import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String name;
  final String image;
  final double price;
  final double id;
  final String description;

  Product({
    this.name,
    this.description,
    this.price,
    this.image,
    this.id,
  });
}