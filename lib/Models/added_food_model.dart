import 'package:mobile_app/Models/food_model.dart';

class AddedFoodModel {
  final FoodModel food;
  final int amount;
  final String mealTime;
  AddedFoodModel({
    required this.food,
    required this.amount,
    required this.mealTime,
  });
}
