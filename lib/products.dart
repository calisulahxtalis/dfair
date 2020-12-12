import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  final List prodList;
  final List searchList;
  final List cartList;
  final TextEditingController tcontroller;
  Products({
    @required this.prodList,
    this.searchList,
    this.tcontroller,
    this.cartList,
  });
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List _products;
  List _search = [];
  TextEditingController _controller;
  List _cartList;

  @override
  void initState() {
    super.initState();
    _products = widget.prodList;
    _search = widget.searchList;
    _controller = widget.tcontroller;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.builder(
        itemCount: _products == null ? 0 : _products.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return SingleProd(
            prodID: _products[index].id,
            prodName: _products[index].name,
            prodPicture: NetworkImage(_products[index].image),
            prodOldPrice: _products[index].price,
            prodPrice: _products[index].price,
          );
        },
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
                              color: Colors.purple, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    
                  ),
                ),
                child: Image(
                  image: prodPicture,
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ),
    );
  }
}
