import 'package:flutter/material.dart';
import 'package:usms/widgets/common_widgets/notice_screen.dart';

final Widget noticeError = NoticeScreen(
  headText: 'An Error Occurred!',
  bodyText: 'Try Again Later',
  iconData: Icons.error_outline,
  iconColor: Colors.red,
);
final Widget noticeNoData = NoticeScreen(
  headText: 'Profile Data Not Found!',
  bodyText: 'Please Complete your registration data using the mobile version then come back here',
  iconData: Icons.error_outline,
  iconColor: Colors.red,
);
final Widget noticeDataCompleted = NoticeScreen(
  headText: 'Profile Data Successfully Submitted!',
  bodyText: 'You are done here , please go back to your web app and proceed',
  iconData: Icons.check_circle_outline,
  iconColor: Colors.green,
);
