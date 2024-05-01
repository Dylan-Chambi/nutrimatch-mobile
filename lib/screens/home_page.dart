import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutrimatch_mobile/api/backend_api.dart';
import 'package:nutrimatch_mobile/components/recommendation_card.dart';
import 'package:nutrimatch_mobile/components/speed_dial_fab.dart';
import 'package:nutrimatch_mobile/models/food_recommendation.dart';
import 'package:nutrimatch_mobile/models/image_selection_type.dart';
import 'package:nutrimatch_mobile/models/user_model.dart';
import 'package:nutrimatch_mobile/screens/upload_image.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrimatch_mobile/utils/images.dart';

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

  @override
  void didChangeDependencies() {
    // Adjust the provider based on the image type
    precacheImage(
        const AssetImage('lib/assets/images/drawer_header.jpg'), context);
    precacheImage(NetworkImage(_user.photoURL), context);
    super.didChangeDependencies();
  }

  void updateRecommendationsLoading() {
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

  Future<void> updateRecommendationsRefresh() {
    setState(() {
      _foodRecommendations = BackendAPI.getFoodRecommendations();
    });
    return _foodRecommendations;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
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
      body: Column(
        children: [
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
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                            return RefreshIndicator(
                              onRefresh: updateRecommendationsRefresh,
                              backgroundColor: Colors.white,
                              color: lightColorScheme.primary,
                              child: Container(
                                constraints: const BoxConstraints.expand(),
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 15),
                                  itemCount: filteredRecommendations.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return RecommendationCard(
                                      foodRecommendation:
                                          filteredRecommendations[index],
                                    );
                                  },
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Could not load recommendations');
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
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
          () => imgFromGallery(context).then((XFile imgFile) {
                cropImage(context, imgFile).then((XFile croppedImgFile) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadImage(
                        imageSelectionType: ImageSelectionType.gallery,
                        originalImageFile: imgFile,
                        croppedImageFile: croppedImgFile,
                        callback: updateRecommendationsLoading,
                      ),
                    ),
                  );
                });
              }),
          () => imgFromCamera(context).then((XFile imgFile) {
                debugPrint('Image file: $imgFile');
                cropImage(context, imgFile).then((XFile croppedImgFile) {
                  debugPrint('Cropped image file: $croppedImgFile');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadImage(
                        imageSelectionType: ImageSelectionType.camera,
                        originalImageFile: imgFile,
                        croppedImageFile: croppedImgFile,
                        callback: updateRecommendationsLoading,
                      ),
                    ),
                  );
                });
              }),
        ],
        secondaryBackgroundColor: lightColorScheme.secondary,
        secondaryForegroundColor: Colors.white,
        primaryBackgroundColor: lightColorScheme.primary,
        primaryForegroundColor: Colors.white,
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
