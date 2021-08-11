import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/auth_provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/widgets/common_widgets/profile_tile.dart';

class InterviewerProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final auth = Provider.of<Auth>(context);
    final dbm = Provider.of<DBM>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Welcome Interviewer'), centerTitle: true, automaticallyImplyLeading: false),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: kIsWeb ? height * 0.4 : height * 0.25,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      child: Image.network(
                        dbm.userData['profileImage'],
                        fit: BoxFit.fitHeight,
                        width: kIsWeb ? width * 0.01 : width * 0.4,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dbm.userData['fullName'],
                          style: Theme.of(context).textTheme.headline5!.copyWith(
                                fontSize: kIsWeb ? width * 0.02 : width * 0.055,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          dbm.userData['degreeType'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: kIsWeb ? width * 0.015 : width * 0.05),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          dbm.userData['speciality'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: kIsWeb ? width * 0.013 : width * 0.04),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ProfileTile(
              leftText: 'Interviews',
              rightText: dbm.userData['interviews'].length.toString(),
              rightColor: Colors.blueGrey,
            ),
            ProfileTile(
              leftText: 'Employees',
              rightText: dbm.userData['employees'].length.toString(),
              rightColor: Colors.teal[400],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await auth.emailSignOut();
                // Navigator.of(context).pushReplacementNamed(AuthScreen.id);
              },
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                      fontSize: kIsWeb ? width * 0.01 : width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: kIsWeb ? Size(width * 0.4, height * 0.05) : Size(width * 0.9, height * 0.03),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
