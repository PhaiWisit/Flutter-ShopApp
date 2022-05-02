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
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Your Orders')),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) => OrderItem(
                order: orderData.orders[index],
              )),
    );
  }
}
