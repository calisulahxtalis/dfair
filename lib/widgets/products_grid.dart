import 'package:flutter/material.dart';
import 'package:dsg/providers/product.dart';
import 'package:dsg/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:dsg/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (_, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}