import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nutrimatch_mobile/models/food_recommendation.dart';
import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/models/custom_http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackendAPI {
  static String backendUrl = 'http://192.168.0.30:3000';

  static Future<List<FoodRecommendation>> getFoodRecommendations() async {
    debugPrint('getFoodRecommendations called');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? idToken = prefs.getString('idToken');

    if (idToken == null) {
      throw Exception('No idToken found');
    }

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

  static Future<dynamic> getFoodRecommendation(File image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? idToken = prefs.getString('idToken');

    if (idToken == null) {
      throw Exception('No idToken found');
    }

    var uri = Uri.parse('$backendUrl/api/v1/food-detection/recommendation');
    var request = http.MultipartRequest('POST', uri);

    request.headers.addAll(<String, String>{
      'accept': 'application/json',
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'image/${image.path.split('.').last}',
      'Content-Disposition':
          'inline; filename=${image.path.split('/').last}; name=file',
    });

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      await image.readAsBytes(),
      filename: image.path.split('/').last,
    ));

    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    debugPrint(responseString);
    if (response.statusCode == 200) {
      return FoodRecommendation.fromJson(jsonDecode(responseString));
    } else {
      throw CustomHTTPException(
          jsonDecode(responseString)['detail'], response.statusCode);
    }
  }
}
