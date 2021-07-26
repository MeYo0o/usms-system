import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usms/screens/job_details_screen.dart';

class JobsBottomScreenList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> jobsData;
  const JobsBottomScreenList(this.jobsData);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Expanded(
      flex: 5,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white54,
        ),
        child: Scrollbar(
          isAlwaysShown: true,
          child: ListView.builder(
            itemCount: jobsData.data!.docs.length,
            itemBuilder: (context, i) {
              final job = jobsData.data!.docs[i];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).accentColor.withOpacity(0.5),
                ),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        job['jobName'],
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontFamily: 'OtomanopeeOne', fontWeight: FontWeight.bold, fontSize: width * 0.015),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: width * 0.015,
                        child: Text(
                          '${job['requests'].length}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.01),
                        ),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobDetailsScreen(job))),
                ),
              );

              return Container();
            },
          ),
        ),
      ),
    );
  }
}
