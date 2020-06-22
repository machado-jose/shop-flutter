import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        this.product.imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: (){},
        ),
        title: Text(
          this.product.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: (){},
        ),
      ),
    );
  }
}
