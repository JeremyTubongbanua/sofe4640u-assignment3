import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_item.dart';
import '../models/order.dart';
import 'dart:convert';

class DatabaseHelper {
  static const String _foodItemsKey = 'FoodItems';
  static const String _ordersKey = 'Orders';

  Future<void> saveFoodItems(List<FoodItem> foodItems) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonItems = foodItems.map((item) => item.toJson()).toList();
    prefs.setString(_foodItemsKey, json.encode(jsonItems));
  }

  Future<List<FoodItem>> loadFoodItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_foodItemsKey);
    if (jsonData == null) return [];
    final List<dynamic> data = json.decode(jsonData);
    return data.map((item) => FoodItem.fromJson(item)).toList();
  }

  Future<void> saveOrders(List<Order> orderItems) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonItems = orderItems.map((item) => item.toJson()).toList();
    prefs.setString(_ordersKey, json.encode(jsonItems));
  }

  Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString(_ordersKey);
    if (jsonData == null) return [];
    final List<dynamic> data = json.decode(jsonData);
    return data.map((item) => Order.fromJson(item)).toList();
  }
}
