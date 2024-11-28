import 'package:flutter/material.dart';
import '../models/food_item.dart';

class CartItem extends StatelessWidget {
  final FoodItem item;
  final int quantity;
  final double remainingBudget;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const CartItem({
    super.key,
    required this.item,
    required this.quantity,
    required this.remainingBudget,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${item.name} x$quantity'),
      subtitle: Text('Cost: \$${(item.cost * quantity).toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: onRemove,
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: remainingBudget >= item.cost ? Colors.green : Colors.grey,
            ),
            onPressed: remainingBudget >= item.cost ? onAdd : null,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
