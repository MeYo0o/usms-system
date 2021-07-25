import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthFormTile extends StatefulWidget {
  final String? tileName;
  final TextEditingController? cont;
  final TextEditingController? pwCheckCont;

  bool? obscureVar;
  AuthFormTile({
    @required this.tileName,
    @required this.cont,
    @required this.obscureVar,
    this.pwCheckCont,
  });

  @override
  _AuthFormTileState createState() => _AuthFormTileState();
}

class _AuthFormTileState extends State<AuthFormTile> {
  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kIsWeb ? width * 0.2 : width * 0.1),
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        key: ValueKey(widget.tileName),
        textInputAction: TextInputAction.next,
        keyboardType:
            widget.tileName == 'Username' ? TextInputType.name : TextInputType.visiblePassword,
        controller: widget.cont,
        obscureText: widget.obscureVar!,
        validator: (value) {
          if (widget.tileName == 'Username') {
            if (value!.isEmpty) {
              return 'Please Enter a valid Username';
            } else if (value.contains('@')) {
              return 'we want just a username not an email';
            }
            return null;
          } else if (widget.tileName == 'Password') {
            if (value!.isEmpty) {
              return 'Password can\'t be empty!';
            } else if (value.length < 8) {
              return 'Password can\'t be less than 8 characters';
            }
            return null;
          } else if (widget.tileName == 'Confirm Password') {
            if (value!.isEmpty) {
              return 'Confirm Password can\'t be empty!';
            } else if (widget.cont!.text != widget.pwCheckCont!.text) {
              return 'Both Passwords must be the same';
            }
            return null;
          }
        },
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: '${widget.tileName}',
          labelStyle: Theme.of(context).textTheme.bodyText1,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          // suffixText: widget.tileName == 'Username' ? '@qls-egypt.com' : null,
          suffixIcon: (widget.tileName == 'Password' || widget.tileName == 'Confirm Password')
              ? IconButton(
                  icon: widget.obscureVar == false ? Icon(Icons.lock_open_sharp) : Icon(Icons.lock),
                  onPressed: () {
                    setState(() {
                      widget.obscureVar = !widget.obscureVar!;
                    });
                  },
                )
              : null,
          suffixStyle: Theme.of(context).textTheme.bodyText2,
        ),
      ),
    );
  }
}
