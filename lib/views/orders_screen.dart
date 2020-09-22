import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_widget.dart';

class OrderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshOrders() async {
      return Provider.of<Orders>(context, listen: false).loadOrders();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
          centerTitle: true,
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if(snapshot.error != null) {
              return Center(child: Text('Unknown error.'));
            }
            else {
              return Consumer<Orders>(builder: (ctx, orders, child) {
                return RefreshIndicator(
                  onRefresh: _refreshOrders,
                  child: ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (ctx, index) =>
                        OrderWidget(orders.items[index]),
                  ),
                );
              });
            }
          },
        )
      // _isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : RefreshIndicator(
      //       onRefresh: _refreshOrders,
      //       child: ListView.builder(
      //           itemCount: orders.itemsCount,
      //           itemBuilder: (ctx, index) => OrderWidget(orders.items[index]),
      //         ),
      //     ),
    );
  }
}
