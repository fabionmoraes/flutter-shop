import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/cart_item.dart';

import 'package:shop/utils/constants.dart';

import './order.dart';
import './cart.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Order> _items = [];

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'));

    if (response.body == 'null') {
      return;
    }

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, orderData) {
      _items.add(Order(
        id: orderId,
        date: DateTime.parse(orderData['date']),
        total: orderData['total'],
        products: (orderData['products'] as List<dynamic>).map((cartItem) {
          return CartItem(
            id: cartItem['id'],
            productId: cartItem['productId'],
            name: cartItem['name'],
            quantity: cartItem['quantity'],
            price: cartItem['price'],
          );
        }).toList(),
      ));
    });

    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
        Uri.parse('${Constants.orderBaseUrl}/$_userId.json?auth=$_token'),
        body: jsonEncode({
          "total": cart.totalAmount,
          "date": date.toIso8601String(),
          "products": cart.items.values
              .map((cartItem) => {
                    "id": cartItem.id,
                    "productId": cartItem.productId,
                    "name": cartItem.name,
                    "price": cartItem.price,
                    "quantity": cartItem.quantity,
                  })
              .toList()
        }));

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );

    notifyListeners();
  }
}
