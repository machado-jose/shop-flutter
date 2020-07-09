import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/provider/cart.dart';
import 'package:shop/utils/constants.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  const Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];
  final String _baseUrl = '${Constants.BASE_API_URL}/orders';
  final String _token;
  final String _userId;

  Orders(this._token, this._userId, this._items);

  List<Order> get items {
    return [...this._items];
  }

  int get itemsCount {
    return this._items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      '${this._baseUrl}/$_userId.json?auth=${this._token}',
      body: json.encode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );

    this._items.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          total: cart.totalAmount,
          products: cart.items.values.toList(),
          date: date,
        ));

    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get('${this._baseUrl}/$_userId.json?auth=${this._token}');
    Map<String, dynamic> data = json.decode(response.body);
    
    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedItems.add(
              Order(
                id: orderId,
                total: orderData['total'],
                date: DateTime.parse(orderData['date']),
                products: (orderData['products'] as List<dynamic>).map((item) {
                  return CartItem(
                    id: item['id'],
                    price: item['price'],
                    productId: item['productId'],
                    quantity: item['quantity'],
                    title: item['title'],
                  );
                }).toList(),
              ),
            );
      });
      notifyListeners();
    }
    this._items = loadedItems.reversed.toList();
    return Future.value();
  }
}
