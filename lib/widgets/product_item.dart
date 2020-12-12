import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dsg/providers/cart.dart';
import 'package:dsg/providers/product.dart';
import 'package:dsg/providers/products.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: Container(
          color: Colors.black45,
          padding: EdgeInsets.all(10),
          child: Text(
            "\$${product.price}",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        child: GestureDetector(
          onTap: () {},
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('images/cats/formal.png'),
              image: NetworkImage(product.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black,
          leading: Consumer<Product>(
            builder: (_, product, child) =>
                IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
          ),
          title: Text(product.name, textAlign: TextAlign.center,),
          trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                cart.addItem(product.id.toString(), product.price, product.name);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product added to the cart!',),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: (){
                          cart.removeSingleItem(product.id.toString());
                        },
                      ),
                    ),
                );
              },
            ),
        ),
      ),
    );
  }
}
