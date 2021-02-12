import 'dart:developer';

import 'package:closa_flutter/core/base_action.dart';
import 'package:closa_flutter/core/base_view.dart';
import 'package:closa_flutter/features/login/SignUpUsername.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpState {}

class SignUpAction extends BaseAction<SignUpScreen, SignUpAction, SignUpState> {
  @override
  Future<SignUpState> initState() async {
    return SignUpState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User> signInWithGoogle() async {
    await Firebase.initializeApp();
    googleSignIn.disconnect();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      return user;
    }

    return null;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }
}

class SignUpScreen extends BaseView<SignUpScreen, SignUpAction, SignUpState> {
  @override
  SignUpAction initAction() => SignUpAction();

  @override
  Widget loadingViewBuilder(BuildContext context) => Container();

  @override
  Widget render(BuildContext context, SignUpAction action, SignUpState state) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFB),
      body: Container(
        margin:
            EdgeInsets.only(top: 108.0, left: 24.0, right: 24.0, bottom: 46.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  CustomIcon(
                    type: "logo",
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  TextHeader(
                    text: "Closa",
                  )
                ],
              ),
            ),
            SizedBox(
              height: 22.0,
            ),
            Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextContent(
                  text:
                      "A creator community where you get things done, meet interesting people and do what matters.",
                )),
            Expanded(child: Container()),
            GestureDetector(
              onTap: () {
                action.signInWithGoogle().then((result) {
                  if (result != null) {
                    sharedPrefs.idUser = result.uid;
                    sharedPrefs.email = result.email;
                    sharedPrefs.name = result.displayName;
                    sharedPrefs.photo = result.photoURL;
                    final firestoreInstance = FirebaseFirestore.instance;
                    firestoreInstance
                        .collection("users")
                        .doc(sharedPrefs.idUser)
                        .snapshots()
                        .first
                        .then((value) {
                      if (value.data() != null) {
                        sharedPrefs.name = value.data()["name"];
                        sharedPrefs.username = value.data()["username"];
                        sharedPrefs.email = value.data()["email"];
                        sharedPrefs.photo = value.data()["photo"];
                        sharedPrefs.about = value.data()["about"];
                        print(value.data());
                        Get.offAllNamed("/task");
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpUsername();
                            },
                          ),
                        );
                      }
                    });
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.12),
                        blurRadius: 6,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIcon(
                      type: "google",
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    TextDescription(
                      text: "SIGN UP WITH GOOGLE",
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextDescription(
                  text: "already a member?",
                ),
                SizedBox(
                  width: 6.0,
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16.0),
                            topRight: const Radius.circular(16.0),
                          ),
                        ),
                        builder: (_) => SingleChildScrollView(
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: 24, right: 24, bottom: 40, top: 36),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextDescription(
                                        text: "Sign In with..",
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          action
                                              .signInWithGoogle()
                                              .then((result) {
                                            if (result != null) {
                                              sharedPrefs.idUser = result.uid;
                                              sharedPrefs.email = result.email;
                                              final firestoreInstance =
                                                  FirebaseFirestore.instance;
                                              firestoreInstance
                                                  .collection("users")
                                                  .doc(sharedPrefs.idUser)
                                                  .snapshots()
                                                  .first
                                                  .then((value) {
                                                if (value.data() != null) {
                                                  sharedPrefs.name =
                                                      value.data()["name"];
                                                  sharedPrefs.username =
                                                      value.data()["username"];
                                                  sharedPrefs.email =
                                                      value.data()["email"];
                                                  sharedPrefs.photo =
                                                      value.data()["photo"];
                                                  sharedPrefs.about =
                                                      value.data()["about"];
                                                  print(value.data());
                                                  Get.offAllNamed("/task");
                                                } else {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return SignUpUsername();
                                                      },
                                                    ),
                                                  );
                                                }
                                              });
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: 15.0, bottom: 15.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFF000000)
                                                      .withOpacity(0.12),
                                                  blurRadius: 6,
                                                  offset: Offset(0,
                                                      2), // changes position of shadow
                                                ),
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomIcon(
                                                type: "google",
                                              ),
                                              SizedBox(
                                                width: 16.0,
                                              ),
                                              TextDescription(
                                                text: "SIGN IN WITH GOOGLE",
                                                fontWeight: FontWeight.w600,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ));
                  },
                  child: TextDescription(
                    text: "Sign In",
                    fontWeight: FontWeight.w800,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
