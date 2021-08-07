import 'package:flutter/material.dart';
import '../../screens/auth_screen.dart';

class NoticeScreen extends StatelessWidget {
  final IconData? iconData;
  final Color? iconColor;
  final String? headText, bodyText;
  NoticeScreen({
    @required this.headText,
    @required this.bodyText,
    @required this.iconData,
    @required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  color: iconColor,
                  size: width * 0.25,
                ),
                SizedBox(height: height * 0.04),
                Text(
                  '$headText',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.1),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  '$bodyText',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: width * 0.07),
                ),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  child: Text('Go Back'),
                  onPressed: () => Navigator.of(context).pushReplacementNamed(AuthScreen.id),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
