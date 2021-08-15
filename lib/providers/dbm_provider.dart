//This Provider will contain Camera images, firestore & storage
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBM with ChangeNotifier {
  //Firebase Init
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firestorage = FirebaseStorage.instance;
  //Loading Indicator
  bool isLoading = false;
  //UserData Container
  var userData;
  DateTime? birthDay;
  File? pickedImage;

  //Current Login/Signup Type State --> ex : hr , interviewer , admin , owner , ...etc
  String? userType;
  //setter
  Future<void> setUserType(String keyValue) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('userData', keyValue);
    userType = keyValue;
  }

  //getter
  Future<void> getUserType() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    userType = sp.getString('userData');
  }

  //Navigator Boolean -- Make sure you set it to 0 on deploy
  int navigator = 0;

  void changeNavigatorValue(int newValue) {
    navigator = newValue;
    notifyListeners();
  }

  //get UserData
  Future<void> getUserData() async {
    //get current user
    User? user = FirebaseAuth.instance.currentUser;
    //TODO Clear this static collection and make it dynamic based on where the hr/interviewer is going
    final String collectionId = kIsWeb ? 'hr_users' : 'interviewers';
    await firestore.collection(collectionId).doc(user!.uid).get().then(
      (DocumentSnapshot snapshot) {
        userData = snapshot.data();
        // print(userData);
      },
    );
    return userData;
  }

  void updateBirthDay(DateTime newDate) {
    birthDay = newDate;
    //recently added but not tested
    // notifyListeners();
  }

  void getBirthDay() {
    birthDay = DateTime.parse(userData['birthDay']);
    notifyListeners();
  }

  //Image Picking & Cropping Logic for Android/iOS ----> Adjust the Image Quality Later
  Future<File?> onImageButtonPressed(ImageSource source) async {
    final PickedFile? pickedImage = await ImagePicker().getImage(
      source: source,
      imageQuality: 100,
      maxWidth: 700,
    );
    if (pickedImage != null) {
      File? pickedFile;
      pickedFile = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 70,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: "Crop your image",
        ),
      );
      return pickedFile;
    }
  }

  // Network Image to File
  Future<void> fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, 'profileImage.png'));

    file.writeAsBytesSync(response.bodyBytes);

    pickedImage = file;
    notifyListeners();
    // return file;
  }

  void updateProfileImage(File? newImage) {
    pickedImage = newImage;
    notifyListeners();
  }

  //to show scaffold message anywhere
  void hideNShowSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  //////////////////////////////////////////////// Common Functions //////////////////////////////////
  //Submit Mandatory Data
  Future<void> submitMandatoryData(
      BuildContext context,
      GlobalKey<FormState> formKey,
      String fullName,
      String mobileNumber,
      String address,
      String nationality,
      String religion,
      String degreeType,
      String collegeName,
      String speciality,
      String graduationYear,
      bool isEditMode) async {
    //get current user
    User? user = FirebaseAuth.instance.currentUser;
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (pickedImage == null) {
      hideNShowSnackBar(context, 'Please Upload a valid Profile Image.');
      return;
    }
    if (!isValid) {
      hideNShowSnackBar(context, 'Please Complete All Required Fields.');
      return;
    }
    if (isValid) {
      //save the form then proceed to data submittion
      formKey.currentState!.save();

      //Return Function instead of stuck , ex: Network issues
      // Future.delayed(Duration(seconds: 10)).then((value) {
      //   hideNShowSnackBar(context, 'Network Error: Check your Internet Connectivity.');
      //   return;
      // });

      //upload image to firebase
      try {
        //First we make the Storage Ref. ready for uploading
        final Reference ref = firestorage.ref().child('users_images').child(user!.uid + '.jpg');
        //Second we pass the image file to the Storage Ref. to be uploaded
        await ref.putFile(pickedImage!).whenComplete(() => null);

        //Third and finally ... get the download link of that file
        final url = await ref.getDownloadURL();
        //----END of Profile Image Uploading-----//

        //submit to firestore
        await firestore.collection('$userType').doc(user.uid).set({
          'profileImage': url,
          'fullName': fullName,
          'mobileNumber': mobileNumber,
          'birthDay': birthDay!.toIso8601String(),
          'address': address,
          'nationality': nationality,
          'religion': religion,
          'degreeType': degreeType,
          'collegeName': collegeName,
          'speciality': speciality,
          'graduationYear': graduationYear,
          'uid': user.uid,
          if (userType == 'interviewers') 'interviews': [],
          if (userType == 'interviewers') 'employees': [],
        }).then((value) async {
          if (isEditMode) {
            getUserData();
            hideNShowSnackBar(context, 'Data is successfully updated!');
            return;
          } else if (!isEditMode) {
            //In case HR first signup , go check his/her data then navigate to the according screen
            // Navigator.of(context).pushReplacementNamed(DatabaseCheck.id);
          }
        });
      } catch (err) {
        print(err);
        hideNShowSnackBar(context, 'There was an error uploading data.');
        return;
      }
    }
  }

