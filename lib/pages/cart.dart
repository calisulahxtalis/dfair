
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final List cartList;
  Cart({@required this.cartList});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.purple,
        title: Text("Your Cart"),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.cartList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              // LEADING SECTION
              leading: new Image.asset(
                widget.cartList[index].image,
                width: 80.0,
                height: 80.0,
              ),
              // TITLE SECTION
              title: new Text(widget.cartList[index].name),
              // SUBTITLE SECTION
              subtitle: new Column(
                children: <Widget>[
                  // ROW INSIDE A COLUMN
                  new Row(
                    children: <Widget>[
                      // Size section
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: new Text("Size:"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: new Text(
                          widget.cartList[index].size,
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                      // Color Section
                      new Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                        child: new Text("Color"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: new Text(
                          widget.cartList[index].color,
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                    ],
                  ),
                  // Price Section
                  Container(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      "\$${widget.cartList[index].price}",
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              // trailing: new Column(
              //   children: <Widget>[
              //     new IconButton(
              //       icon: Icon(Icons.arrow_drop_up),
              //       onPressed: () {},
              //     ),
              //     new Text("$cartProdQty"),
              //     new IconButton(
              //       icon: Icon(Icons.arrow_drop_down),
              //       onPressed: () {},
              //     ),
              //   ],
              // ),
            ),
          );
        },
      ),
      bottomNavigationBar: new Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: new Text("Total:"),
                subtitle: new Text("\$230"),
              ),
            ),
            Expanded(
              child: new MaterialButton(
                onPressed: () {},
                child: new Text("Check Out",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
