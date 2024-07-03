import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product.dart';

import '../utils/constants.dart';

import '../utils/snackbar.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = Constants.productBaseUrl;
  final _errorText = 'Ocorreu algum erro na requisição';

  final String _token;
  final String _userId;
  List<Product> _items = [];

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Product> get items => [..._items];
  List<Product> get favoritesItems =>
      _items.where((item) => item.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  Future<void> saveProduct(BuildContext ctx, Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(ctx, product);
    } else {
      return addProduct(ctx, product);
    }
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(Uri.parse('$_baseUrl.json?auth=$_token'));

    if (response.body == 'null') {
      return;
    }

    final favResponse = await http.get(
      Uri.parse('${Constants.userFavoriteBaseUrl}/$_userId.json?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;

      _items.add(Product(
        id: productId,
        name: productData['name'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFavorite: isFavorite,
      ));
    });

    notifyListeners();
  }

  Future<void> addProduct(BuildContext ctx, Product product) async {
    final toastfy = Toastfy(ctx);

    try {
      final response = await http.post(Uri.parse('$_baseUrl.json?auth=$_token'),
          body: jsonEncode({
            "name": product.name,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
          }));

      final result = jsonDecode(response.body);

      if (result['error'] ?? false) {
        toastfy.error(_errorText, null, 4);
      } else {
        _items.add(Product(
          id: result['name'] ?? '',
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        ));

        toastfy.success('Adicionado com sucesso!', null, 3);

        notifyListeners();
      }
    } catch (err) {
      toastfy.error(_errorText, null, 4);
    }
  }

  Future<void> updateProduct(BuildContext ctx, Product product) async {
    final toastfy = Toastfy(ctx);
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "price": product.price,
          "description": product.description,
          "imageUrl": product.imageUrl,
        }),
      );

      toastfy.success('Atualizado com sucesso!', null, 3);

      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    notifyListeners();

    if (index >= 0) {
      final removeProduct = _items[index];
      _items.remove(removeProduct);

      final response = await http
          .delete(Uri.parse('$_baseUrl/${product.id}.json?auth=$_token'));

      if (response.statusCode >= 400) {
        _items.insert(index, removeProduct);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível deletar o produto',
          statusCode: response.statusCode,
        );
      }
    }
  }
}
