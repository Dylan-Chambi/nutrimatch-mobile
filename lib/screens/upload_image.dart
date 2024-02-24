import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/api/backend_api.dart';
import 'package:nutrimatch_mobile/models/custom_http_exception.dart';
import 'package:nutrimatch_mobile/models/food_recommendation.dart';
import 'package:nutrimatch_mobile/screens/recommendation_details.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key, required this.imageFile});

  final File imageFile;

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 15,
                      color: const Color(0xFFB7B7B7).withOpacity(0.16),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Image to be uploaded',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: lightColorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Specify the border radius here
                      child: Image.file(
                        widget.imageFile,
                        fit: BoxFit.fitWidth,
                        height: 300,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          showLoaderDialog(context);
                          FoodRecommendation foodRecommendation =
                              await BackendAPI.getFoodRecommendation(
                            widget.imageFile,
                          );
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationDetails(
                                  foodRecommendation: foodRecommendation,
                                ),
                              ),
                            );
                          });
                        } on CustomHTTPException catch (e) {
                          debugPrint('Error: $e');
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pop(context); // Remove this line
                            showErrorDialog(context, e.detail);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightColorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Get Recommendations',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showErrorDialog(BuildContext context, String message) {
    AlertDialog alert = AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
