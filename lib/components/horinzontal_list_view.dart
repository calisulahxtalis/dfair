import 'package:dsg/models/category_model.dart';
import 'package:dsg/pages/products_by_category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HorinzontalList extends StatefulWidget {
  @override
  _HorinzontalListState createState() => _HorinzontalListState();
}

class _HorinzontalListState extends State<HorinzontalList> {
  List catList;

  Future getCategories() async {
    http.Response response =
        await http.get("https://dfair.herokuapp.com/api/shop/categories/");
    final data = json.decode(response.body);
    final categories = <CategoryModel>[];
    for (var item in data) {
      final category = CategoryModel(
          id: item['id'],
          name: item['name'],
          image: item['image'],
          products: item['products']);
      categories.add(category);
    }
    print(data);
    setState(() {
      catList = categories;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    if (catList == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: catList == null ? 0 : catList.length,
          itemBuilder: (BuildContext context, int index) {
            return Category(
              imageCaption: catList[index].name,
              imageLocation: catList[index].image == null
                  ? "https://www.freeiconspng.com/thumbs/no-image-icon/no-image-icon-6.png"
                  : catList[index].image,
              numProd: catList[index].products,
              id: catList[index].id,
            );
          },
        ),
      );
    }
  }
}

class Category extends StatefulWidget {
  final String imageLocation;
  final String imageCaption;
  final List numProd;
  final int id;

  Category({this.imageLocation, this.imageCaption, this.numProd, this.id});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductsByCategory(
                catID: widget.id,
                catName: widget.imageCaption,
                catNum: widget.numProd.length,
              ),
            ),
          );
        },
        child: Container(
          width: 100,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            image: DecorationImage(
                image: NetworkImage(widget.imageLocation), fit: BoxFit.contain),
          ),
          child: Container(
            width: 100,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 0, 0, .3),
                  Color.fromRGBO(0, 0, 0, .0),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 105.0),
              child: Text(
                "${widget.imageCaption}",
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
