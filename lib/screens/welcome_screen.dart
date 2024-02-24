import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/screens/home_page.dart';
import 'package:nutrimatch_mobile/screens/signin_screen.dart';
import 'package:nutrimatch_mobile/screens/signup_screen.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';
import 'package:nutrimatch_mobile/components/custom_scaffold.dart';
import 'package:nutrimatch_mobile/components/welcome_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser == null) {
      _auth.authStateChanges().listen((user) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        IdTokenResult? idTokenResult = await user?.getIdTokenResult();
        if (user != null && idTokenResult?.token != null) {
          log('idTokenResult: ${idTokenResult?.token}');
          prefs.setString('uid', user.uid);
          prefs.setString('idToken', idTokenResult!.token!);

          if (!context.mounted) return;
          // Clear the stack and start the home page.
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
      });
    }
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
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Welcome to NutriMatch\n',
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            )),
                        TextSpan(
                            text: '\nPowered by AI!',
                            style: TextStyle(
                              fontSize: 20,
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(bottom: 30.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign in',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
                        },
                        color: Colors.transparent,
                        textColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        color: Colors.white,
                        textColor: lightColorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
