import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/checking/load_hr_data.dart';
import 'package:usms/screens/main_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';
import '../auth_screen.dart';
import '../mandatory_signup_screen.dart';

class HRDataCheck extends StatelessWidget {
  static const String id = 'hr_db_check';

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final dbm = Provider.of<DBM>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: dbm.firestore.collection('hr_users').doc(user!.uid).get(),
          builder: (context, AsyncSnapshot? snapshot) {
            if (snapshot!.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return noticeError;
            }
            if (!snapshot.hasData) {
              if (kIsWeb) {
                return noticeHRNoData;
              } else {
                return MandatorySignUpScreen(isEditMode: false);
              }
            }
            if (snapshot.hasData) {
              if (!snapshot.data.exists) {
                if (kIsWeb) {
                  return noticeHRNoData;
                } else {
                  return MandatorySignUpScreen(isEditMode: false);
                }
              }
              if (snapshot.data.exists) {
                return kIsWeb ? LoadHRData() : noticeHRDataCompleted;
              }
            }
            return MainScreen();
          },
        ),
      ),
    );
  }
}
