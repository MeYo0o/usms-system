import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/widgets/mandatory_signup_screen/form_tile.dart';

class JobsRightUpperContainer extends StatelessWidget {
  final int? jobsNumber, jobsRequests;
  const JobsRightUpperContainer({@required this.jobsNumber, @required this.jobsRequests});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Expanded(
      flex: 2,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RichText(
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Jobs Posted : ',
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.03),
                  ),
                  TextSpan(
                    text: jobsNumber.toString(),
                    style: Theme.of(context).textTheme.headline5!.copyWith(fontFamily: 'OtomanopeeOne', fontSize: width * 0.03),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Jobs Requests : ',
                        style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.03),
                      ),
                      TextSpan(
                        text: jobsRequests.toString(),
                        style: Theme.of(context).textTheme.headline5!.copyWith(fontFamily: 'OtomanopeeOne', fontSize: width * 0.03),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text('Create A Job',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.01,
                          )),
                  onPressed: () => createJob(context),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor,
                    fixedSize: Size(width * 0.1, height * 0.06),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future createJob(BuildContext context) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final TextEditingController jobNameCont = TextEditingController();
    final TextEditingController jobPositionCont = TextEditingController();
    final TextEditingController jobResponsibilitiesCont = TextEditingController();
    final dbm = Provider.of<DBM>(context, listen: false);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        // contentPadding: const EdgeInsets.all(20),
        title: Text(
          'Create A New Job',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold, fontSize: width * 0.02),
        ),
        content: Container(
          height: height * 0.9,
          width: width * 0.7,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      FormTile(
                        fieldName: 'Job Name',
                        controller: jobNameCont,
                      ),
                      FormTile(
                        fieldName: 'Job Position',
                        controller: jobPositionCont,
                      ),
                      FormTile(
                        fieldName: 'Job Responsibilities',
                        controller: jobResponsibilitiesCont,
                        inputType: TextInputType.multiline,
                        action: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(fixedSize: Size(width * 0.08, height * 0.04)),
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
                    //post job to firestore
                    dbm
                        .submitJob(context, formKey, jobNameCont.text, jobPositionCont.text, jobResponsibilitiesCont.text)
                        .then((value) => Navigator.of(ctx).pop());
                  },
                  style: ElevatedButton.styleFrom(fixedSize: Size(width * 0.1, height * 0.04)),
                  child: Text(
                    'Submit This Job',
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
}
