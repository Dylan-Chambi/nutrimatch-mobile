import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/theme/theme.dart';
import 'package:nutrimatch_mobile/tree/auth_tree.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  //Ensuring FlutterBinding
  WidgetsFlutterBinding.ensureInitialized();

  //Initializing Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Setting Firebase Emulator
  // await FirebaseAuth.instance.useAuthEmulator('192.168.0.30', 9099);

  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light));

  //Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);

  //Running the App
  runApp(const NutriMatchApp());
}

class NutriMatchApp extends StatelessWidget {
  const NutriMatchApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriMatch',
      theme: lightMode,
      debugShowCheckedModeBanner: false,
      home: const AuthWidgetTree(),
    );
  }
}
