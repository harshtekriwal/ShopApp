import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/product.dart';
import 'package:shopapp/screens/auth_screen.dart';
import 'package:shopapp/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productItem = Provider.of<Product>(context);
    final cartItem = Provider.of<Cart>(context,listen: false);
    final AuthData = Provider.of<Auth>(context,listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                  arguments: productItem.id);
            },
            child: Hero(
              tag:productItem.id,
                          child: FadeInImage(
                placeholder: AssetImage('assets/images/product-placeholder.png'), 
                image: NetworkImage(productItem.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                productItem.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: (() {
                productItem.toggleFavourite(AuthData.token,AuthData.userId);
              }),
            ),
            title: Text(
              productItem.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart,
                  color: Theme.of(context).accentColor),
              onPressed: (){cartItem.addItem(productItem.id, productItem.price,productItem.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(content:Text("Added item to cart!"),duration: Duration(seconds: 2),action:
              SnackBarAction(label: "UNDO", onPressed: (){cartItem.removeSingleItem(productItem.id);}),));
              },

            ),
          )),
    );
  }
}
