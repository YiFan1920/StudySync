import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:productivity_app_v1/main.dart';
import 'package:productivity_app_v1/services/db_service.dart';
import 'package:productivity_app_v1/ui/screens/landing_screen/landing_screen.dart';
import 'package:productivity_app_v1/ui/screens/login_screen/login_screen.dart';

class AuthService {
  Future<void> signUp(
      {required String email,
      required String password,
      required String username,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the UID of the registered user
      String uid = userCredential.user!.uid;

      DbService.createUser(uid: uid, email: email, username: username);
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LandingScreen(
                    username: username,
                  )));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = "An account already exists with that email.";
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> logIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Get the UID of the logged-in user
      String uid = userCredential.user!.uid;

      String username = await DbService.readUser(uid: uid);

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LandingScreen(username: username)));
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided for that user.";
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 14,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> signOut({required BuildContext context}) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
