import 'package:flutter/material.dart';
import 'package:dsg/providers/products.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/products_grid.dart';

// enum FilterOptions {
//   Favorites,
//   All,
// }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context ).fetchAndSetProduct();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DSG Store'),
        //   actions: <Widget>[
        //     PopupMenuButton(
        //       onSelected: (FilterOptions selectedValue) {
        //         setState(() {
        //           if (selectedValue == FilterOptions.Favorites) {
        //             _showOnlyFavorites = true;
        //           } else {
        //             _showOnlyFavorites = false;
        //           }
        //         });
        //       },
        //       icon: Icon(Icons.more_vert),
        //       itemBuilder: (_) => [
        //         PopupMenuItem(
        //           child: Text("Only Favorites"),
        //           value: FilterOptions.Favorites,
        //         ),
        //         PopupMenuItem(
        //           child: Text("Show All"),
        //           value: FilterOptions.All,
        //         ),
        //       ],
        //     ),
        //     Consumer<Cart>(
        //       builder: (_, cartObject, child) => Badge(
        //         child: child,
        //         value: cartObject.itemCount.toString(),
        //       ),
        //       child: IconButton(
        //         icon: Icon(Icons.shopping_cart),
        //         onPressed: () {
        //           Navigator.of(context).pushNamed(CartScreen.routeName);
        //         },
        //       ),
        //     ),
        //   ],
         ),
        // drawer: AppDrawer(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid());
  }
}
