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
import 'package:usms/screens/checking/hr_db_check.dart';

class DBM with ChangeNotifier {
  //Firebase Init
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage firestorage = FirebaseStorage.instance;
  //UserData Container
  var userData;
  DateTime? birthDay;
  File? pickedImage;

  //Navigator Boolean
  int navigator = 1;

  void changeNavigatorValue(int newValue) {
    navigator = newValue;
    notifyListeners();
  }

  //get UserData
  Future<void> getUserData() async {
    //get current user
    User? user = FirebaseAuth.instance.currentUser;
    await firestore.collection('hr_users').doc(user!.uid).get().then(
      (DocumentSnapshot snapshot) {
        userData = snapshot.data();
        //recently added but not tested
        // notifyListeners();
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
    String graduationYear,
    bool isEditMode,
  ) async {
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
        await firestore.collection('hr_users').doc(user.uid).set({
          'profileImage': url,
          'fullName': fullName,
          'mobileNumber': mobileNumber,
          'birthDay': birthDay!.toIso8601String(),
          'address': address,
          'nationality': nationality,
          'religion': religion,
          'degreeType': degreeType,
          'collegeName': collegeName,
          'graduationYear': graduationYear,
          'uid': user.uid,
        }).then((value) async {
          if (isEditMode) {
            getUserData();
            hideNShowSnackBar(context, 'Data is successfully updated!');
            return;
          } else if (!isEditMode) {
            //In case HR first signup , go check his/her data then navigate to the according screen
            Navigator.of(context).pushReplacementNamed(HRDataCheck.id);
          }
        });
      } catch (err) {
        print(err);
        hideNShowSnackBar(context, 'There was an error uploading data.');
        return;
      }
    }
  }

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

  //end of class
}
