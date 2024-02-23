import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutrimatch_mobile/models/food_recommendation.dart';

class BackendAPI {
  static String backendUrl = 'http://192.168.0.30:3000';

  static Future<List<FoodRecommendation>> getFoodRecommendations(
      String idToken) async {
    var uri =
        Uri.parse('$backendUrl/api/v1/recommendation/get-recommendations');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      List<FoodRecommendation> foodRecommendations =
          FoodRecommendation.fromSnapshot(jsonDecode(response.body));
      return foodRecommendations;
    } else {
      throw Exception('Failed to load food recommendations');
    }
  }
}
