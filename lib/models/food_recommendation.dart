import 'package:nutrimatch_mobile/models/food_recommendation_item.dart';

class FoodRecommendation {
  final String id;
  final bool validUserInput;
  final String? errorMessage;
  final String? shortFoodName;
  final String? generalDescription;
  final String? generalRecommendation;
  final int? generalNutritionalScore;
  final String? nutritionalInfoUnit;
  final List<FoodRecommendationItem>? foodRecommendations;
  final DateTime timestamp;
  final String? imageUrl;

  FoodRecommendation({
    required this.id,
    required this.validUserInput,
    this.errorMessage,
    this.shortFoodName,
    this.generalDescription,
    this.generalRecommendation,
    this.generalNutritionalScore,
    this.nutritionalInfoUnit,
    this.foodRecommendations,
    required this.timestamp,
    this.imageUrl,
  });

  factory FoodRecommendation.fromJson(Map<String, dynamic> json) {
    List<FoodRecommendationItem> foodRecommendations = [];
    if (json['food_recommendations'] != null) {
      json['food_recommendations'].forEach((v) {
        foodRecommendations.add(FoodRecommendationItem.fromJson(v));
      });
    }

    return FoodRecommendation(
      id: json['id'] as String,
      validUserInput: json['valid_user_input'] as bool,
      errorMessage: json['error_message'] as String?,
      shortFoodName: json['short_food_name'] as String?,
      generalDescription: json['general_description'] as String?,
      generalRecommendation: json['general_recommendation'] as String?,
      generalNutritionalScore: json['general_nutritional_score'] as int?,
      nutritionalInfoUnit: json['nutritional_info_unit'] as String?,
      foodRecommendations: foodRecommendations,
      timestamp: DateTime.parse(json['timestamp']),
      imageUrl: json['image_url'] as String?,
    );
  }

  static List<FoodRecommendation> fromSnapshot(List snapshot) {
    List<FoodRecommendation> foodRecommendations = [];
    for (var json in snapshot) {
      foodRecommendations.add(FoodRecommendation.fromJson(json));
    }
    return foodRecommendations;
  }
}
