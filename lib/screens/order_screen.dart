import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/order_provider.dart' show OrderProvider;
import 'package:flutter_shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(title: Text('Your Orders')),
        body: FutureBuilder(
          future: Provider.of<OrderProvider>(context, listen: false)
              .fetchAndSetOrders(),
          builder: (context, snapshort) {
            if (snapshort.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshort.error != null) {
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<OrderProvider>(
                    builder: (context, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (context, index) => OrderItem(
                              order: orderData.orders[index],
                            )));
              }
            }
          },
        ));
  }
}
