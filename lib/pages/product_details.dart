import 'dart:convert';
import 'package:dsg/main.dart';
import 'package:dsg/models/product_detail.dart';
import 'package:dsg/pages/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final int id;

  const ProductDetails({@required this.id});
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List _cartList = [];
  Map data;
  Map details;

  Future getDetails() async {
    http.Response response = await http
        .get('https://dfair.herokuapp.com/api/shop/product/${widget.id}/');
    data = json.decode(response.body);
    print(data.toString());
    setState(() {
      details = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  ProductDetail product;

  saveToCart(int user, String products) async {
    Map data = {
      'user': user,
      'products': products,
    };
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http.patch(
      "https://dfair.herokuapp.com/api/accounts/login/",
      body: data,
    );
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      setState(() {
        sharedPreferences.setString('token', jsonData['token']);
        print(sharedPreferences.getString('token'));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      });
    } else {
      print(response.statusCode);
      print(response.body);
    }
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
          child: Text("D-Fair Shop"),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 14.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 30.0,
                  ),
                  if (_cartList.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CircleAvatar(
                        radius: 6.0,
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        child: Text(
                          _cartList.length.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onTap: () {
                if (_cartList.isNotEmpty)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Cart(cartList: _cartList),
                    ),
                  );
              },
            ),
          )
        ],
      ),
      body: (details == null)
          ? new Center(child: CircularProgressIndicator())
          : new ListView(
              children: <Widget>[
                new Container(
                  height: 300.0,
                  child: GridTile(
                    child: Container(
                      color: Colors.white,
                      child: Image(
                        image: NetworkImage(details["image"]),
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
                      ),
                    ),
                    footer: new Container(
                      color: Colors.white70,
                      child: ListTile(
                        leading: new Text(
                          details["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        title: new Row(
                          children: <Widget>[
                            Expanded(
                              child: new Text(
                                "\$${details["price"]}",
                                style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ),
                            Expanded(
                              child: new Text(
                                "\$${details["price"]}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ======= The First Buttons =======
                Row(
                  children: [
                    // ======= The Size Button =======
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return new AlertDialog(
                                  title: new Text("Size"),
                                  content: Text("Choose the Size"),
                                  actions: <Widget>[
                                    new MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(context);
                                      },
                                      child: new Text("Close"),
                                    )
                                  ],
                                );
                              });
                        },
                        color: Colors.white,
                        textColor: Colors.grey,
                        elevation: 0.3,
                        child: Row(
                          children: [
                            Expanded(
                              child: new Text("Size"),
                            ),
                            Expanded(
                              child: new Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ======= The Color Button =======
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return new AlertDialog(
                                  title: new Text("Color"),
                                  content: Text("Choose the Color"),
                                  actions: <Widget>[
                                    new MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(context);
                                      },
                                      child: new Text("Close"),
                                    )
                                  ],
                                );
                              });
                        },
                        color: Colors.white,
                        textColor: Colors.grey,
                        elevation: 0.3,
                        child: Row(
                          children: [
                            Expanded(
                              child: new Text("Color"),
                            ),
                            Expanded(
                              child: new Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ======= The Quantity Button =======
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return new AlertDialog(
                                  title: new Text("Quantity"),
                                  content: Text("Choose the Quantity"),
                                  actions: <Widget>[
                                    new MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(context);
                                      },
                                      child: new Text("Close"),
                                    )
                                  ],
                                );
                              });
                        },
                        color: Colors.white,
                        textColor: Colors.grey,
                        elevation: 0.3,
                        child: Row(
                          children: [
                            Expanded(
                              child: new Text("Quantity"),
                            ),
                            Expanded(
                              child: new Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // ======= The Second Buttons =======
                Row(
                  children: <Widget>[
                    // ======= The buy Button =======
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {},
                        color: Colors.purple,
                        textColor: Colors.white,
                        elevation: 0.3,
                        child: new Text("Buy Now"),
                      ),
                    ),
                    new IconButton(
                      icon: (!_cartList.contains(details))
                          ? Icon(Icons.add_shopping_cart)
                          : Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.grey,
                            ),
                      onPressed: () {
                        setState(() {
                          if (!_cartList.contains(details))
                            _cartList.add(details);
                          else
                            _cartList.remove(details);
                        });
                      },
                      color: Colors.purple,
                    ),
                    new IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {},
                      color: Colors.purple,
                    ),
                  ],
                ),
                Divider(),
                new ListTile(
                  title: new Text("Product Description"),
                  subtitle: new Text(
                    details["description"],
                  ),
                ),
                Divider(),
                new Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                      child: new Text(
                        "Product Name",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Text(details["name"]),
                    ),
                  ],
                ),

                new Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                      child: new Text(
                        "Product Brand",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Text("BrandX"),
                    ),
                  ],
                ),

                new Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                      child: new Text(
                        "Product Condition",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Text("NEW"),
                    ),
                  ],
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text('Similar Products'),
                ),
                // // SIMILAR PRODUCTS
                // Container(
                //   height: 360.0,
                //   child: SimilarProducts(),
                // )
              ],
            ),
    );
  }
}

