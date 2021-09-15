import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/widgets/auth_screen/auth_screen_body.dart';
import '../../providers/dbm_provider.dart';
import '../../widgets/widget_exporter.dart';
import './checking/db_check.dart';
import 'main_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String id = 'auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final dbm = Provider.of<DBM>(context, listen: false);

    //userType dynamic login
    final userType = ModalRoute.of(context)!.settings.arguments as String;
    dbm.changeUserType(userType);
    // print(dbm.userType);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return noticeError;
          } else if (!snapshot.hasData) {
            return AuthScreenBody();
          } else if (snapshot.hasData) {
            //user is authenticated
            User? user = FirebaseAuth.instance.currentUser;
            //if the user is in hr_users ==> Navigate to HR stream data
            //if the user is in interviewers ==> Navigate to interviewers stream data
            return FutureBuilder(
              future: dbm.firestore.collection(userType).doc(user!.uid).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  return noticeError;
                }
                if (!userSnapshot.data!.exists) {
                  return noticeNotInDepartment;
                  //Trials
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                  // return MainScreen();
                  // dbm.hideNShowSnackBar(context, 'You don\'t belong to this department');
                }
                return DatabaseCheck();
              },
            );

            //OLD : Before Dynamic Login implementation.
            // return DatabaseCheck();
          }
          return AuthScreenBody();
        },
      ),
    );
  }
}
