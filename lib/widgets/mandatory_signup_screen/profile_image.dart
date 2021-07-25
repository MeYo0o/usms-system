import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/dbm_provider.dart';

class ProfileImage extends StatelessWidget {
  final bool isEditingMode;
  ProfileImage({required this.isEditingMode});

  Future<File?> _pickImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Pick a Profile Picture'),
            content: Text('Choose how you want to upload a picture of your self. ♥'),
            elevation: 8,
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final dbm = Provider.of<DBM>(context, listen: false);
                      dbm.onImageButtonPressed(ImageSource.camera).then((croppedImage) {
                        dbm.updateProfileImage(croppedImage);
                        Navigator.of(ctx).pop();
                      });
                    },
                    child: Text('Camera'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final dbm = Provider.of<DBM>(context, listen: false);
                      dbm.onImageButtonPressed(ImageSource.gallery).then((croppedImage) {
                        dbm.updateProfileImage(croppedImage);
                        Navigator.of(ctx).pop();
                      });
                    },
                    child: Text('Gallery'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final dbm = Provider.of<DBM>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: dbm.pickedImage != null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      child: Image.file(
                        dbm.pickedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      child: Image.asset(
                        'assets/images/image_placeHolder.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          ElevatedButton(
              onPressed: isEditingMode
                  ? null
                  : () {
                      _pickImage(context);
                    },
              child: Text('Pick Profile Image')),
        ],
      ),
    );
  }
}
