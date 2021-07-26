import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/user_details_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';

class JobDetailsScreen extends StatelessWidget {
  final jobData;
  JobDetailsScreen(this.jobData);

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
              TextSpan(text: ' this job?'),
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
                    await dbm.deleteJob(context, jobData['uid']).then((_) {
                      Navigator.of(ctx).pop();
                      Navigator.of(ctx).pop();
                    });
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
    final dbm = Provider.of<DBM>(context, listen: false);

    final TextStyle body1 =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: width * 0.01);
    final ButtonStyle evs = ElevatedButton.styleFrom(
      // padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
      fixedSize: Size(width * 0.08, height * 0.04),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(jobData['jobName']),
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey,
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        jobData['jobName'],
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontFamily: 'OtomanopeeOne', fontWeight: FontWeight.bold, fontSize: width * 0.03),
                      ),
                      SizedBox(height: height * 0.03),
                      ElevatedButton(
                          onPressed: () => showAlert('Delete', context),
                          style: evs,
                          child: Text('Delete Job ', style: body1, textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: height * 0.5,
                    width: width * 0.5,
                    margin: EdgeInsets.symmetric(vertical: height * 0.07),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white38,
                    ),
                    child: ListView.separated(
                      itemCount: jobData['requests'].length,
                      itemBuilder: (context, i) => StreamBuilder<DocumentSnapshot>(
                        stream: dbm.firestore.collection('users').doc(jobData['requests'][i]).snapshots(),
                        builder: (context, AsyncSnapshot<DocumentSnapshot> userData) {
                          if (userData.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (userData.hasError) {
                            return noticeError;
                          }
                          final singleUserData = userData.data!;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).accentColor.withOpacity(0.5),
                            ),
                            child: ListTile(
                              key: ValueKey(singleUserData.get('fullName')),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  singleUserData.get('profileImage'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(singleUserData.get('fullName')),
                              subtitle: Text(singleUserData.get('degreeType') + ' - ' + singleUserData.get('speciality')),
                              trailing: Icon(Icons.arrow_forward_ios),
                              contentPadding: const EdgeInsets.all(3),
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserDetailsScreen(singleUserData))),
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, i) => Divider(),
                    ),
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
