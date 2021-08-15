import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/auth_provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/common/main_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';

class LeftAppDrawer extends StatelessWidget {
  const LeftAppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final dbm = Provider.of<DBM>(context);
    final auth = Provider.of<Auth>(context, listen: false);
    return Expanded(
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.01),
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    dbm.userData!['profileImage'],
                    fit: BoxFit.cover,
                    width: width * 0.1,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  dbm.userData!['fullName'],
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.01),
                Text('HR'),
              ],
            ),
            Column(
              children: [
                TileButton(tileTitle: 'Employ Requests', tileFunc: () => dbm.changeNavigatorValue(0)),
                TileButton(tileTitle: 'Jobs', tileFunc: () => dbm.changeNavigatorValue(1)),
                TileButton(tileTitle: 'Employees', tileFunc: () {}),
                TileButton(tileTitle: 'Attendance', tileFunc: () {}),
                TileButton(tileTitle: 'Employees', tileFunc: () {}),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                auth.emailSignOut();
                Navigator.of(context).pushReplacementNamed(MainScreen.id);
              },
              child: Text(
                'Sign out',
                style: TextStyle(
                  fontSize: width * 0.008,
                ),
              ),
              style: ElevatedButton.styleFrom(fixedSize: Size(width * 0.05, height * 0.02)),
            ),
          ],
        ),
      ),
    );
  }
}
