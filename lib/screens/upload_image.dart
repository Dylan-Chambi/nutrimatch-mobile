import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrimatch_mobile/api/backend_api.dart';
import 'package:nutrimatch_mobile/models/custom_http_exception.dart';
import 'package:nutrimatch_mobile/models/food_recommendation.dart';
import 'package:nutrimatch_mobile/models/image_selection_type.dart';
import 'package:nutrimatch_mobile/screens/recommendation_details.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';
import 'package:nutrimatch_mobile/utils/images.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({
    super.key,
    required this.imageSelectionType,
    required this.originalImageFile,
    required this.croppedImageFile,
    this.callback,
  });

  final ImageSelectionType imageSelectionType;
  final XFile originalImageFile;
  final XFile croppedImageFile;
  final Function? callback;

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  late XFile newSelectedImageFile;
  late XFile newCropedImageFile;

  final maxExtraInfoLength = 200;

  String extraInfo = '';
  int extraInfoLength = 0;

  @override
  void initState() {
    super.initState();
    newSelectedImageFile = widget.originalImageFile;
    newCropedImageFile = widget.croppedImageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B5328),
                  Color(0xFF4CA76B),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          ListView(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                  child: const Text(
                    'Image Preview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                constraints: BoxConstraints(
                    minWidth:
                        min(MediaQuery.of(context).size.width * 0.85, 400)),
                child: Center(
                  child: Column(children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 15,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(0),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4),
                            child: loadImageFromFile(
                                File(newCropedImageFile.path), BoxFit.fitWidth),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 10,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  cropImage(context, newSelectedImageFile)
                                      .then((XFile croppedImgFile) {
                                    setState(() {
                                      newCropedImageFile = croppedImgFile;
                                    });
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: lightColorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.edit),
                                label: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              widget.imageSelectionType ==
                                      ImageSelectionType.gallery
                                  ? const SizedBox.shrink()
                                  : ElevatedButton.icon(
                                      onPressed: () {
                                        imgFromCamera(context)
                                            .then((XFile imgFile) {
                                          cropImage(context, imgFile)
                                              .then((XFile croppedImgFile) {
                                            setState(() {
                                              newSelectedImageFile = imgFile;
                                              newCropedImageFile =
                                                  croppedImgFile;
                                            });
                                          });
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            lightColorScheme.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      icon: const Icon(Icons.camera_alt),
                                      label: const Text(
                                        'Retake',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                              widget.imageSelectionType ==
                                      ImageSelectionType.camera
                                  ? const SizedBox.shrink()
                                  : ElevatedButton.icon(
                                      onPressed: () {
                                        imgFromGallery(context)
                                            .then((XFile imgFile) {
                                          cropImage(context, imgFile)
                                              .then((XFile croppedImgFile) {
                                            setState(() {
                                              newSelectedImageFile = imgFile;
                                              newCropedImageFile =
                                                  croppedImgFile;
                                            });
                                          });
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            lightColorScheme.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      icon: const Icon(Icons.replay_outlined),
                                      label: const Text(
                                        'Select Again',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      clipBehavior: Clip.hardEdge,
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 15,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Extra Information',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Add extra information to make the recommendation more accurate (optional)',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            maxLines: 8,
                            minLines: 8,
                            onChanged: (value) {
                              setState(() {
                                extraInfo = value;
                                extraInfoLength = value.length;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'e.g. I had this meal for breakfast',
                              alignLabelWithHint: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // add a character counter
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$extraInfoLength/$maxExtraInfoLength',
                              style: TextStyle(
                                color: extraInfoLength > maxExtraInfoLength
                                    ? Colors.red
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      showLoaderDialog(context);
                      FoodRecommendation foodRecommendation =
                          await BackendAPI.getFoodRecommendation(
                        File(newCropedImageFile.path),
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecommendationDetails(
                              foodRecommendation: foodRecommendation,
                              callback: widget.callback,
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
                    } catch (e) {
                      debugPrint('Error: $e');
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context); // Remove this line
                        showErrorDialog(context, 'An error occurred');
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightColorScheme.primary,
                    foregroundColor: Colors.white,
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
              )
            ],
          ),
        ],
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
      builder: (BuildContext context) => PopScope(
        canPop: false,
        child: alert,
      ),
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
