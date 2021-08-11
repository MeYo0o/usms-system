import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final String? leftText, rightText;
  final Color? rightColor;
  final void Function()? tileFunc;
  ProfileTile({
    @required this.leftText,
    @required this.rightText,
    this.rightColor = Colors.amber,
    this.tileFunc,
  });
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: tileFunc,
      splashColor: Colors.blueGrey[100],
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '$leftText',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: kIsWeb ? width * 0.01 : width * 0.04,
                    ),
              ),
            ),
            if (leftText != 'Edit Profile') SizedBox(width: width * 0.1),
            if (leftText != 'Edit Profile')
              Expanded(
                child: Card(
                  color: rightColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$rightText',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: kIsWeb ? width * 0.01 : width * 0.04,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
