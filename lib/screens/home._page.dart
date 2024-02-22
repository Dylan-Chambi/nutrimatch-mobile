import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrimatch_mobile/screens/welcome_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

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
  }

  @override
  Widget build(BuildContext context) {
    // add a simple logout button
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Welcome ${_user?.displayName}'),
            _user?.photoURL != null && _user?.photoURL != ''
                ? Image.network(_user!.photoURL!)
                : const SizedBox(),
            ElevatedButton(
              onPressed: signOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
