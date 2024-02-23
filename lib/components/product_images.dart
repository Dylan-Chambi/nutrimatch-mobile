import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/models/food_recommendation.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    super.key,
    required this.foodRecommendation,
  });

  final FoodRecommendation foodRecommendation;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
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
        child: Image.network(
          widget.foodRecommendation.imageUrl!,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
