import 'package:flutter/material.dart';
import '../components/placed_order_item.dart';
import '../models/order.dart';
import '../database/database_helper.dart';

class OrdersPlacedScreen extends StatefulWidget {
  const OrdersPlacedScreen({super.key});

  @override
  _OrdersPlacedScreenState createState() => _OrdersPlacedScreenState();
}

class _OrdersPlacedScreenState extends State<OrdersPlacedScreen> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() async {
    final db = DatabaseHelper();
    final loadedOrders = await db.loadOrders();
    setState(() {
      orders = loadedOrders;
    });
  }

  void deleteOrder(int index) async {
    final db = DatabaseHelper();
    setState(() {
      orders.removeAt(index);
    });
    await db.saveOrders(orders);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order deleted successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Past Orders')),
      body: orders.isEmpty
          ? const Center(child: Text('No orders placed yet.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return PlacedOrderItem(
                  order: order,
                  onDelete: () => deleteOrder(index),
                );
              },
            ),
    );
  }
}
