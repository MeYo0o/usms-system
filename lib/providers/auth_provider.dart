import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  //To get current user changes
  User? get getUser {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  //Email Signup
  Future<void> emailSignUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email + '@qls-egypt.com', password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that username.');
      } else {
        throw ('Network Error, Check Your Internet Connection.');
      }
    } catch (e) {
      print(e);
    }
  }

  //Email Signin
  Future<void> emailSignIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email + '@qls-egypt.com', password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ('No user found.');
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password.');
      } else {
        throw ('Network Error, Check Your Internet Connection.');
      }
    } catch (e) {
      print(e);
    }
  }

  //Email Signout
  Future<void> emailSignOut() async {
    await FirebaseAuth.instance.signOut();
    // notifyListeners();
  }
}
