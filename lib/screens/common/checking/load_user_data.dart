import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/common/auth_screen.dart';
import 'package:usms/screens/education/interviewers/interviewer_profile_screen.dart';
import 'package:usms/screens/hr/hr_dashboard_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';

class LoadUserData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbm = Provider.of<DBM>(context, listen: false);
    return FutureBuilder(
      future: dbm.getUserData(),
      builder: (context, userData) {
        if (userData.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (userData.hasError) {
          return noticeError;
        } else if (userData.hasData) {
          if (dbm.userType == 'hr_users') {
            return HRDashboardScreen();
          }
          if (dbm.userType == 'interviewers') {
            return InterviewerProfileScreen();
          }
        }
        return AuthScreen();
      },
    );
  }
}
