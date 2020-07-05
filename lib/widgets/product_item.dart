import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    // Como a função que faz o tratamento de erro na remoção do produto é assincrono, o contexto
    // não pode ser chamado para a construção de um snackbar pelo Scaffold
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(this.product.imageUrl),
      ),
      title: Text(this.product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: this.product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Excluir Produto?'),
                        content: Text('Tem certeza?'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Não'),
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Sim'),
                          ),
                        ],
                      );
                    }).then((value) async {
                  if (value)
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .removeProduct(this.product.id);
                    } on HttpException catch (error) {
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString(),
                          ),
                        ),
                      );
                    }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
