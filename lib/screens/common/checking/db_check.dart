import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/common/checking/load_user_data.dart';
import 'package:usms/screens/common/main_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';
import '../mandatory_signup_screen.dart';

class DatabaseCheck extends StatefulWidget {
  static const String id = 'db_check';

  @override
  _DatabaseCheckState createState() => _DatabaseCheckState();
}

class _DatabaseCheckState extends State<DatabaseCheck> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      final dbm = Provider.of<DBM>(context, listen: false);
      //OLD : before dynamic login implementation.
      // await dbm.getUserType();
      if (dbm.userType == 'hr_users') {
        await dbm.getInterviewers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final dbm = Provider.of<DBM>(context, listen: false);
    //summon userType -- uncomment for final release
    // dbm.getUserType();
    // print('you are looking for : ${dbm.userType}');
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: dbm.firestore.collection(dbm.userType!).doc(user!.uid).snapshots(),
          builder: (context, AsyncSnapshot? snapshot) {
            if (snapshot!.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return noticeError;
            }
            if (!snapshot.hasData) {
              if (dbm.userType == 'hr_users') {
                if (kIsWeb) {
                  return noticeNoData;
                } else {
                  return MandatorySignUpScreen(isEditMode: false);
                }
              }
              return MandatorySignUpScreen(isEditMode: false);
            }
            if (snapshot.hasData) {
              if (!snapshot.data.exists) {
                if (dbm.userType == 'hr_users') {
                  if (kIsWeb) {
                    return noticeNoData;
                  } else {
                    return MandatorySignUpScreen(isEditMode: false);
                  }
                }
                return MandatorySignUpScreen(isEditMode: false);
              }
              if (snapshot.data.exists) {
                if (dbm.userType == 'hr_users') {
                  return kIsWeb ? LoadUserData() : noticeDataCompleted;
                }
                //return according screen
                return LoadUserData();
              }
            }
            return MainScreen();
          },
        ),
      ),
    );
  }
}
