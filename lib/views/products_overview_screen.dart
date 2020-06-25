import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/products_grid.dart';

enum FilterOptions {
  FAVORITES,
  ALL,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                (selectedValue == FilterOptions.FAVORITES)
                    ? this._showFavoriteOnly = true
                    : this._showFavoriteOnly = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.FAVORITES,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.ALL,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.CART,
                );
              },
            ),
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      body: ProductsGrid(this._showFavoriteOnly),
    );
  }
}
