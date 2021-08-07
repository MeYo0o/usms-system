import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/jobs_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';

class HRDashboardScreen extends StatelessWidget {
  // final userData;
  // HRDashboardScreen({@required this.userData});

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    final dbm = Provider.of<DBM>(context);
    // final auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('HR Dashboard'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LeftAppDrawer(),
          if (dbm.navigator == 0) UsersScreen(),
          if (dbm.navigator == 1) JobsScreen(),
        ],
      ),
    );
  }
}
