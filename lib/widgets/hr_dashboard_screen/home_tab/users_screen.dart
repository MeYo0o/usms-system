import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/auth_screen.dart';
import 'package:usms/widgets/widget_exporter.dart';
import 'package:usms/constants/constants_exporter.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  selectedUsers _selectedUsers = selectedUsers.all;

  void buttonStateHandler(selectedUsers newValue) {
    setState(() {
      _selectedUsers = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final dbm = Provider.of<DBM>(context);

    return Expanded(
      flex: 5,
      child: Container(
        padding: EdgeInsets.all(width * 0.01),
        decoration: BoxDecoration(color: Color(0xffEBEBEB)),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _selectedUsers == selectedUsers.all
                      ? dbm.firestore.collection('users').where('verified', isNotEqualTo: 'deleted').snapshots()
                      : _selectedUsers == selectedUsers.verified
                          ? dbm.firestore.collection('users').where('verified', isEqualTo: 'verified').snapshots()
                          : dbm.firestore.collection('users').where('verified', isEqualTo: 'unverified').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> usersData) {
                    if (usersData.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (usersData.hasError) {
                      return noticeError;
                    } else if (!usersData.hasData) {
                      return Center(
                        child: Text('No Users Registered Yet!'),
                      );
                    } else if (usersData.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RightScreenUpperContainer(usersData.data!.docs.length),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => buttonStateHandler(selectedUsers.all),
                                  child: Text('All Users'),
                                  style: ElevatedButton.styleFrom(
                                    primary: _selectedUsers == selectedUsers.all ? Theme.of(context).primaryColor : Colors.white,
                                    onPrimary: _selectedUsers == selectedUsers.all ? Colors.white : Colors.black,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => buttonStateHandler(selectedUsers.unverified),
                                  child: Text('Unverified Users'),
                                  style: ElevatedButton.styleFrom(
                                    primary: _selectedUsers == selectedUsers.unverified ? Theme.of(context).primaryColor : Colors.white,
                                    onPrimary: _selectedUsers == selectedUsers.unverified ? Colors.white : Colors.black,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => buttonStateHandler(selectedUsers.verified),
                                  child: Text('Verified Users'),
                                  style: ElevatedButton.styleFrom(
                                    primary: _selectedUsers == selectedUsers.verified ? Theme.of(context).primaryColor : Colors.white,
                                    onPrimary: _selectedUsers == selectedUsers.verified ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RightScreenBottomUserList(
                            usersData: usersData,
                          ),
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
