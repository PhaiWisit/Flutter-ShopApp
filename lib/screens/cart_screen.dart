import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/cart_provider.dart';
import 'package:flutter_shop/providers/order_provider.dart';
import 'package:flutter_shop/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                TextButton(
                    onPressed: () {
                      Provider.of<OrderProvider>(context, listen: false)
                          .addOrder(
                              cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) => CartItemWidget(
                    id: cart.items.values.toList()[index].id,
                    productId: cart.items.keys.toList()[index],
                    title: cart.items.values.toList()[index].title,
                    price: cart.items.values.toList()[index].price,
                    quantity: cart.items.values.toList()[index].quantity)))
      ]),
    );
  }
}
