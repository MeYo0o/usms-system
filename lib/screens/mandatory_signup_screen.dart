import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms/screens/main_screen.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dbm_provider.dart';
import '../screens/auth_screen.dart';
import '../widgets/widget_exporter.dart';

class MandatorySignUpScreen extends StatefulWidget {
  static const String id = 'mandatory_signup_screen';
  bool isEditMode = false;
  MandatorySignUpScreen({required this.isEditMode});
  @override
  _MandatorySignUpScreenState createState() => _MandatorySignUpScreenState();
}

class _MandatorySignUpScreenState extends State<MandatorySignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCont = TextEditingController();
  final TextEditingController _mobileCont = TextEditingController();
  final TextEditingController _addressCont = TextEditingController();
  final TextEditingController _nationalityCont = TextEditingController();
  final TextEditingController _religionCont = TextEditingController();
  final TextEditingController _degreeTypeCont = TextEditingController();
  final TextEditingController _collegeNameCont = TextEditingController();
  final TextEditingController _graduationYearCont = TextEditingController();

  bool _isLoading = false;

  void _changeIsLoadingState() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  //birthday widget to maintain selected birthday
  Widget birthdayWidget = BirthDayTile();

  @override
  void initState() {
    super.initState();
    if (!widget.isEditMode) {
      Future.delayed(Duration.zero).then((_) {
        final dbm = Provider.of<DBM>(context, listen: false);
        //always make sure this dbm picked image == null
        dbm.updateProfileImage(null);
      });
    }
    if (widget.isEditMode) {
      Future.delayed(Duration.zero).then((_) async {
        final dbm = Provider.of<DBM>(context, listen: false);
        //Get all HR related data from userData to be shown / edit
        await dbm.getUserData();
      });
    }
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _mobileCont.dispose();
    _addressCont.dispose();
    _nationalityCont.dispose();
    _religionCont.dispose();
    _degreeTypeCont.dispose();
    _collegeNameCont.dispose();
    _graduationYearCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbm = Provider.of<DBM>(context);
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Mandatory Information'),
        actions: [
          if (!widget.isEditMode)
            IconButton(
                onPressed: () async {
                  await auth.emailSignOut();
                  Navigator.of(context).pushReplacementNamed(MainScreen.id);
                },
                icon: Icon(Icons.exit_to_app))
        ],
        // centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileImage(isEditingMode: widget.isEditMode),
                    FormTile(fieldName: 'Full Name', controller: _nameCont),
                    birthdayWidget,
                    FormTile(fieldName: 'Mobile Number', controller: _mobileCont, inputType: TextInputType.number),
                    FormTile(fieldName: 'Address', controller: _addressCont),
                    FormTile(fieldName: 'Nationality', controller: _nationalityCont),
                    FormTile(fieldName: 'Religion', controller: _religionCont),
                    FormTile(fieldName: 'Degree Type (ex: Bachelor Degree)', controller: _degreeTypeCont),
                    FormTile(fieldName: 'College Name', controller: _collegeNameCont),
                    FormTile(
                        fieldName: 'Graduation Year',
                        controller: _graduationYearCont,
                        inputType: TextInputType.number,
                        action: TextInputAction.done),
                    SizedBox(height: 7),
                    ElevatedButton(
                      onPressed: () async {
                        //enable loading
                        _changeIsLoadingState();

                        //Check Value Testing
                        // print(_formKey);
                        // print(_pickedImage);
                        // print(_nameCont.text);
                        // print(_birthDate);
                        // print(_mobileCont.text);
                        // print(_addressCont.text);
                        // print(_nationalityCont.text);
                        // print(_religionCont.text);
                        // print(_degreeTypeCont.text);
                        // print(_collegeNameCont.text);
                        // print(_graduationYearCont.text);
                        // print(_specialityCont.text);
                        // print(_diplomaCont.text);

                        //verify & submit data
                        await dbm
                            .submitMandatoryData(
                              context,
                              _formKey,
                              _nameCont.text,
                              _mobileCont.text,
                              _addressCont.text,
                              _nationalityCont.text,
                              _religionCont.text,
                              _degreeTypeCont.text,
                              _collegeNameCont.text,
                              _graduationYearCont.text,
                              widget.isEditMode,
                            ) //disable loading
                            .then((_) => _changeIsLoadingState);
                      },
                      child: Text('Submit Your Data'),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}
