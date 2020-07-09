import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    this.isFavorite = !this.isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    this._toggleFavorite();

    final String _baseUrl =
        '${Constants.BASE_API_URL}/userFavorites';

    final response = await http.put(
      '${_baseUrl}/$userId/${this.id}.json?auth=$token',
      body: json.encode(this.isFavorite),
    );

    if (response.statusCode >= 400) {
      this._toggleFavorite();
      throw new HttpException(
          'Não foi possível marcar esse produto com favorito.');
    }
  }
}
