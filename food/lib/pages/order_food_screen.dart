import 'package:flutter/material.dart';
import '../components/food_item_card.dart';
import '../database/database_helper.dart';
import '../models/food_item.dart';
import 'cart_screen.dart';

class OrderFoodScreen extends StatefulWidget {
  final double budget;

  const OrderFoodScreen({super.key, required this.budget});

  @override
  _OrderFoodScreenState createState() => _OrderFoodScreenState();
}

class _OrderFoodScreenState extends State<OrderFoodScreen> {
  final DatabaseHelper db = DatabaseHelper();
  List<FoodItem> foodItems = [];
  Map<FoodItem, int> cart = {};
  late double remainingBudget;

  @override
  void initState() {
    super.initState();
    remainingBudget = widget.budget;
    loadFoodItems();
  }

  void loadFoodItems() async {
    final items = await db.loadFoodItems();
    setState(() {
      foodItems = items;
    });
  }

  void addToCart(FoodItem item) {
    if (remainingBudget >= item.cost) {
      setState(() {
        cart[item] = (cart[item] ?? 0) + 1;
        remainingBudget -= item.cost;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${item.name} \$${item.cost.toStringAsFixed(2)} added to Cart!'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough budget to add this item!')),
      );
    }
  }

  int getCartItemCount() {
    return cart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  List<FoodItem> getAffordableItems() {
    return foodItems.where((item) => item.cost <= remainingBudget).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Food')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Budget: \$${remainingBudget.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: remainingBudget < 0 ? Colors.red : Colors.black,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: getAffordableItems().length,
              itemBuilder: (context, index) {
                final item = getAffordableItems()[index];
                return FoodItemCard(
                  item: item,
                  onTap: () => addToCart(item),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (cart.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your cart is empty!')),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CartScreen(cart: cart, budget: remainingBudget),
            ),
          ).then((result) {
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                cart = result['cart'] as Map<FoodItem, int>;
                remainingBudget = result['budget'] as double;
              });
            }
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_cart),
            if (getCartItemCount() > 0)
              Positioned(
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 10,
                  child: Text(
                    getCartItemCount().toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
