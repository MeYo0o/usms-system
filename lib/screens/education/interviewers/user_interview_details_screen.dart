import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/constants/text_styles.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:intl/intl.dart';
import 'package:usms/widgets/mandatory_signup_screen/form_tile.dart';

class UserInterviewDetailsScreen extends StatelessWidget {
  final userData;
  bool? userExists = false;
  UserInterviewDetailsScreen({this.userData, this.userExists});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // final dbm = Provider.of<DBM>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Candidate Profile'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CircleAvatar(
                      radius: width * 0.3,
                      child: Image.network(
                        userData['profileImage'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey[200],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dataTile(context, 'Name', userData['fullName']),
                        dataTile(
                            context, 'BirthDay', DateFormat('dd-MM-yyyy').format(DateTime.parse(userData['birthDay']))),
                        dataTile(context, 'College', userData['collegeName']),
                        dataTile(context, 'Degree', userData['degreeType']),
                        dataTile(context, 'Speciality', userData['speciality']),
                        dataTile(context, 'Mobile', userData['mobileNumber']),
                        dataList(context, userData['experiences'], 0),
                        dataList(context, userData['personalAbilities'], 1),
                        dataList(context, userData['peopleToRefer'], 2),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //in case user exists (rejected or accepted) , no need to reject nor schedule an interview
                            if (userData['scheduledInterview']['interviewerId'] == '' &&
                                userData['rejection']['interviewerId'] == '')
                              ElevatedButton(
                                  onPressed: () => _showDialog(context, 0),
                                  child: Text('Reject Candidate', style: TextStyle(fontWeight: FontWeight.bold))),
                            if (userData['scheduledInterview']['interviewerId'] == '' &&
                                userData['rejection']['interviewerId'] == '')
                              SizedBox(width: width * 0.1),
                            if (userData['scheduledInterview']['interviewerId'] == '' &&
                                userData['rejection']['interviewerId'] == '')
                              ElevatedButton(
                                  onPressed: () => _showDialog(context, 1),
                                  child: Text(
                                      'Schedule '
                                      'Interview',
                                      style: TextStyle(fontWeight: FontWeight.bold))),
                            //show the Employ Button in case this candidate has interview in process and the date
                            // time for that interview is went by (meaning the interview is whether today or any day
                            // after)
                            if (userData['scheduledInterview']['interviewerId'] != '')
                              if (DateTime.now()
                                      .difference(DateTime.parse(userData['scheduledInterview']['dayTime']))
                                      .inDays >=
                                  0)
                                ElevatedButton(
                                    onPressed: () => _showDialog(context, 0),
                                    child: Text('Reject Candidate', style: TextStyle(fontWeight: FontWeight.bold))),
                            if (userData['scheduledInterview']['interviewerId'] != '')
                              if (DateTime.now()
                                      .difference(DateTime.parse(userData['scheduledInterview']['dayTime']))
                                      .inDays >=
                                  0)
                                SizedBox(width: width * 0.03),
                            if (userData['scheduledInterview']['interviewerId'] != '')
                              if (DateTime.now()
                                      .difference(DateTime.parse(userData['scheduledInterview']['dayTime']))
                                      .inDays >=
                                  0)
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Text('Employ Candidate', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column dataList(BuildContext context, Map mapList, int listIndex) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Center(
          child: Text(
            listIndex == 0
                ? 'Experiences'
                : listIndex == 1
                    ? 'PersonalAbilities'
                    : 'People To Refer',
            style: headTextStyle(context)!
                .copyWith(fontSize: width * 0.08, color: Colors.purple, fontFamily: 'OtomanopeeOne'),
            overflow: TextOverflow.ellipsis,
            // textAlign: TextAlign.center,
          ),
        ),
        Container(
          height: height * 0.3,
          width: width * 0.85,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.yellow[200], borderRadius: BorderRadius.circular(15)),
          child: ListView.separated(
            itemCount: mapList.length,
            itemBuilder: (context, i) {
              if (listIndex == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dataTile(context, 'School', mapList.keys.elementAt(i)),
                    dataTile(context, 'Reason For Leaving', mapList.values.elementAt(i)[0]),
                    dataTile(context, 'Time Period', '${mapList.values.elementAt(i)[1]} year/s'),
                    // dataTile(context, 'Salary', userData['experiences'].values.elementAt(i)[2]),
                  ],
                );
              } else if (listIndex == 1) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dataTile(context, 'Skill/Ability', mapList.keys.elementAt(i)),
                    dataTile(context, 'Level', mapList.values.elementAt(i)[0]),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dataTile(context, 'Name', mapList.keys.elementAt(i)),
                    dataTile(context, 'Kinship', mapList.values.elementAt(i)[0]),
                  ],
                );
              }
            },
            separatorBuilder: (context, i) => Divider(
              color: Colors.green,
              thickness: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget dataTile(BuildContext context, String leftText, String rightText) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: [
              Text('$leftText : ', style: headTextStyle(context)),
              SizedBox(width: width * 0.01),
              SelectableText(
                rightText,
                style: bodyTextStyle(context),
              ),
            ],
          ),
          SizedBox(height: height * 0.01),
        ],
      ),
    );
  }

  Future<void> _showDialog(BuildContext context, int dialogIndex) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final formKey = GlobalKey<FormState>();
    final messageCont = TextEditingController();
    final hourTime = TextEditingController();
    DateTime? dayTime;
    final dbm = Provider.of<DBM>(context, listen: false);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AlertDialog(
            // actionsPadding: EdgeInsets.symmetric(horizontal: width * 0.17),
            scrollable: true,

            title: Text(
              dialogIndex == 0 ? 'Reject Candidate' : 'Schedule Interview',
              textAlign: TextAlign.center,
              style: headTextStyle(context),
            ),
            content: dialogIndex == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Please Mention why this candidate is not eligible.',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: height * 0.01),
                      Text('Note that both HR & The Candidate will see this message , so write your words carefully.',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: height * 0.01),
                      Form(
                        key: formKey,
                        child: FormTile(
                          controller: messageCont,
                          fieldName: 'Enter Your Opinion about this candidate',
                          inputType: TextInputType.multiline,
                          action: TextInputAction.done,
                          maxLines: 3,
                          // action: TextInputAction.done,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Please Make an Appointment with the candidate such as Date & Time , along with some notes for '
                        'where the interview is going to occur and what to be expected from the candidate to prepare',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: height * 0.01),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.yellow[100]),
                              child: Row(
                                children: [
                                  Text(dayTime == null
                                      ? 'Date isn\'t set yet'
                                      : DateFormat('dd-MM-yyyy').format(dayTime!)),
                                  Spacer(),
                                  ElevatedButton(
                                      child: Text('Pick Date'),
                                      onPressed: () {
                                        setState(() {
                                          _showDate(context).then((value) {
                                            if (value != null)
                                              setState(() {
                                                dayTime = value;
                                              });
                                          });
                                        });
                                      }),
                                ],
                              ),
                            ),
                            FormTile(
                              fieldName: 'Time in hours (ex : 12:30 PM)',
                              controller: hourTime,
                              inputType: TextInputType.text,
                              action: TextInputAction.next,
                            ),
                            SizedBox(height: height * 0.01),
                            FormTile(
                              controller: messageCont,
                              fieldName: 'Note to the candidate (use . to separate lines)',
                              inputType: TextInputType.multiline,
                              action: TextInputAction.done,
                              maxLines: 3,
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                    ],
                  ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(fixedSize: Size(width * 0.23, height * 0.05)),
              ),
              SizedBox(width: width * 0.02),
              ElevatedButton(
                onPressed: dialogIndex == 0
                    ?
                    //interviewer is going to cancel this candidate application (both HR & Candidate will know).
                    () async {
                        await dbm.interviewNotify(
                          context,
                          formKey,
                          userData,
                          0,
                          rejectionMessage: messageCont.text,
                          timeToApply: DateTime.now().add(Duration(days: 7)),
                        );
                      }
                    :
                    //interviewer is going to Schedule and interview (both HR & Candidate will know).
                    () async {
                        await dbm.interviewNotify(
                          context,
                          formKey,
                          userData,
                          1,
                          dayTime: dayTime,
                          hourTime: hourTime.text,
                          noteToCandidate: messageCont.text,
                          timeToApply: DateTime.now().add(Duration(days: 7)),
                        );
                      },
                child: Text('Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(fixedSize: Size(width * 0.23, height * 0.05)),
              ),
              SizedBox(width: width * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _showDate(BuildContext context) async {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
  }
}
