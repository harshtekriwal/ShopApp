import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/badge.dart';
import 'package:shopapp/widgets/product_grid.dart';

import 'cart_screen.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavorites = false;
  var _initState = false;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (!_initState) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _initState = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("MyShop"),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.All) {
                    _showFavorites = false;
                  } else {
                    _showFavorites = true;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text("Only Favorites"),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                    child: Text("Show All"), value: FilterOptions.All),
              ],
            ),
            Consumer<Cart>(
                builder: (_, cart, ch) =>
                    Badge(child: ch, value: cart.getItemCount().toString()),
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ))
          ],
        ),
        drawer: AppDrawer(),
        body:_isLoading?Center(child:CircularProgressIndicator()):ProductsGrid(_showFavorites));
  }
}
