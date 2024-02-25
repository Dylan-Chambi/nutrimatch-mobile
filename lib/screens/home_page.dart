import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutrimatch_mobile/api/backend_api.dart';
import 'package:nutrimatch_mobile/components/recommendation_card.dart';
import 'package:nutrimatch_mobile/models/food_recommendation.dart';
import 'package:nutrimatch_mobile/models/user_model.dart';
import 'package:nutrimatch_mobile/screens/upload_image.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});
  final UserModel user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final picker = ImagePicker();

  final db = FirebaseFirestore.instance;

  late UserModel _user;
  late Future<List<FoodRecommendation>> _foodRecommendations;

  bool _isLoading = false;

  String searchBarText = '';

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _foodRecommendations = BackendAPI.getFoodRecommendations();
  }

  void updateRecommendations() {
    setState(() {
      _isLoading = true;
    });

    BackendAPI.getFoodRecommendations().then((value) {
      setState(() {
        _foodRecommendations = Future.value(value);
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('lib/assets/images/drawer_header.jpg'),
                  fit: BoxFit.cover,
                )),
                accountName: Text(_user.displayName),
                accountEmail: Text(_user.email),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(_user.photoURL),
                ),
              ),
              ListTile(
                title: const Text('Profile'),
                leading: const Icon(Icons.person),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Sign Out'),
                leading: const Icon(Icons.logout),
                onTap: () async {
                  await signOut();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(
                    Icons.sort,
                    size: 30,
                    color: lightColorScheme.primary,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Text(
              'NutriMatch',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: lightColorScheme.primary,
              ),
            ),
            centerTitle: true,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFf2f2f2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          searchBarText = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search for recommendations',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Center(
                        child: FutureBuilder<List<FoodRecommendation>>(
                          future: _foodRecommendations,
                          builder: (context, snapshot) {
                            if (snapshot.hasData && !_isLoading) {
                              final filteredRecommendations = snapshot.data!
                                  .where((recommendation) => recommendation
                                      .shortFoodName!
                                      .toLowerCase()
                                      .contains(searchBarText.toLowerCase()))
                                  .toList();
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemCount: filteredRecommendations.length,
                                itemBuilder: (context, index) {
                                  return RecommendationCard(
                                    foodRecommendation:
                                        filteredRecommendations[index],
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return const Text(
                                  'Could not load recommendations');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDialFabWidget(
        primaryIconCollapse: Icons.add,
        primaryIconExpand: Icons.add,
        rotateAngle: 0,
        secondaryIconsList: const [
          Icons.image,
          Icons.camera_alt,
        ],
        secondaryIconsText: const [
          "Gallery",
          "Camera",
        ],
        secondaryIconsOnPress: [
          () => _imgFromGallery(),
          () => _imgFromCamera(),
        ],
        secondaryBackgroundColor: Colors.white,
        secondaryForegroundColor: lightColorScheme.primary,
        primaryBackgroundColor: lightColorScheme.primary,
        primaryForegroundColor: Colors.white,
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    const String title = 'Crop to fit your food';
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: title,
              toolbarColor: Colors.white,
              toolbarWidgetColor: lightColorScheme.primary,
              activeControlsWidgetColor: lightColorScheme.primary,
              dimmedLayerColor: Colors.black.withOpacity(0.5),
              backgroundColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: title,
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadImage(
                imageFile: File(croppedFile.path),
                callback: updateRecommendations),
          ),
        );
      });
    }
  }
}
