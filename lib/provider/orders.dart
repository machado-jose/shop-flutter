import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';

class Order{
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

class Orders with ChangeNotifier{
  List<Order> _items = [];

  List<Order> get items{
    return [...this._items];
  }

  int get itemsCount{
    return this._items.length;
  }

  void addOrder(Cart cart){
    this._items.insert(0, Order(
      id: Random().nextDouble().toString(),
      total: cart.totalAmount,
      products: cart.items.values.toList(),
      date: DateTime.now(),
    ));

    notifyListeners();
  }
}