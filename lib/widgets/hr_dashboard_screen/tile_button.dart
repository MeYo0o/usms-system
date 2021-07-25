import 'package:flutter/material.dart';

class TileButton extends StatelessWidget {
  final String? tileTitle;
  final void Function()? tileFunc;
  const TileButton({@required this.tileTitle, @required this.tileFunc});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.01),
      padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.01),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextButton(
        onPressed: tileFunc,
        child: Text(
          tileTitle!,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: height * 0.015,
                color: Theme.of(context).primaryColor,
              ),
          textAlign: TextAlign.center,
        ),
        style: TextButton.styleFrom(fixedSize: Size(width * 0.05, height * 0.04)),
      ),
    );
  }
}
