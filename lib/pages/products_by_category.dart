import 'dart:async';
import 'dart:convert';

import 'package:dsg/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsByCategory extends StatefulWidget {
  final int catID;
  final String catName;
  final int catNum;
  ProductsByCategory({
    @required this.catID,
    @required this.catName,
    @required this.catNum,
  });
  @override
  _ProductsByCategoryState createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  List prodList;

  Future getProducts() async {
    http.Response response =
        await http.get("https://dfair.herokuapp.com/api/shop/products/");

    final data = json.decode(response.body);
    final products = <Product>[];
    List filteredList;
    for (var item in data) {
      final product = Product(
          id: item['id'],
          name: item['name'],
          price: item['price'],
          image: item['image'],
          category: item['category']);
      products.add(product);
      Iterable<Product> iterable = products.where((item) {
        print('Filtering initiated');
        return item.category == widget.catID;
      });
      filteredList = iterable.toList();
      print(filteredList);
    }
    print(data);
    setState(() {
      prodList = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.2,
        backgroundColor: Colors.purple,
        title: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/home');
          },
          child: Text("${widget.catName}"),
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: (prodList == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: GridView.builder(
                itemCount: prodList == null ? 0 : prodList.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return SingleProd(
                    prodID: prodList[index].id,
                    prodName: prodList[index].name,
                    prodPicture: NetworkImage(prodList[index].image),
                    prodOldPrice: prodList[index].price,
                    prodPrice: prodList[index].price,
                  );
                },
              ),
            ),
    );
  }
}

class SingleProd extends StatelessWidget {
  final prodID;
  final prodName;
  final prodPicture;
  final prodOldPrice;
  final prodPrice;

  SingleProd({
    this.prodID,
    this.prodName,
    this.prodPicture,
    this.prodOldPrice,
    this.prodPrice,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Hero(
        tag: new Text("Hero 1"),
        child: Material(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/details', arguments: prodID);
            },
            child: GridTile(
                footer: Container(
                  height: 40.0,
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: new Text(
                            prodName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                        new Text(
                          "\$$prodPrice",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                child: Image(
                  image: prodPicture,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
