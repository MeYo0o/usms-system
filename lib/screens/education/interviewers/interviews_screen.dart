import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:usms/constants/text_styles.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/education/interviewers/user_interview_details_screen.dart';
import 'package:usms/widgets/common_widgets/notice_data.dart';

class InterviewsScreen extends StatelessWidget {
  static const String id = 'interviews_screen';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final dbm = Provider.of<DBM>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Interviews'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: ListView.separated(
            itemCount: dbm.userData['interviews'].length,
            itemBuilder: (context, i) => StreamBuilder<QuerySnapshot>(
              stream:
                  dbm.firestore.collection('users').where('uid', isEqualTo: dbm.userData['interviews'][i]).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> usersData) {
                if (usersData.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (usersData.hasError) {
                  return noticeError;
                }
                final userData = usersData.data!.docs[0];
                // print(userData['profileImage']);
                return InkWell(
                  onTap: () {
                    //the candidate is rejected already by the interviewer so no interaction is permitted.
                    if (userData['rejection']['interviewerId'] == dbm.userData['uid']) {
                      dbm.hideNShowSnackBar(context, 'You already rejected this candidate.');
                    }
                    //the candidate is accepted and has scheduled Interview already
                    else if (userData['scheduledInterview']['interviewerId'] == dbm.userData['uid']) {
                      //must not be able to reject or schedule another interview
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserInterviewDetailsScreen(
                                userData: userData,
                                userExists: true,
                              )));
                    }
                    //the candidate is new to the interviewer or still in consideration(neither accepted nor rejected).
                    else {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => UserInterviewDetailsScreen(userData: userData)));
                    }

                    //Ignore all - first initialization test case
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (context) => UserInterviewDetailsScreen(userData: userData)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: userData['rejection']['interviewerId'] == dbm.userData['uid']
                          ? Colors.red[200]
                          : Colors.grey[300],
                    ),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CircleAvatar(
                            radius: width * 0.12,
                            child: Image.network(
                              userData['profileImage'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.035),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userData['fullName'], style: headTextStyle(context)),
                                SizedBox(height: height * 0.01),
                                Text(
                                  '${userData['degreeType']} : ${userData['speciality']}',
                                  style: bodyTextStyle(context),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            separatorBuilder: (context, i) => SizedBox(
              height: height * 0.01,
            ),
          ),
        ),
      ),
    );
  }
}
