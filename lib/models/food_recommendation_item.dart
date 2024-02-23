class FoodRecommendationItem {
  final String name;
  final int size;
  final String sizeUnit;
  final int amount;
  final double confidence;
  final List<String>? seasonings;
  final List<String>? ingredients;
  final String recommendation;
  final int nutritionalScore;
  final int? calories;
  final int? carbohydrates;
  final int? fat;
  final int? protein;
  final int? fiber;
  final int? sugar;
  final int? sodium;
  final int? vitaminA;
  final int? vitaminC;
  final int? calcium;
  final int? iron;
  final int? cholesterol;
  final int? potassium;
  final String? warning;
  final String? alternativeRecommendation;
  final int? alternativeNutritionalScore;

  FoodRecommendationItem({
    required this.name,
    required this.size,
    required this.sizeUnit,
    required this.amount,
    required this.confidence,
    this.seasonings,
    this.ingredients,
    required this.recommendation,
    required this.nutritionalScore,
    this.calories,
    this.carbohydrates,
    this.fat,
    this.protein,
    this.fiber,
    this.sugar,
    this.sodium,
    this.vitaminA,
    this.vitaminC,
    this.calcium,
    this.iron,
    this.cholesterol,
    this.potassium,
    this.warning,
    this.alternativeRecommendation,
    this.alternativeNutritionalScore,
  });

  factory FoodRecommendationItem.fromJson(Map<String, dynamic> json) {
    return FoodRecommendationItem(
      name: json['name'] as String,
      size: json['size'] as int,
      sizeUnit: json['size_unit'] as String,
      amount: json['amount'] as int,
      confidence: json['confidence'] as double,
      seasonings: json['seasonings'] != null
          ? List<String>.from(json['seasonings'])
          : null,
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
      recommendation: json['recommendation'] as String,
      nutritionalScore: json['nutritional_score'] as int,
      calories: json['calories'] as int?,
      carbohydrates: json['carbohydrates'] as int?,
      fat: json['fat'] as int?,
      protein: json['protein'] as int?,
      fiber: json['fiber'] as int?,
      sugar: json['sugar'] as int?,
      sodium: json['sodium'] as int?,
      vitaminA: json['vitaminA'] as int?,
      vitaminC: json['vitaminC'] as int?,
      calcium: json['calcium'] as int?,
      iron: json['iron'] as int?,
      cholesterol: json['cholesterol'] as int?,
      potassium: json['potassium'] as int?,
      warning: json['warning'] as String?,
      alternativeRecommendation: json['alternative_recommendation'] as String?,
      alternativeNutritionalScore:
          json['alternative_nutritional_score'] as int?,
    );
  }

  static List<FoodRecommendationItem> fromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return FoodRecommendationItem.fromJson(data);
    }).toList();
  }
}
