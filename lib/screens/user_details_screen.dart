import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/widgets/user_details_screen/data_title.dart';
import 'package:intl/intl.dart';

class UserDetailsScreen extends StatelessWidget {
  final userData;
  UserDetailsScreen(this.userData);

  Future showAlert(String hrValue, BuildContext context) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final dbm = Provider.of<DBM>(context, listen: false);
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        title: Text(
          'Alert!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.02),
        ),
        content: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: width * 0.01),
            children: [
              TextSpan(text: 'Are you sure you want to '),
              TextSpan(
                  text: hrValue,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: width * 0.012, fontWeight: FontWeight.bold)),
              TextSpan(text: ' this user?'),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(fixedSize: Size(width * 0.06, height * 0.04)),
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.01),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    await dbm.updateUserData(userData['uid'], hrValue, context).then((value) => Navigator.of(ctx).pop());
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(width * 0.06, height * 0.04)),
                  child: Text(
                    'Yes',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.01),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final TextStyle body1 =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: width * 0.01);
    final ButtonStyle evs = ElevatedButton.styleFrom(
      // padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
      fixedSize: Size(width * 0.1, height * 0.05),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(userData['fullName']),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.07, horizontal: width * 0.07),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          userData['profileImage'],
                        ),
                      ),
                      Container(
                        height: height * 0.2,
                        margin: EdgeInsets.symmetric(vertical: height * 0.05, horizontal: width * 0.05),
                        child: Column(
                          children: [
                            if (userData['verified'] == 'verified')
                              ElevatedButton(
                                  onPressed: () => showAlert('unverify', context),
                                  style: evs,
                                  child: Text('Un Verify User ', style: body1, textAlign: TextAlign.center)),
                            if (userData['verified'] != 'verified')
                              ElevatedButton(
                                  onPressed: () => showAlert('verify', context),
                                  style: evs,
                                  child: Text('Verify User ', style: body1, textAlign: TextAlign.center)),
                            if (userData['verified'] == 'verified') SizedBox(height: height * 0.015),
                            if (userData['verified'] == 'verified')
                              ElevatedButton(
                                  onPressed: () => showAlert('employee', context),
                                  style: evs,
                                  child: Text('Employee  ', style: body1, textAlign: TextAlign.center)),
                            SizedBox(height: height * 0.015),
                            ElevatedButton(
                                onPressed: () => showAlert('delete', context),
                                style: evs,
                                child: Text('Delete User', style: body1, textAlign: TextAlign.center)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.02),
                Container(
                  margin: EdgeInsets.symmetric(vertical: height * 0.07),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white38,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DataTitle('Full Name', userData['fullName']),
                      DataTitle('Religion', userData['religion']),
                      DataTitle('Birth Day', DateFormat('dd-MM-yyyy').format(DateTime.parse(userData['birthDay']))),
                      DataTitle('Mobile Number', userData['mobileNumber']),
                      DataTitle('Address', userData['address']),
                      DataTitle('Degree', userData['degreeType']),
                      DataTitle('College', userData['collegeName']),
                      DataTitle('Graduation Year', userData['graduationYear']),
                      DataTitle('Speciality', userData['speciality']),
                      DataTitle('Nationality', userData['nationality']),
                      DataTitle('Diploma', userData['diploma']),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
