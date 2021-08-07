import 'package:flutter/material.dart';

class HeadTitle extends StatelessWidget {
  final String? headText;
  const HeadTitle(this.headText);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Text(headText!,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(fontFamily: 'OtomanopeeOne', fontSize: width * 0.02, color: Theme.of(context).primaryColor),
        textAlign: TextAlign.center);
  }
}
