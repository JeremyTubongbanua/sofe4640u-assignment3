class FoodItem {
  final String name;
  final double cost;

  FoodItem({required this.name, required this.cost});

  Map<String, dynamic> toJson() => {'name': name, 'cost': cost};
  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      FoodItem(name: json['name'], cost: json['cost']);
}
