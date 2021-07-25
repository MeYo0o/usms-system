import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/auth_screen.dart';
import 'package:usms/screens/hr_dashboard_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';

class LoadHRData extends StatelessWidget {
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
          return HRDashboardScreen();
        }
        return AuthScreen();
      },
    );
  }
}
