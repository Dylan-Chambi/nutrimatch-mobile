import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutrimatch_mobile/api/backend_api.dart';
import 'package:nutrimatch_mobile/components/recommendation_card.dart';
import 'package:nutrimatch_mobile/models/food_recommendation.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrimatch_mobile/screens/welcome_screen.dart';
import 'dart:developer';

class ExampleItem {
  final String imageURL;
  final String title;
  final String description;

  ExampleItem({
    required this.imageURL,
    required this.title,
    required this.description,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  List<FoodRecommendation> _foodRecommendations = [];
  List<FoodRecommendation> _searchFoodRecommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false);
      }

      IdTokenResult? idTokenResult = await user?.getIdTokenResult();
      if (user != null && idTokenResult?.token != null) {
        log('idTokenResult: ${idTokenResult?.token}');
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('uid', user.uid);
        prefs.setString('idToken', idTokenResult!.token!);
      }
      setState(() {
        _user = user;
      });
    });
    _auth.idTokenChanges().listen((event) async {
      if (event == null) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('uid');
        prefs.remove('idToken');
      }
    });
    _getFoodRecommendations();
  }

  Future<void> _getFoodRecommendations() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idToken = prefs.getString('idToken');
      if (idToken == null) {
        return;
      }

      List<FoodRecommendation> foodRecommendations =
          await BackendAPI.getFoodRecommendations(idToken);

      setState(() {
        _foodRecommendations = foodRecommendations;
        _searchFoodRecommendations = foodRecommendations;
        _isLoading = false;
      });
    } catch (e) {
      log('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  onFoodRecommendationSearch(String query) {
    setState(() {
      _searchFoodRecommendations = _foodRecommendations
          .where((foodRecommendation) => foodRecommendation.shortFoodName!
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
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
                accountName: Text(_user?.displayName ?? ''),
                accountEmail: Text(_user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(_user?.photoURL ?? ''),
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
      body: Expanded(
        child: Column(
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
            // add a subtitle with the following text: "Your recommendations" aligned to the left
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
                // add a container to the bottom of the screen
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
                        onChanged: onFoodRecommendationSearch,
                        decoration: const InputDecoration(
                          hintText: 'Search for recommendations',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),

                    // Make a scrollable list of example items
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : _foodRecommendations.isEmpty
                                ? const Center(
                                    child:
                                        Text('No food recommendations found'),
                                  )
                                : ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 20);
                                    },
                                    itemCount:
                                        _searchFoodRecommendations.length,
                                    itemBuilder: (context, index) {
                                      return RecommendationCard(
                                          foodRecommendation:
                                              _searchFoodRecommendations[
                                                  index]);
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightColorScheme.primary,
        tooltip: 'Add a new food recommendation',
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
