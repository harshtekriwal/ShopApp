import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products= Provider.of<Products>(context); // infinite loop
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Products"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                }),
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
                  future: _refreshProducts(context),
                  builder:(ctx,snapShot)=>snapShot.connectionState==ConnectionState.waiting?Center(child:CircularProgressIndicator()): RefreshIndicator(
            onRefresh: () {
              return _refreshProducts(context);
            },
            child: Consumer<Products>(
              builder: (ctx,products,_)=>
                          Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: products.items.length,
                  itemBuilder: (_, i) {
                    return UserProductItem(products.items[i].id,
                        products.items[i].title, products.items[i].imageUrl);
                  },
                ),
              ),
            ),
          ),
        ));
  }
}
