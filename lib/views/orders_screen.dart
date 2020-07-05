import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    Provider.of<Orders>(context, listen: false).loadOrders().then((_) {
      setState(() {
        this._isLoading = false;
      });
    });
  }

  Future<void> _refreshList(BuildContext context){
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: this._isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
            onRefresh: () => _refreshList(context),
              child: ListView.builder(
                itemCount: orders.itemsCount,
                itemBuilder: (ctx, i) {
                  return OrderWidget(orders.items[i]);
                },
              ),
            ),
    );
  }
}
