import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:usms/widgets/widget_exporter.dart';
import '../providers/auth_provider.dart';
import '../providers/dbm_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/checking/hr_db_check.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final bool _testMode = true;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => DBM()),
      ],
      child: MaterialApp(
        title: 'Ultimate School Management System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          accentColor: Colors.amber,
          // brightness: Brightness.dark,
        ),
        home: _testMode
            ? HRDataCheck()
            : StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return noticeError;
                  } else if (!snapshot.hasData) {
                    return MainScreen();
                  } else if (snapshot.hasData) {
                    return HRDataCheck();
                  }
                  return MainScreen();
                },
              ),
        routes: {
          MainScreen.id: (context) => MainScreen(),
          AuthScreen.id: (context) => AuthScreen(),
          HRDataCheck.id: (context) => HRDataCheck(),
        },
      ),
    );
  }
}
