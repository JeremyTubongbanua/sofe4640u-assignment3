import 'package:flutter/material.dart';
import '../models/order.dart';

class PlacedOrderItem extends StatelessWidget {
  final Order order;
  final VoidCallback onDelete;

  const PlacedOrderItem({super.key, required this.order, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(
          'Order Date: ${order.date.toLocal()}'.split('.')[0],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...order.items.map((item) {
              final foodItem = item['foodItem'];
              final quantity = item['quantity'];
              return Text(
                  '${foodItem.name} x$quantity - \$${(foodItem.cost * quantity).toStringAsFixed(2)}');
            }),
            const SizedBox(height: 5),
            Text(
              'Total: \$${order.totalCost.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
