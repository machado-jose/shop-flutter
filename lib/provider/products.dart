import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class Products with ChangeNotifier{
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [ ..._items ];
  //Faz uma copia da lista. Semelhante ao unmodifiableList() do Java

  void addProduct(Product product){
    _items.add(product);
    //Notificar os widgets interessados pela informação
    //Semelhante ao onSnapshot do Firebase
    notifyListeners();
  }
}