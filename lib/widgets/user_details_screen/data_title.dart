import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataTitle extends StatelessWidget {
  final String? titleName, titleData;
  DataTitle(this.titleName, this.titleData);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * 0.4,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).accentColor.withOpacity(0.5),
      ),
      child: Row(
        children: [
          SelectableText(
            '$titleName :',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
          ),
          SelectableText(
            '$titleData',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
