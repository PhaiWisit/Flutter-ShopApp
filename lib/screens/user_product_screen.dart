import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/product_provider.dart';
import 'package:flutter_shop/screens/edit_product_screen.dart';
import 'package:flutter_shop/widgets/app_drawer.dart';
import 'package:flutter_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductProvider>(context);
    print('rebuilding...');
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: '');
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<ProductProvider>(
                    builder: (context, productsData, child) {
                  return Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (context, index) => Column(
                              children: [
                                UserProductItem(
                                    id: productsData.items[index].id,
                                    title: productsData.items[index].title,
                                    imageUrl:
                                        productsData.items[index].imageUrl),
                                Divider(),
                              ],
                            )),
                  );
                }),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
