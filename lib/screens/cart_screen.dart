import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart' show Cart;
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your cart")),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  _OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
            itemCount: cart.getItemCount(),
            itemBuilder: (ctx, index) {
              return CartItem(
                cart.getItems.keys.toList()[index],
                cart.getItems.values.toList()[index].id,
                cart.getItems.values.toList()[index].price,
                cart.getItems.values.toList()[index].title,
                cart.getItems.values.toList()[index].quantity,
              );
            },
          ))
        ],
      ),
    );
  }
}

class _OrderButton extends StatefulWidget {
  const _OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<_OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading?CircularProgressIndicator():Text("ORDER NOW"),
      onPressed: (widget.cart.totalAmount <= 0|| _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.getItems.values.toList(),
                  widget.cart.totalAmount);
                  setState(() {
                _isLoading = false; 
              });
              widget.cart.clear();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
