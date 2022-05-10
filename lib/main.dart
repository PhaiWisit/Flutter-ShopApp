import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/cart_provider.dart';
import 'package:flutter_shop/providers/order_provider.dart';
import 'package:flutter_shop/providers/product_provider.dart';
import 'package:flutter_shop/screens/cart_screen.dart';
import 'package:flutter_shop/screens/edit_product_screen.dart';
import 'package:flutter_shop/screens/order_screen.dart';
import 'package:flutter_shop/screens/products_detail_screen.dart';
import 'package:flutter_shop/screens/products_overview_screen.dart';
import 'package:flutter_shop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => ProductProvider())),
        ChangeNotifierProvider(create: ((context) => CartProvider())),
        ChangeNotifierProvider(create: ((context) => OrderProvider())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Lato',
          accentColor: Colors.deepOrange,
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: ((context) => CartScreen()),
          OrdersScreen.routeName: ((context) => OrdersScreen()),
          UserProductScreen.routeName: (context) => UserProductScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyShop')),
      body: const Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
