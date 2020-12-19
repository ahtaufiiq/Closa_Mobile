import 'dart:async';

import 'package:closa_flutter/features/profile/EditProfileScreen.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  signout() async {
    await FirebaseAuth.instance.signOut();
    sharedPrefs.clear();
    Get.offAllNamed("/signup");
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  void navigateSecondPage() {
    Route route = MaterialPageRoute(builder: (context) => EditProfile());
    Navigator.push(context, route).then(onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
              child: Row(
                children: [
                  CustomIcon(
                    type: "streak",
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  TextDescription(
                    text: "37",
                    fontWeight: FontWeight.w600,
                  ),
                  Expanded(child: Container()),
                  Container(
                    padding:
                        EdgeInsets.only(left: 14, right: 14, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Color(0xFFDDDDDD)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
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
                                            padding: EdgeInsets.only(top: 43),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    navigateSecondPage();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 24.0,
                                                            bottom: 28.0),
                                                    child: Row(
                                                      children: [
                                                        CustomIcon(
                                                          type: "edit",
                                                        ),
                                                        SizedBox(
                                                          width: 20.0,
                                                        ),
                                                        TextDescription(
                                                          text: "Edit Profile",
                                                          color:
                                                              Color(0xFF222222),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 24.0,
                                                          bottom: 28.0),
                                                  child: Row(
                                                    children: [
                                                      CustomIcon(
                                                        type: "settings",
                                                      ),
                                                      SizedBox(
                                                        width: 20.0,
                                                      ),
                                                      TextDescription(
                                                        text: "Settings",
                                                        color:
                                                            Color(0xFF222222),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ));
                            },
                            child: CustomIcon(
                              type: "more",
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          VerticalDivider(
                            color: Color(0xFFDDDDDD),
                            thickness: 1,
                            width: 1,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CustomIcon(
                              type: "close",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Container(
                width: 64.0,
                height: 64.0,
                decoration: BoxDecoration(
                    border: Border.all(width: 5.0, color: Color(0xFFEFEFEF)),
                    image: DecorationImage(
                        image: NetworkImage(sharedPrefs.photo),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(21.0)),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Center(
              child: TextDescription(
                  text: "${sharedPrefs.name}", fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 6.0,
            ),
            Center(child: TextDescription(text: "${sharedPrefs.username}")),
            SizedBox(
              height: 16.0,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(left: 24.0, right: 24.0),
                child: TextDescription(
                  text: "${sharedPrefs.about}",
                  align: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Divider(
              thickness: 1.0,
              color: Color(0xFFE5E5E5),
            ),
            SizedBox(
              height: 24.0,
            ),
            Container(
              child: TextDescription(text: "224 Completed Task"),
              margin: EdgeInsets.only(left: 24.0),
            ),
            SizedBox(
              height: 24.0,
            ),
            Divider(
              thickness: 8.0,
              color: Color(0xFFEFEFEF),
            ),
            Container(
              margin: EdgeInsets.only(left: 24.0, right: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextDescription(text: "Nov\n23"),
                  SizedBox(
                    width: 24.0,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextDescription(text: "@apri"),
                            SizedBox(
                              width: 8.0,
                            ),
                            CustomIcon(
                              type: "streak",
                              color: Color(0xFF888888),
                            ),
                            SizedBox(
                              width: 3.0,
                            ),
                            TextDescription(
                              text: "37",
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF888888),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomIcon(
                              type: 'check',
                              color: Color(0xFF40B063),
                            ),
                            TextDescription(
                              text:
                                  "Continue Design & Prototype Personal To-do App",
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomIcon(
                              type: 'check',
                              color: Color(0xFF40B063),
                            ),
                            TextDescription(
                              text:
                                  "Continue Design & Prototype Personal To-do App",
                            )
                          ],
                        )
                      ]),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
