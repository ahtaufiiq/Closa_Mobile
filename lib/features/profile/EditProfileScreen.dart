import 'dart:io';

import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final aboutController = TextEditingController();

  int usernameLength = sharedPrefs.username.length;
  int nameLength = sharedPrefs.name.length;
  int aboutLength = sharedPrefs.about.length;
  var urlPhoto = sharedPrefs.photo;
  File _image;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    usernameController.text = sharedPrefs.username;
    nameController.text = sharedPrefs.name;
    aboutController.text = sharedPrefs.about;
    usernameController.addListener(_getUsernameValue);
    nameController.addListener(_getNameValue);
    aboutController.addListener(_getAboutValue);
  }

  bool validation() {
    return usernameLength != 0 && nameLength != 0 && aboutLength != 0;
  }

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

  _getUsernameValue() {
    setState(() {
      usernameLength = usernameController.text.length;
    });
  }

  _getNameValue() {
    setState(() {
      nameLength = nameController.text.length;
    });
  }

  _getAboutValue() {
    setState(() {
      aboutLength = aboutController.text.length;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: TextDescription(
                      text: "Cancel",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (validation()) {
                        final firestoreInstance = FirebaseFirestore.instance;
                        sharedPrefs.username = usernameController.text;
                        sharedPrefs.name = nameController.text;
                        sharedPrefs.about = aboutController.text;
                        sharedPrefs.photo = urlPhoto;
                        firestoreInstance
                            .collection("users")
                            .doc(sharedPrefs.idUser)
                            .update({
                          "name": nameController.text,
                          "photo": urlPhoto,
                          "username": usernameController.text,
                          "about": aboutController.text
                        }).then((value) {
                          Get.back();
                        });
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 22, right: 22, top: 8, bottom: 8),
                        margin: EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                            color: validation()
                                ? Color(0xFF222222)
                                : Color(0xFFCCCCCC),
                            borderRadius: BorderRadius.circular(20)),
                        child: TextSmall(
                          text: "Save",
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                margin: const EdgeInsets.only(left: 24.0),
                child: TextSmall(
                  text: "USERNAME",
                  color: Color(0xFF222222),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Row(
                  children: [
                    Text("@"),
                    Expanded(
                        child: TextField(
                      controller: usernameController,
                    )),
                    Text("20")
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Divider(
                thickness: 1,
                color: Color(0xFFE5E5E5),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () => _showPicker(context),
                        child: _image != null
                            ? Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image),
                                        fit: BoxFit.cover),
                                    color: Color(0xFFC4C4C4),
                                    border: Border.all(
                                        color: Color(0xFFEFEFEF), width: 5),
                                    borderRadius: BorderRadius.circular(21)),
                              )
                            : urlPhoto != null
                                ? Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(urlPhoto),
                                            fit: BoxFit.cover),
                                        color: Color(0xFFC4C4C4),
                                        border: Border.all(
                                            color: Color(0xFFEFEFEF), width: 5),
                                        borderRadius:
                                            BorderRadius.circular(21)),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFC4C4C4),
                                        border: Border.all(
                                            color: Color(0xFFEFEFEF), width: 5),
                                        borderRadius:
                                            BorderRadius.circular(21)),
                                    child: CustomIcon(
                                      type: "defaultAvatar",
                                    ),
                                  )),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextSmall(
                          text: "PROFILE PICTURE",
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_image != null) {
                              FirebaseStorage storage =
                                  FirebaseStorage.instance;
                              String imgName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString() +
                                  ".png";
                              Reference reference =
                                  storage.ref().child("profileImages/$imgName");
                              UploadTask uploadTask = reference.putFile(_image);

                              uploadTask.whenComplete(() async {
                                try {
                                  urlPhoto = await reference.getDownloadURL();
                                  print("berhasil upload");
                                } catch (onError) {
                                  print("Error");
                                }
                              });
                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF888888),
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              child: TextSmall(
                                text: "Upload",
                                color: Colors.white,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 29,
              ),
              Divider(
                thickness: 1,
                color: Color(0xFFE5E5E5),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                margin: EdgeInsets.only(left: 24),
                child: TextSmall(
                  text: "NAME",
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: nameController,
                    )),
                    Text("20")
                  ],
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Divider(
                thickness: 1,
                color: Color(0xFFE5E5E5),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                margin: EdgeInsets.only(left: 24),
                child: TextSmall(
                  text: "ABOUT",
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                margin: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: aboutController,
                    )),
                    Text("180")
                  ],
                ),
              ),
              SizedBox(
                height: 28,
              ),
              Divider(
                thickness: 1,
                color: Color(0xFFE5E5E5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
