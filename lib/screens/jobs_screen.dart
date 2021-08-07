import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/auth_screen.dart';
import 'package:usms/widgets/jobs_screen/jobs_bottom_screen_list.dart';
import 'package:usms/widgets/jobs_screen/jobs_right_upper_container.dart';
import 'package:usms/widgets/widget_exporter.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({Key? key}) : super(key: key);

  int calculateRequests(jobsData) {
    int requests = 0;
    jobsData.data!.docs.forEach((job) {
      requests += job['requests'].length as int;
    });
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final dbm = Provider.of<DBM>(context);

    return Expanded(
      flex: 6,
      child: Container(
        padding: EdgeInsets.all(width * 0.01),
        decoration: BoxDecoration(color: Color(0xffEBEBEB)),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: dbm.firestore.collection('jobs').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> jobsData) {
                    if (jobsData.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (jobsData.hasError) {
                      return noticeError;
                    } else if (!jobsData.hasData) {
                      return Center(
                        child: Text('No Users Registered Yet!'),
                      );
                    } else if (jobsData.hasData) {
                      final int jobsNumber = jobsData.data!.docs.length;
                      final int jobsRequests = calculateRequests(jobsData);
                      //print each job id === uid
                      // jobsData.data!.docs.forEach((job) => print(job.id));

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          JobsRightUpperContainer(jobsNumber: jobsNumber, jobsRequests: jobsRequests),
                          JobsBottomScreenList(jobsData),
                        ],
                      );
                    }
                    return AuthScreen();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
