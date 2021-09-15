import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/auth_provider.dart';

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
    final auth = Provider.of<Auth>(context, listen: false);
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
                  size: kIsWeb ? width * 0.1 : width * 0.25,
                ),
                SizedBox(height: height * 0.04),
                Text(
                  '$headText',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: kIsWeb ? width * 0.03 : width * 0.1),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  '$bodyText',
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.headline4!.copyWith(fontSize: kIsWeb ? width * 0.02 : width * 0.07),
                ),
                SizedBox(height: height * 0.02),
                ElevatedButton(
                  child: Text('Go Back'),
                  onPressed: () async {
                    await auth.emailSignOut();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: kIsWeb ? width * 0.015 : width * 0.05, fontWeight: FontWeight.bold),
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
