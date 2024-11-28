import 'package:flutter/material.dart';
import '../components/cart_item.dart';
import '../models/food_item.dart';
import '../models/order.dart';
import '../database/database_helper.dart';
import 'orders_placed_screen.dart';

class CartScreen extends StatefulWidget {
  final Map<FoodItem, int> cart;
  final double budget;

  const CartScreen({super.key, required this.cart, required this.budget});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<FoodItem, int> cart;
  late double remainingBudget;
  final DatabaseHelper db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    cart = Map.of(widget.cart);
    remainingBudget = widget.budget;
  }

  double getTotalCost() {
    return cart.entries
        .fold(0, (sum, entry) => sum + (entry.key.cost * entry.value));
  }

  Future<void> placeOrder() async {
    final totalCost = getTotalCost();
    final orderItems = cart.entries
        .map((entry) => {
              'foodItem': entry.key,
              'quantity': entry.value,
            })
        .toList();
    final order = Order(
      date: DateTime.now(),
      items: orderItems,
      totalCost: totalCost,
    );

    final existingOrders = await db.loadOrders();
    existingOrders.add(order);
    await db.saveOrders(existingOrders);

    setState(() {
      cart.clear();
      remainingBudget = widget.budget;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Order placed on ${order.date.toLocal()}! Total: \$${totalCost.toStringAsFixed(2)}'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OrdersPlacedScreen()),
    );
  }

  void updateQuantity(FoodItem item, int delta) {
    setState(() {
      final newQuantity = (cart[item] ?? 0) + delta;

      if (newQuantity > 0) {
        cart[item] = newQuantity;
        remainingBudget -= item.cost * delta;
      } else {
        remainingBudget += item.cost * (cart[item] ?? 0);
        cart.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, {'cart': cart, 'budget': remainingBudget});
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final entry = cart.entries.elementAt(index);
                final item = entry.key;
                final quantity = entry.value;

                return CartItem(
                  item: item,
                  quantity: quantity,
                  remainingBudget: remainingBudget,
                  onAdd: () => updateQuantity(item, 1),
                  onRemove: () => updateQuantity(item, -1),
                  onDelete: () {
                    setState(() {
                      remainingBudget += item.cost * quantity;
                      cart.remove(item);
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${getTotalCost().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: cart.isNotEmpty ? placeOrder : null,
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
