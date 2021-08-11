import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class GridItem extends StatelessWidget {
  final Color? color;
  final String? title, imageTitle;
  final void Function()? func;

  GridItem({
    @required this.title,
    @required this.imageTitle,
    @required this.func,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: width > 1700
          ? const EdgeInsets.all(30.0)
          : width > 1520
              ? const EdgeInsets.all(20.0)
              : width > 1000
                  ? const EdgeInsets.all(10.0)
                  : EdgeInsets.zero,
      child: InkWell(
        child: Card(
          margin: const EdgeInsets.all(10),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              ClipRRect(
                child: Image(
                  width: double.infinity,
                  image: AssetImage('assets/images/$imageTitle'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              Positioned(
                width: width > 700
                    ? width * 0.15
                    : width > 500
                        ? width * 0.2
                        : width * 0.32,
                bottom: width * 0.01,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$title',
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width > 700
                          ? width * 0.015
                          : width > 500
                              ? width * 0.023
                              : width * 0.04,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: func,
      ),
    );
  }
}
