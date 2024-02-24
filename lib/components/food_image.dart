import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/models/food_recommendation.dart';
import 'package:nutrimatch_mobile/utils/images.dart';

class ProductImages extends StatelessWidget {
  const ProductImages({
    super.key,
    required this.foodRecommendation,
  });

  final FoodRecommendation foodRecommendation;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
      ),
      child: SizedBox(
        child: loadImageFromUrl(foodRecommendation.imageUrl, BoxFit.fitWidth,
            maxHeight: MediaQuery.of(context).size.height * 0.7),
      ),
    );
  }
}
