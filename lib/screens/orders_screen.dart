import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (dataSnapshot.error != null) {
            //...
            //error handling stuff
            return Center(
              child: Text('An error occured!'),
            );
          } else {
            return Consumer<Orders>(
                builder: (ctx, orders, child) => ListView.builder(
                    itemCount: orders.getOrders.length,
                    itemBuilder: (ctx, index) {
                      return OrderItem(orders.getOrders[index]);
                    }));
          }
        },
      ),
    );
  }
}
