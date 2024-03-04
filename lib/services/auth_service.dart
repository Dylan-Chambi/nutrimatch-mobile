import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:nutrimatch_mobile/models/user_model.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? currentUser;

  factory AuthService() {
    return instance;
  }

  Stream<UserModel?> get customOnAuthStateChanged {
    return _auth.authStateChanges().transform(
          StreamTransformer<User?, UserModel?>.fromHandlers(
            handleData: (User? user, EventSink<UserModel?> sink) async {
              if (user != null) {
                currentUser = UserModel(
                  id: user.uid,
                  email: user.email!,
                  displayName: user.displayName ?? '',
                  photoURL: user.photoURL ?? '',
                  idToken: await user.getIdToken(),
                );
                sink.add(currentUser);
              } else {
                currentUser = null;
                sink.add(null);
              }
            },
            handleError: (Object error, StackTrace stackTrace,
                EventSink<UserModel?> sink) {
              debugPrint('Error: $error');
              sink.addError(error, stackTrace);
            },
            handleDone: (EventSink<UserModel?> sink) {
              sink.close();
            },
          ),
        );
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return UserModel(
        id: userCred.user!.uid,
        email: userCred.user!.email!,
        displayName: userCred.user!.displayName!,
        photoURL: userCred.user!.photoURL!,
        idToken: await userCred.user!.getIdToken(),
      );
    } catch (e) {
      debugPrint('Error: $e');
    }

    throw Exception('Sign in with Google failed.'); // Add throw statement
  }

  // Future<UserModel?> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     User? user = result.user;
  //     return UserModel(id: user!.uid, email: user.email!, displayName: '', photoUrl: '', idToken: '');
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //     return null;
  //   }
  // }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  AuthService._internal();
}
