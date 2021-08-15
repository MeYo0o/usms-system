import 'package:flutter/material.dart';

TextStyle? headTextStyle(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return Theme.of(context).textTheme.bodyText1!.copyWith(
        color: Theme.of(context).primaryColor,
        fontSize: width * 0.05,
      );
}

TextStyle? bodyTextStyle(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return Theme.of(context).textTheme.bodyText2!.copyWith(
        // color: Theme.of(context).accentColor,
        fontSize: width * 0.045,
      );
}