///////////////////////////////////////////////  interviewers related  //////////////////////////////////////
  Future<void> interviewNotify(
    BuildContext context,
    GlobalKey<FormState> formKey,
    String candidateId,
    int dialogIndex, {
    DateTime? dayTime,
    String? hourTime,
    String? noteToCandidate,
    String? rejectionMessage,
    DateTime? timeToApply,
  }) async {
    bool isValid = formKey.currentState!.validate();
    if (isValid) {
      try {
        //get Job Data
        var jobData;
        await firestore.collection('jobs').doc(userData['appliedJob']).get().then(
          (DocumentSnapshot snapshot) {
            jobData = snapshot.data();
            // print(userData);
          },
        );
        //in case of cancelling the interview
        //deleting the interview process from the Interviewer
        if (dialogIndex == 0) {
          if (timeToApply == null || rejectionMessage == null) {
            hideNShowSnackBar(context, 'Please Fill all required fields!');
            return;
          }

          await firestore.collection('users').doc(candidateId).update({
            //Notify the HR
            'interview': 'rejected',
            //Notify the Candidate of cancelling
            'rejection': {
              'jobName': jobData['jobName'],
              'JobPosition': jobData['jobPosition'],
              'interviewerId': userData['uid'],
              'rejectionMessage': rejectionMessage,
            },
            'timeToApply': timeToApply.toIso8601String(),
          });

          //test values
          // print('rejectionMessage : ' + rejectionMessage);
          // print('timeToApply : ' + timeToApply.toIso8601String());
        }
        //in case of accepting the interview (Scheduling)
        else if (dialogIndex == 1) {
          if (dayTime == null || hourTime == null || noteToCandidate == null) {
            hideNShowSnackBar(context, 'Please Fill all required fields!');
            return;
          }

          //update candidate db while notifying HR & Candidate
          await firestore.collection('users').doc(candidateId).update({
            //Notify the HR
            'interview': 'accepted',
            //Notify the Candidate of cancelling
            'scheduledInterview': {
              'jobName': jobData['jobName'],
              'JobPosition': jobData['jobPosition'],
              'interviewerId': userData['uid'],
              'dayTime': dayTime.toIso8601String(),
              'hourTime': hourTime,
              'noteToCandidate': noteToCandidate,
            },
          });
          //test values
          // print('interviewerId : ' + interviewerId!);
          // print('dayTime : ' + dayTime!.toIso8601String());
          // print('hourTime : ' + hourTime!);
          // print('noteToCandidate : ' + noteToCandidate!);
        }

        hideNShowSnackBar(context, 'Operation is done successfully!');
        //exit both dialog and user screen
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } catch (err) {
        hideNShowSnackBar(context, 'There was an error while doing this operation!');
      }
    } else {
      hideNShowSnackBar(context, 'Please Fill all required fields!');
      return;
    }
  }

