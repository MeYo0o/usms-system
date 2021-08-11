import 'package:flutter/material.dart';
import 'package:usms/screens/common/auth_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';

class MainScreen extends StatelessWidget {
  static const String id = 'main_screen';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ultimate School Management System'),
        centerTitle: true,
      ),
      backgroundColor: Colors.brown[200],
      body: GridView.count(
        crossAxisCount: width > 700
            ? 4
            : width > 500
                ? 3
                : 2,
        shrinkWrap: true,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          GridItem(title: 'Accounting', imageTitle: 'Acc.png', func: () {}),
          GridItem(title: 'Bus', imageTitle: 'Bus.jpg', func: () {}),
          GridItem(
              title: 'HR',
              imageTitle: 'Hr.jpg',
              func: () => Navigator.of(context).pushNamed(AuthScreen.id, arguments: 'hr_users')),
          GridItem(
              title: 'Education',
              imageTitle: 'Education.jpg',
              func: () => Navigator.of(context).pushNamed(AuthScreen.id, arguments: 'interviewers')),
          GridItem(title: 'Events', imageTitle: 'Events.jpg', func: () {}),
          GridItem(title: 'IT', imageTitle: 'IT.jpg', func: () {}),
          GridItem(title: 'Security', imageTitle: 'Security.jpg', func: () {}),
          GridItem(title: 'Owner', imageTitle: 'Owner.jpg', func: () {}),
          GridItem(title: 'Admin', imageTitle: 'Admin.jpg', func: () {}),
        ],
      ),
    );
  }
}
