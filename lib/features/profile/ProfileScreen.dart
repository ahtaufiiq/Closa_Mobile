import 'dart:async';
import 'package:closa_flutter/features/profile/EditProfileScreen.dart';
import 'package:closa_flutter/features/setting/SettingScreen.dart';
import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/CardHistoryTodo.dart';
import 'package:closa_flutter/widgets/CardTodo.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<QuerySnapshot> getTodo() {
    return FirebaseFirestore.instance
        .collection('todos')
        .orderBy("timestamp", descending: true)
        .where("timestamp", isLessThan: FormatTime.getTimestampTomorrow())
        .where('userId', isEqualTo: sharedPrefs.idUser)
        .where('status', isEqualTo: true)
        .snapshots();
  }

  void navigateSecondPage() {
    Route route = MaterialPageRoute(builder: (context) => EditProfile());
    Navigator.push(context, route).then(onGoBack);
  }

  void navigateToSetting() {
    Route route = MaterialPageRoute(builder: (context) => SettingsScreen());
    Navigator.push(context, route).then(onGoBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFB),
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
                      // CustomIcon(
                      //   type: "streak",
                      // ),
                      // SizedBox(
                      //   width: 6.0,
                      // ),
                      // TextDescription(
                      //   text: "37",
                      //   fontWeight: FontWeight.w600,
                      // ),
                      Expanded(child: Container()),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 2, color: Color(0xFFDDDDDD)),
                          borderRadius: BorderRadius.circular(20),
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
                                                padding:
                                                    EdgeInsets.only(top: 43),
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
                                                            const EdgeInsets
                                                                    .only(
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
                                                              text:
                                                                  "Edit Profile",
                                                              color: Color(
                                                                  0xFF222222),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        navigateToSetting();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
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
                                                              color: Color(
                                                                  0xFF222222),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 14, top: 4, bottom: 4, right: 10),
                                  decoration: BoxDecoration(color: Colors.transparent),
                                  child: CustomIcon(
                                    type: "more",
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Color(0xFFDDDDDD),
                                thickness: 1,
                                width: 1,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 10, top: 7, bottom: 7, right: 14),
                                  decoration: BoxDecoration(color: Colors.transparent),
                                  child: CustomIcon(
                                    type: "close",
                                  ),
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
                        border:
                            Border.all(width: 5.0, color: Color(0xFFEFEFEF)),
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
                Center(
                    child: TextDescription(
                  text: "@${sharedPrefs.username}",
                  color: Color(0xFF888888),
                )),
                SizedBox(
                  height: 16.0,
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 24.0, right: 24.0),
                    child: TextDescription(
                      text: "${sharedPrefs.about}",
                      align: TextAlign.center,
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
                  child: StreamBuilder(
                      stream: getTodo(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text("loading"),
                          );
                        }
                        if (snapshot.data.docs.length == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    TextDescription(
                                      text: "0",
                                      fontWeight: FontWeight.w600,
                                    ),
                                    TextDescription(text: " Completed Task"),
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 24.0),
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              Divider(
                                thickness: 8.0,
                                color: Color(0xFFEFEFEF),
                              ),
                              SizedBox(
                                height: 48.0,
                              ),
                              Center(
                                child: TextDescription(
                                  text:
                                      "Do what matters today\nGet something done",
                                  color: Color(0xFF888888),
                                ),
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.offAllNamed('/task');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 16, right: 16),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF222222),
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    child: TextSmall(
                                      text: "Go to Task",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                        var date = "";
                        var index = 0;

                        return Container(
                          margin: EdgeInsets.only(bottom: 24),
                          child: Column(
                            children: snapshot.data.docs.map((data) {
                              index++;
                              if (date ==
                                  FormatTime.getDate(data['timestamp'])) {
                                return CardHistoryTodo(
                                  id: data.id,
                                  isFirst: false,
                                  type: data['type'],
                                  description: data['description'],
                                  time: data['timestamp'],
                                );
                              } else {
                                date = FormatTime.getDate(data['timestamp']);
                                return Column(
                                  children: [
                                    index == 1
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    TextDescription(
                                                      text:
                                                          "${snapshot.data.docs.length}",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    TextDescription(
                                                        text:
                                                            " Completed Task"),
                                                  ],
                                                ),
                                                margin:
                                                    EdgeInsets.only(left: 24.0),
                                              ),
                                              SizedBox(
                                                height: 24.0,
                                              ),
                                              Divider(
                                                thickness: 8.0,
                                                color: Color(0xFFEFEFEF),
                                              )
                                            ],
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(top: 12),
                                            child: Divider(
                                              thickness: 1,
                                              color: Color(0xFFE5E5E5),
                                            ),
                                          ),
                                    CardHistoryTodo(
                                      id: data.id,
                                      isFirst: true,
                                      type: data['type'],
                                      description: data['description'],
                                      time: data['timestamp'],
                                    ),
                                  ],
                                );
                              }
                            }).toList(),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