///////////////////////////////////////////////  HR related  //////////////////////////////////////
  Future<void> updateUserData(String uid, String hrValue, BuildContext context) async {
    String? userVerification;
    if (hrValue == 'verify') {
      userVerification = 'verified';
    } else if (hrValue == 'employee') {
      userVerification = 'employed';
    } else if (hrValue == 'delete') {
      userVerification = 'deleted';
    } else if (hrValue == 'unverify') {
      userVerification = 'unverified';
    }
    await firestore.collection('users').doc(uid).update({'verified': userVerification}).then((_) => hideNShowSnackBar(
          context,
          'Operation is done '
          'successfully',
        ));
  }

  Future<void> submitJob(BuildContext context, GlobalKey<FormState> formKey, String jobName, String jobPosition,
      String jobResponsibilities) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      hideNShowSnackBar(context, 'Please Complete All Required Fields.');
      return;
    }
    if (isValid) {
      formKey.currentState!.save();
      try {
        final DocumentReference newJob = FirebaseFirestore.instance.collection('jobs').doc();
        final String newJobId = newJob.id;
        await FirebaseFirestore.instance.collection('jobs').doc(newJobId).set({
          'jobName': jobName,
          'jobPosition': jobPosition,
          'jobResponsibilities': jobResponsibilities,
          'uid': newJobId,
          'requests': [],
        });
        hideNShowSnackBar(context, 'Job is submitted Successfully!');
      } catch (err) {
        print(err);
        hideNShowSnackBar(context, 'There was an error uploading data.');
        return;
      }
    }
  }

  Future<void> deleteJob(BuildContext context, String jobId, List usersAppliedIDs, List interviewersIDs) async {
    //make sure there is no empty strings in the interviewers or interviewees List
    interviewersIDs.removeWhere((e) => e == '');
    usersAppliedIDs.removeWhere((e) => e == '');
    //reset interviewers data
    interviewersIDs.forEach((interviewerID) async {
      await firestore.collection('interviewers').doc(interviewerID).update({
        'interviews': [],
      });
    });

    //reset users data
    usersAppliedIDs.forEach((userId) async {
      await firestore.collection('users').doc(userId).update({
        'appliedJob': '',
        'interview': '',
      });
    });
    await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
    hideNShowSnackBar(context, 'Job is deleted successfully.');
  }

  /////////////////////////////////// HR To Interviewers Related /////////////////////////////
  List<dynamic> interList = [];
  Future<void> getInterviewers() async {
    await firestore.collection('interviewers').get().then((QuerySnapshot interviewers) {
      interviewers.docs.forEach((interviewer) {
        if (!interList.contains(interviewer.data)) {
          interList.add(interviewer.data());
        }
      });
      // print(interList);
    });
  }

  // user from it
  Future<void> assignUserToInterviewer(BuildContext context, String interviewerId, jobData, userData) async {
    try {
      if (userData['appliedJob'] != jobData['uid']) {
        hideNShowSnackBar(context, 'This user has withdrawn his apply for this job');
        return;
      }
      //define the interviewer interviews
      List iInterviews = [];
      // get it
      await firestore.collection('interviewers').doc(interviewerId).get().then((DocumentSnapshot snapshot) {
        iInterviews = snapshot.get('interviews');
      });
      //check if the employee has been assigned before , to prevent multiple interviews to the same interviewer
      if (iInterviews.contains(userData['uid'])) {
        hideNShowSnackBar(context, 'This user is already assigned for that Interviewer.');
        return;
      }
      // add the employee to it
      iInterviews.add(userData['uid']);
      // -- New
      //define the employee interviews
      String eInterview = '';
      // get it
      await firestore.collection('users').doc(userData['uid']).get().then((DocumentSnapshot snapshot) {
        eInterview = snapshot.get('interview');
      });
      //check if the employee has been assigned to any other interviewer , only one interviewer is allowed
      if (eInterview != '') {
        hideNShowSnackBar(context, 'This User is already assigned to another Interviewer');
        return;
      }
      // update db
      await firestore.collection('interviewers').doc(interviewerId).update({
        'interviews': iInterviews,
      });

      // -- OLD
      // add the interviewer to it
      // eInterviews.add(interviewerId);

      // update db
      await firestore.collection('users').doc(userData['uid']).update({
        'interview': interviewerId,
      });
      hideNShowSnackBar(context, 'Operation is done successfully.');
    } catch (err) {
      hideNShowSnackBar(context, 'There was an error while doing the operation.');
    }
  }

  Future<void> unAssignUserToInterviewer(BuildContext context, String interviewerId, String employeeId) async {
    try {
      // update db
      List iInterviews = [];
      //delete the userId from the interviewer Interviews
      await firestore.collection('interviewers').doc(interviewerId).get().then((DocumentSnapshot snapshot) {
        iInterviews = snapshot.get('interviews');
      });
      iInterviews.remove(employeeId);

      await firestore.collection('interviewers').doc(interviewerId).update({
        'interviews': iInterviews,
      });
      await firestore.collection('users').doc(employeeId).update({
        'interview': '',
      });

      hideNShowSnackBar(context, 'Operation is done successfully.');
    } catch (err) {
      hideNShowSnackBar(context, 'There was an error while doing the operation.');
    }
  }

  //end of class
}
