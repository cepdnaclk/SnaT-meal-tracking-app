class FoodModel {
  final String name;
  final String unit;
  final String mealType;
  final String? standardSize;
  final String iconCode;
  FoodModel({
    required this.name,
    required this.unit,
    required this.mealType,
    this.standardSize,
    required this.iconCode,
  });
}
