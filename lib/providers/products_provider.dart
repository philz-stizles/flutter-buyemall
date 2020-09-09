import 'dart:convert';

import 'package:buyemall/models/product.dart';
import 'package:buyemall/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final _baseUrl = 'https://flutter-api-62abb.firebaseio.com/';
  List<Product> _items = [
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
  ];

  String _token;
  // bool _isLoading = false;
  // bool get isLoading {
  //   return _isLoading; // return a copy of the items
  // }

  void update(AuthProvider authProvider) {
    _token = authProvider.authenticatedUser.token;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items]; // return a copy of the items
  }

  List<Product> get favoriteItems {
    return [
      ..._items.where((item) => item.isFavorite == true)
    ]; // return a copy of favorite items
  }

  Future<void> fetchProducts() async {
    try {
      // Ensure you return the Future returned by http and then that returned
      // by then. You could decide not to return anything from then which would
      // return Future<void>
      final response = await http.get(_baseUrl + 'products.json?auth=' + _token,
          headers: {'Content-Type': 'application/json'});

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(responseData);
      final List<Product> _loadedItems = [];
      responseData.forEach((key, value) {
        _loadedItems.add(new Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            createdAt: DateTime.parse(value['createdAt']),
            updatedAt: DateTime.parse(value['updatedAt'])));
      });
      _items = _loadedItems;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Map<String, dynamic> newProduct) async {
    newProduct['isFavorite'] = false;
    newProduct['createdAt'] = newProduct['updatedAt'] = DateTime.now();

    return http.post(
        // Ensure you return the Future returned by http and
        // then that returned by then. You could decide not to return anything from
        // then which would return Future<void>
        _baseUrl + 'products.json',
        body: json.encode(newProduct),
        headers: {'Content-Type': 'application/json'}).then((response) {
      final responseData = json.decode(response.body);

      _items.add(new Product(
          id: responseData['name'],
          title: newProduct['title'],
          description: newProduct['description'],
          price: newProduct['price'],
          imageUrl: newProduct['imageUrl'],
          createdAt: newProduct['createdAt'],
          updatedAt: newProduct['updatedAt']));
      notifyListeners();
    });
  }

  Future<void> updateProduct(
      String id, Map<String, dynamic> updatedProduct) async {
    updatedProduct['updatedAt'] = DateTime.now();

    var index = _items.indexWhere((element) => element.id == id);

    if (index >= 0) {
      await http.patch(_baseUrl + 'products/' + id + '.json?auth=' + _token,
          body: json.encode(updatedProduct),
          headers: {'Content-Type': 'application/json'});

      _items[index] = new Product(
          id: DateTime.now().toIso8601String(),
          title: updatedProduct['title'],
          description: updatedProduct['description'],
          price: updatedProduct['price'],
          imageUrl: updatedProduct['imageUrl']);
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
