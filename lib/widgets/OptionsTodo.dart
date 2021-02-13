import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:closa_flutter/helpers/CustomSnackbar.dart';
import 'package:closa_flutter/helpers/FormatTime.dart';
import 'package:closa_flutter/helpers/Network.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/helpers/showBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import './BottomSheetEdit.dart';
import 'CustomIcon.dart';
import '../helpers/color.dart';
import 'Text.dart';

class OptionsTodo extends StatefulWidget {
  final String description;
  final int time;
  final String type;
  final String id;
  final int notifId;
  final String timeReminder;
  const OptionsTodo({
    Key key,
    this.notifId,
    this.id,
    this.description,
    this.time,
    this.timeReminder,
    this.type,
  }) : super(key: key);

  @override
  _OptionsTodoState createState() => _OptionsTodoState(description, time);
}

class _OptionsTodoState extends State<OptionsTodo> {
  String description = "";
  int time;
  _OptionsTodoState(this.description, this.time);

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
            height: 12.0,
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 24.0),
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
              ShowBottomSheet.editOptionsTodo(context, widget);
            },
          ),
          SizedBox(
            height: 24.0,
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  CustomIcon(
                    type: "arrowUpRight",
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  TextDescription(
                    text: "Tomorrow",
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              firestoreInstance.collection("todos").doc(widget.id).update({
                "timestamp": FormatTime.setTomorrow(widget.time),
              });
              LocalNotification().changeTimeNotification(widget.notifId,
                  widget.description, FormatTime.setTomorrow(widget.time));

              CustomSnackbar.movedToBacklog(context);
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
