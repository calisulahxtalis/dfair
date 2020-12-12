import 'dart:convert';

import 'package:dsg/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:dsg/components/http_exception.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  Products(this._items);

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Product findById(int id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchProducts() async {
    var url = "https://dfair.herokuapp.com/api/shop/products/";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData != null) {
        extractedData.forEach((key, product) {
          loadedProducts.add(Product(
              id: product['id'],
              name: product['name'],
              price: product['price'],
              image: product['image'],
              description: product['description']));
        });
        _items = loadedProducts;
        notifyListeners();
      }
    } catch (exception) {
      print("CODE ERROR: " + exception.toString());
      throw exception;
    }
  }
}