// class SimilarProducts extends StatefulWidget {
//   @override
//   _SimilarProductsState createState() => _SimilarProductsState();
// }

// class _SimilarProductsState extends State<SimilarProducts> {
//   var productList = [
//     {
//       "name": "Blazer",
//       "picture": "images/products/blazer1.jpeg",
//       "old_price": 120,
//       "price": 85,
//     },
//     {
//       "name": "Red Dress",
//       "picture": "images/products/dress1.jpeg",
//       "old_price": 89.09,
//       "price": 78,
//     },
//     {
//       "name": "Blazer",
//       "picture": "images/products/hills1.jpeg",
//       "old_price": 120,
//       "price": 85,
//     },
//     {
//       "name": "Blazer",
//       "picture": "images/products/hills2.jpeg",
//       "old_price": 120,
//       "price": 85,
//     },
//     {
//       "name": "Blazer",
//       "picture": "images/products/skt1.jpeg",
//       "old_price": 120,
//       "price": 85,
//     },
//     {
//       "name": "Blazer",
//       "picture": "images/products/skt2.jpeg",
//       "old_price": 120,
//       "price": 85,
//     },
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: productList.length,
//       gridDelegate:
//           new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//       itemBuilder: (BuildContext context, int index) {
//         return SimilarSingleProd(
//           prodName: productList[index]['name'],
//           prodPicture: productList[index]['picture'],
//           prodOldPrice: productList[index]['old_price'],
//           prodPrice: productList[index]['price'],
//         );
//       },
//     );
//   }
// }

// class SimilarSingleProd extends StatelessWidget {
//   final prodName;
//   final prodPicture;
//   final prodOldPrice;
//   final prodPrice;

//   SimilarSingleProd({
//     this.prodName,
//     this.prodPicture,
//     this.prodOldPrice,
//     this.prodPrice,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Hero(
//         tag: new Text("Hero 1"),
//         child: Material(
//           child: InkWell(
//             onTap: () => Navigator.of(context).push(
//               new MaterialPageRoute(
//                 builder: (context) => new ProductDetails(
//                   productDetailName: prodName,
//                   productDetailPicture: prodPicture,
//                   productDetailOldPrice: prodOldPrice,
//                   productDetailNewPrice: prodPrice,
//                 ),
//               ),
//             ),
//             child: GridTile(
//                 footer: Container(
//                   color: Colors.white70,
//                   child: new Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: new Text(
//                           prodName,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16.0),
//                         ),
//                       ),
//                       new Text(
//                         "\$$prodPrice",
//                         style: TextStyle(
//                             color: Colors.purple, fontWeight: FontWeight.bold),
//                       )
//                     ],
//                   ),
//                 ),
//                 child: Image.asset(prodPicture, fit: BoxFit.cover)),
//           ),
//         ),
//       ),
//     );
//   }
// }
