import 'food_item.dart';

class Order {
  final DateTime date;
  final List<Map<String, dynamic>> items; // {'foodItem': FoodItem, 'quantity': int}
  final double totalCost;

  Order({required this.date, required this.items, required this.totalCost});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'items': items.map((e) => {
              'foodItem': e['foodItem'].toJson(),
              'quantity': e['quantity']
            }).toList(),
        'totalCost': totalCost
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        date: DateTime.parse(json['date']),
        items: (json['items'] as List).map((e) => {
              'foodItem': FoodItem.fromJson(e['foodItem']),
              'quantity': e['quantity']
            }).toList(),
        totalCost: json['totalCost'],
      );
}
