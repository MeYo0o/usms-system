import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final dbm = Provider.of<DBM>(context);

    return Expanded(
      flex: 5,
      child: Container(
        padding: EdgeInsets.all(width * 0.01),
        decoration: BoxDecoration(color: Color(0xffEBEBEB)),
        child: Column(children: [Text('Jobs Screen')]),
      ),
    );
  }
}
