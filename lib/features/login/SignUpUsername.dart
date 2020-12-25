import 'package:closa_flutter/features/login/SignUpProfile.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpUsername extends StatefulWidget {
  @override
  _SignUpUsernameState createState() => _SignUpUsernameState();
}

class _SignUpUsernameState extends State<SignUpUsername> {
  final usernameController = TextEditingController();
  int usernameLength = 0;
  int nameLength = 0;
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    usernameController.addListener(_getUsernameValue);
  }

  bool validation() {
    return usernameLength >= 3 && usernameLength <= 16;
  }

  _getUsernameValue() {
    setState(() {
      usernameLength = usernameController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, top: 24.0, bottom: 16.0),
                    child: Icon(Icons.chevron_left),
                  ),
                ),
                Divider(
                  color: Color(0xFF000000).withOpacity(0.08),
                ),
                Container(
                  margin: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: TextContent(
                      text:
                          "First, we would love to know your name so people will recognize you better"),
                ),
                SizedBox(height: 45.0),
                Container(
                  margin: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSmall(
                        text: "USERNAME",
                      ),
                      TextSmall(
                        text: "Username already taken",
                        color: Color(0xFFFF3B30),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.0),
                Container(
                  margin: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: usernameController,
                      )),
                      TextSmall(
                        text: '${16 - usernameLength}',
                        color: usernameLength <= 16 ? null : Color(0xFFFF2D55),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Divider(
                  color: Color(0xFF000000).withOpacity(0.08),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    if (validation()) {
                      sharedPrefs.username = usernameController.text;
                      final firestoreInstance = FirebaseFirestore.instance;
                      firestoreInstance
                          .collection("users")
                          .doc(sharedPrefs.idUser)
                          .set({
                        "name": sharedPrefs.name,
                        "email": sharedPrefs.email,
                        "photo": sharedPrefs.photo,
                        "username": sharedPrefs.username
                      }).then((value) {
                        Get.offAllNamed("/task");
                      });
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      margin: EdgeInsets.only(
                          left: 24.0, right: 24.0, bottom: 60.0),
                      decoration: BoxDecoration(
                          color: validation()
                              ? Color(0xFF0A0A0C)
                              : Color(0xFFCCCCCC),
                          borderRadius: BorderRadius.circular(4)),
                      child: Center(
                          child: TextDescription(
                        text: "CONTINUE",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
