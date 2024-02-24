import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/models/user_model.dart';
import 'package:nutrimatch_mobile/screens/home_page.dart';
import 'package:nutrimatch_mobile/screens/welcome_screen.dart';
import 'package:nutrimatch_mobile/services/auth_service.dart';

class AuthWidgetTree extends StatefulWidget {
  const AuthWidgetTree({super.key});

  @override
  State<AuthWidgetTree> createState() => _AuthWidgetTreeState();
}

class _AuthWidgetTreeState extends State<AuthWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: AuthService.instance.customOnAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return snapshot.hasData
              ? HomePage(user: snapshot.data!)
              : const WelcomeScreen();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
