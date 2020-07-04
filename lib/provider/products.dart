import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  // .json -> Regra do firebase realtime
  final String _baseUrl = 'https://flutter-shop-bb234.firebaseio.com/products';

  List<Product> get favoriteItems =>
      this._items.where((prod) => prod.isFavorite).toList();
  List<Product> get items => [..._items];
  //Faz uma copia da lista. Semelhante ao unmodifiableList() do Java

  int get itemsCount {
    return this._items.length;
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      '${this._baseUrl}.json',
      body: json.encode({
        'title': newProduct.title,
        'price': newProduct.price,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite
      }),
    );

    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    ));
    //Notificar os widgets interessados pela informação
    //Semelhante ao onSnapshot do Firebase
    notifyListeners();
  }

  Future<void> loadProducts() async {
    final response = await http.get('${this._baseUrl}.json');
    Map<String, dynamic> data = json.decode(response.body);
    this._items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        this._items.add(
              Product(
                id: productId,
                title: productData['title'],
                price: productData['price'],
                description: productData['description'],
                imageUrl: productData['imageUrl'],
                isFavorite: productData['isFavorite'],
              ),
            );
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) return;

    var index = this._items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      
      await http.patch(
        '${this._baseUrl}/${product.id}.json',
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }),
      );
      this._items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    var index = this._items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      this._items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }
}

// List<Product> get items {
//   if(_showFavoriteOnly){
//     return this._items.where((prod) => prod.isFavorite).toList();
//   }
//   return [ ..._items ];
// }

// void showFavoriteOnly(){
//   this._showFavoriteOnly = true;
//   notifyListeners();
// }

// void showAll(){
//   this._showFavoriteOnly = false;
//   notifyListeners();
// }
