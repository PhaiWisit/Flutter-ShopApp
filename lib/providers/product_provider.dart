import 'package:flutter/material.dart';
import 'package:flutter_shop/models/http_exception.dart';
import 'package:flutter_shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'A Cat',
    //   description: 'A cute little cat',
    //   price: 299.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_960_720.jpg',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'Sunflower',
    //   description: 'Sunflower for your wife',
    //   price: 2.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2022/04/15/19/54/flowers-7135053_960_720.jpg',
    // ),
    // Product(
    //   id: 'p7',
    //   title: 'Ice cream',
    //   description: 'ice cream for summer',
    //   price: 2.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2017/11/30/08/56/ice-cream-2987955_960_720.jpg',
    // ),
    // Product(
    //   id: 'p8',
    //   title: 'Smartphone',
    //   description: 'Smartphone',
    //   price: 2.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2014/08/05/10/30/iphone-410324_960_720.jpg',
    // ),
  ];

  var _showFavoritesOnly = false;

  final String authToken;
  final String userId;

  ProductProvider(this.authToken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return _items.toList();
  }

  List<Product> get favoriteItem {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filtterByUser = false]) async {
    if (authToken.isNotEmpty) {
      final filterString =
          filtterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      var url = Uri.parse(
          'https://flutter-update-286c5-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken&$filterString');

      try {
        final response = await http.get(url);
        if (json.decode(response.body) == null) {
          _items = [];
          notifyListeners();
          return;
        }
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        url = Uri.parse(
            'https://flutter-update-286c5-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorite/$userId.json?auth=$authToken');
        final favoriteResponse = await http.get(url);
        final favoriteData = json.decode(favoriteResponse.body);
        final List<Product> loadedProducts = [];

        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
              imageUrl: prodData['imageUrl']));
        });
        _items = loadedProducts;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-update-286c5-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
          // 'isFavorite': product.isFavorite,
        }),
      );

      print(json.decode(response.body));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-update-286c5-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-update-286c5-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
