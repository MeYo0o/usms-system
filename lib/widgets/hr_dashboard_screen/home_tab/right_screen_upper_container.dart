import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:intl/intl.dart';

class RightScreenUpperContainer extends StatelessWidget {
  final int requestNumber;
  RightScreenUpperContainer(this.requestNumber);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final dbm = Provider.of<DBM>(context);
    return Expanded(
      flex: 3,
      child: Container(
        // margin: EdgeInsets.all(width * 0.01),
        padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.01),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffC1BFC5),
              Color(0xffCBC9CF),
              Color(0xffD5D4D9),
              Color(0xffDFDFE2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.25, 0.5, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RichText(
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome : ',
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.03),
                  ),
                  TextSpan(
                    text: dbm.userData['fullName'],
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontFamily: 'OtomanopeeOne', fontSize: width * 0.03),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Today is : ',
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.02),
                  ),
                  TextSpan(
                    text: '${DateFormat('EEEE').format(DateTime.now())} ',
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontFamily: 'OtomanopeeOne', fontSize: width * 0.02),
                  ),
                  TextSpan(
                    text: '( ${DateFormat('dd-MM-yyyy').format(DateTime.now())} )',
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: width * 0.02),
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'You have : ',
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.02),
                  ),
                  TextSpan(
                    text: '$requestNumber Requests',
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontFamily: 'OtomanopeeOne', fontSize: width * 0.02),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
