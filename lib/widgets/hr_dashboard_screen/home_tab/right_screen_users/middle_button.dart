import 'package:flutter/material.dart';
import 'package:usms/constants/selected_users_enum.dart';

class MiddleButton extends StatelessWidget {
  final String? title;
  final selectedUsers? selectedUsersType;
  final selectedUsers? selectionType;
  final void Function(selectedUsers selectedUserType)? stateHandler;

  const MiddleButton({
    @required this.title,
    @required this.selectedUsersType,
    @required this.stateHandler,
    @required this.selectionType,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => stateHandler!(selectedUsersType!),
      child: Text(title!),
      style: ElevatedButton.styleFrom(
        primary: selectedUsersType == selectionType ? Theme.of(context).primaryColor : Colors.white,
        onPrimary: selectedUsersType == selectionType ? Colors.white : Colors.black,
      ),
    );
  }
}
