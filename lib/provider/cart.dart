import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/provider/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items;

  Map<String, CartItem> get item {
    return {...this._items};
  }

  void addItem(Product product) {
    if (this._items.containsKey(product.id)) {
      this._items.update(product.id, (existingItem) {
        return CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        );
      });
    } else {
      this._items.putIfAbsent(product.id, () {
        return CartItem(
          id: Random().nextDouble().toString(),
          title: product.title,
          quantity: 1,
          price: product.price,
        );
      });
    }
    notifyListeners();
  }
}
