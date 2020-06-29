import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import './product.dart';

class Products with ChangeNotifier{
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get favoriteItems => this._items.where((prod) => prod.isFavorite).toList();
  List<Product> get items => [..._items];
  //Faz uma copia da lista. Semelhante ao unmodifiableList() do Java

  int get itemsCount{
    return this._items.length;
  }

  void addProduct(Product product){
    _items.add(product);
    //Notificar os widgets interessados pela informação
    //Semelhante ao onSnapshot do Firebase
    notifyListeners();
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