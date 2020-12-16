import 'package:closa_flutter/features/login/SignUpScreen.dart';
import 'package:closa_flutter/features/login/SignUpUsername.dart';
import 'package:flutter/material.dart';
import './helpers/CustomScrolling.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/home/TaskScreen.dart';
import 'helpers/sharedPref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            home: Center(
              child: Text(snapshot.error),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
            home: ScrollConfiguration(
              behavior: MyBehavior(),
              // child: TaskScreen(),
              child: SignUpScreen(),
            ),
          );
        }
        return MaterialApp(
          home: Center(
            child: Text("Loading"),
          ),
        );
      },
    );
  }
}
