import 'package:flutter/material.dart';
import './database/database_helper.dart';
import './models/food_item.dart';
import './pages/home_screen.dart';
import './pages/orders_placed_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseHelper();
  final dummyItems = [
    FoodItem(name: 'Steak', cost: 24.99),
    FoodItem(name: 'BBQ Ribs', cost: 19.99),
    FoodItem(name: 'Sushi', cost: 15.99),
    FoodItem(name: 'Fish and Chips', cost: 13.99),
    FoodItem(name: 'Pizza', cost: 12.99),
    FoodItem(name: 'Chicken Wings', cost: 11.99),
    FoodItem(name: 'Pasta', cost: 10.99),
    FoodItem(name: 'Tacos', cost: 9.99),
    FoodItem(name: 'Burger', cost: 8.99),
    FoodItem(name: 'Nachos', cost: 8.49),
    FoodItem(name: 'Salad', cost: 7.99),
    FoodItem(name: 'Pancakes', cost: 7.49),
    FoodItem(name: 'Waffles', cost: 7.49),
    FoodItem(name: 'Smoothie', cost: 6.99),
    FoodItem(name: 'Sandwich', cost: 6.99),
    FoodItem(name: 'Soup', cost: 5.99),
    FoodItem(name: 'Hot Dog', cost: 5.49),
    FoodItem(name: 'Ice Cream', cost: 4.99),
    FoodItem(name: 'Grilled Cheese', cost: 4.99),
    FoodItem(name: 'Fries', cost: 3.99),
  ];
  await db.saveFoodItems(dummyItems);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.blue.shade50,
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const OrdersPlacedScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
