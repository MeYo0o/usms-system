import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/providers/auth_provider.dart';
import 'package:usms/providers/dbm_provider.dart';
import 'package:usms/screens/common/checking/db_check.dart';

import '../widget_exporter.dart';

class AuthScreenBody extends StatefulWidget {
  const AuthScreenBody({Key? key}) : super(key: key);

  @override
  _AuthScreenBodyState createState() => _AuthScreenBodyState();
}

class _AuthScreenBodyState extends State<AuthScreenBody> {
  final _formKey = GlobalKey<FormState>();
  bool _isSignup = false;
  bool _isLoading = false;

  final bool _showPassword = true;
  final TextEditingController _emailCont = TextEditingController();
  final TextEditingController _passwordCont = TextEditingController();
  final TextEditingController _confirmPasswordCont = TextEditingController();

  void _changeIsLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void _submitData(Auth auth, DBM dbm) async {
    FocusScope.of(context).unfocus();
    //to enable loading
    _changeIsLoadingState();
    final bool _isValid = _formKey.currentState!.validate();
    if (!_isValid) {
      dbm.hideNShowSnackBar(context, 'Please Complete All The Fields');
      //to disable loading
      _changeIsLoadingState();
    }
    if (_isValid) {
      try {
        if (_isSignup) {
          await auth.emailSignUp(_emailCont.text.trim(), _passwordCont.text);
          //to disable loading
          // _changeIsLoadingState();
          //Move to HR Data Check for whether the result should be MandatoryDataScreen or HR Profile
          Navigator.of(context).pushReplacementNamed(DatabaseCheck.id);
        } else {
          await auth.emailSignIn(_emailCont.text.trim(), _passwordCont.text);
          //to disable loading
          _changeIsLoadingState();
          //Move to HR Data Check for whether the result should be MandatoryDataScreen or HR Profile
          Navigator.of(context).pushReplacementNamed(DatabaseCheck.id);
        }
      } catch (err) {
        //to disable loading
        _changeIsLoadingState();
        dbm.hideNShowSnackBar(context, '${err.toString()}');
      }
    }
  }

  @override
  void dispose() {
    _emailCont.dispose();
    _passwordCont.dispose();
    _confirmPasswordCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final dbm = Provider.of<DBM>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: kIsWeb
          ? null
          : AppBar(
              title: Text('Authentication Screen'),
              centerTitle: true,
            ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo-nobg.png',
                fit: BoxFit.cover,
                height: kIsWeb ? height * 0.3 : height * 0.2,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: height * 0.20,
                width: width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Ultimate School Management System',
                          // speed: Duration(milliseconds: 100),
                          // cursor: '',
                          textStyle: TextStyle(
                            fontSize: kIsWeb ? width * 0.03 : width * 0.05,
                            fontFamily: 'OtomanopeeOne',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AuthFormTile(tileName: 'Username', cont: _emailCont, obscureVar: false),
              AuthFormTile(tileName: 'Password', cont: _passwordCont, obscureVar: _showPassword),
              if (_isSignup)
                AuthFormTile(
                  tileName: 'Confirm Password',
                  cont: _confirmPasswordCont,
                  pwCheckCont: _passwordCont,
                  obscureVar: _showPassword,
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSignup = !_isSignup;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _isSignup
                        ? 'Already have an account? .. Click Here to Sign In'
                        : 'Don\'t have an account? .. Click Here to Sign Up',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Theme.of(context).accentColor, fontSize: kIsWeb ? width * 0.012 : width * 0.035),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.2, vertical: height * 0.03),
                child: ElevatedButton(
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).accentColor,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _isSignup ? 'Sign Up' : 'Sign In',
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: kIsWeb ? width * 0.01 : width * 0.05),
                          ),
                        ),
                  onPressed: () => _submitData(auth, dbm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
