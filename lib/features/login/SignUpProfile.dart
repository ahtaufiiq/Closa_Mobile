import 'dart:io';

import 'package:closa_flutter/features/home/TaskScreen.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpProfile extends StatefulWidget {
  @override
  _SignUpProfileState createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  File _image;
  final picker = ImagePicker();
  Future _imgFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _imgFromGallery() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
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
                SizedBox(
                  height: 48,
                ),
                Center(
                  child: TextSectionTitle(
                    text: "We love to see human face :)",
                  ),
                ),
                SizedBox(
                  height: 31,
                ),
                GestureDetector(
                  onTap: () => _showPicker(context),
                  child: Center(
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(48),
                            child: Image.file(
                              _image,
                              fit: BoxFit.cover,
                              width: 96,
                              height: 96,
                            ),
                          )
                        : Container(
                            child: Icon(Icons.camera),
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(48)),
                          ),
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                Center(
                  child: Container(
                    child: _image != null
                        ? TextContent(text: "You are beautiful as always 💕")
                        : Container(),
                  ),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () async {
                    if (_image != null) {
                      FirebaseStorage storage = FirebaseStorage.instance;
                      String imgName =
                          DateTime.now().millisecondsSinceEpoch.toString() +
                              ".png";
                      Reference reference =
                          storage.ref().child("profileImages/$imgName");
                      UploadTask uploadTask = reference.putFile(_image);

                      uploadTask.whenComplete(() async {
                        String imageUrl = "kosong";
                        try {
                          imageUrl = await reference.getDownloadURL();
                          sharedPrefs.photo = imageUrl;
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
                        } catch (onError) {
                          print("Error");
                        }
                      });
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          left: 24.0, right: 24.0, bottom: 60.0),
                      padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                      // margin:EdgeInsets.only(left: 24.0, right: 24.0, bottom: 60.0),
                      decoration: BoxDecoration(
                          color: _image != null
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
