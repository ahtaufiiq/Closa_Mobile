import 'dart:convert';

import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:closa_flutter/helpers/CustomSnackbar.dart';
import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:closa_flutter/helpers/Network.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'BottomSheetEdit.dart';
import 'CustomIcon.dart';
import '../helpers/color.dart';
import 'Text.dart';
import 'package:http/http.dart' as http;

class OptionsBacklog extends StatefulWidget {
  final String description;
  final int time;
  final String type;
  final String id;
  final int notifId;
  final String timeReminder;
  const OptionsBacklog({
    Key key,
    this.notifId,
    this.id,
    this.description,
    this.time,
    this.timeReminder,
    this.type,
  }) : super(key: key);

  @override
  _OptionsBacklogState createState() => _OptionsBacklogState(description, time);
}

class _OptionsBacklogState extends State<OptionsBacklog> {
  String description = "";
  int time;
  _OptionsBacklogState(this.description, this.time);

  @override
  void initState() {
    super.initState();
  }

  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(widget.notifId);
    return SingleChildScrollView(
        child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24.0,
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  CustomIcon(
                    type: "iconDone",
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  TextDescription(
                    text: "Done",
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              LocalNotification().cancelNotification(widget.notifId);

              Network.checklistTodo(widget.id);

              CustomSnackbar.checklistTodo(context, widget);
            },
          ),
          SizedBox(
            height: 24,
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  CustomIcon(
                    type: "edit",
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  TextDescription(text: "Edit Task"),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16.0),
                      topRight: const Radius.circular(16.0),
                    ),
                  ),
                  builder: (_) => BottomSheetEdit(
                        id: widget.id,
                        description: widget.description,
                        type: widget.type,
                        time: widget.time,
                        isBacklog: true,
                        notifId: widget.notifId,
                        timeReminder: widget.timeReminder,
                      ));
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, bottom: 28.0),
              child: Row(
                children: [
                  CustomIcon(
                    type: "trash",
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  TextDescription(
                    text: "Delete Task",
                    color: CustomColor.LightRed,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      content: TextDescription(
                          text: 'Delete "${widget.description}" ?'),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          textColor: Colors.black,
                          child: new Text("No"),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                        new FlatButton(
                          textColor: Colors.black,
                          child: new Text("Yes"),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Network.deleteTodo(widget.id);
                            CustomSnackbar.deleteTodo(widget, dialogContext);
                          },
                        ),
                      ],
                    );
                  });
            },
          )
        ],
      ),
    ));
  }
}
