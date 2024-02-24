import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/components/product_images.dart';
import 'package:nutrimatch_mobile/models/food_recommendation.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';

class RecommendationDetails extends StatefulWidget {
  const RecommendationDetails({super.key, required this.foodRecommendation});

  final FoodRecommendation foodRecommendation;

  @override
  State<RecommendationDetails> createState() => _RecommendationDetailsState();
}

class _RecommendationDetailsState extends State<RecommendationDetails> {
  // food recommendation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: lightColorScheme.primary,
              size: 20,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.foodRecommendation.generalNutritionalScore
                          .toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          ProductImages(foodRecommendation: widget.foodRecommendation),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  color: lightColorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.foodRecommendation.shortFoodName!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.foodRecommendation.generalRecommendation!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Nutritional Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // make a list of cards for each food recommendation item
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.foodRecommendation.foodRecommendations!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        color: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.foodRecommendation
                                    .foodRecommendations![index].name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Size: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${widget.foodRecommendation.foodRecommendations![index].size} ${widget.foodRecommendation.foodRecommendations![index].sizeUnit}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Amount: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${widget.foodRecommendation.foodRecommendations![index].amount}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Confidence: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${widget.foodRecommendation.foodRecommendations![index].confidence}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        const TextSpan(
                                          text: 'Nutritional Score: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${widget.foodRecommendation.foodRecommendations![index].nutritionalScore}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Recommendation: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.foodRecommendation
                                    .foodRecommendations![index].recommendation,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Nutritional Information',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // make a chip for each nutritional information
                              Wrap(
                                spacing: 5,
                                runSpacing: 5,
                                children: [
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .calories !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Calories: ${widget.foodRecommendation.foodRecommendations![index].calories} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.red[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .carbohydrates !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Carbohydrates: ${widget.foodRecommendation.foodRecommendations![index].carbohydrates} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.green[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .fat !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Fat: ${widget.foodRecommendation.foodRecommendations![index].fat} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.blue[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .protein !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Protein: ${widget.foodRecommendation.foodRecommendations![index].protein} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.purple[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .fiber !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Fiber: ${widget.foodRecommendation.foodRecommendations![index].fiber} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.orange[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .sugar !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Sugar: ${widget.foodRecommendation.foodRecommendations![index].sugar} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.red[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .sodium !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Sodium: ${widget.foodRecommendation.foodRecommendations![index].sodium} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.green[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .vitaminA !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Vitamin A: ${widget.foodRecommendation.foodRecommendations![index].vitaminA} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.blue[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .vitaminC !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Vitamin C: ${widget.foodRecommendation.foodRecommendations![index].vitaminC} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.purple[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .calcium !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Calcium: ${widget.foodRecommendation.foodRecommendations![index].calcium} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.orange[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .iron !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Iron: ${widget.foodRecommendation.foodRecommendations![index].iron} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.red[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .cholesterol !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Cholesterol: ${widget.foodRecommendation.foodRecommendations![index].cholesterol} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.green[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                  widget
                                              .foodRecommendation
                                              .foodRecommendations![index]
                                              .potassium !=
                                          null
                                      ? Chip(
                                          label: Text(
                                            'Potassium: ${widget.foodRecommendation.foodRecommendations![index].potassium} ${widget.foodRecommendation.nutritionalInfoUnit}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: Colors.blue[400]!,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                50), // Adjust the value to make it more or less rounded
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
