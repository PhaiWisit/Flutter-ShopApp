import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({Key? key, required this.showFavs}) : super(key: key);

  final bool showFavs;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = showFavs ? productsData.favoriteItem : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
              // id: products[index].id,
              // title: products[index].title,
              // imageUrl: products[index].imageUrl,
              ),
        );
      },
    );
  }
}
