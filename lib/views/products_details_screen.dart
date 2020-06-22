import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductsDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
