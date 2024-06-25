import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoritesItems =>
      _items.where((item) => item.isFavorite).toList();
}

// bool _showFavoriteOnly = false;

//   List<Product> get items {
//     if (_showFavoriteOnly) {
//       return _items.where((item) => item.isFavorite).toList();
//     }

//     return [..._items];
//   }

//   void addProduct(Product product) {
//     _items.add(product);
//     notifyListeners();
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }