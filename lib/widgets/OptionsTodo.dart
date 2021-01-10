import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './BottomSheetEdit.dart';
import 'package:flushbar/flushbar.dart';
import 'CustomIcon.dart';
import '../helpers/color.dart';
import 'Text.dart';

class OptionsTodo extends StatefulWidget {
  final String description;
  final int time;
  final String type;
  final String id;
  final int notifId;
  const OptionsTodo({
    Key key,
    this.notifId,
    this.id,
    this.description,
    this.time,
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
                            bool isDelete = true;
                            Flushbar flushbar;
                            flushbar = Flushbar(
                                margin: EdgeInsets.only(
                                    bottom: 107, left: 24, right: 24),
                                duration: Duration(seconds: 3),
                                borderRadius: 4.0,
                                mainButton: FlatButton(
                                  onPressed: () {
                                    isDelete = false;
                                    flushbar.dismiss(true);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ), // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
                                message: "Delete Todo");

                            flushbar
                              ..onStatusChanged =
                                  (FlushbarStatus status) async {
                                switch (status) {
                                  case FlushbarStatus.SHOWING:
                                    {
                                      break;
                                    }
                                  case FlushbarStatus.IS_APPEARING:
                                    {
                                      break;
                                    }
                                  case FlushbarStatus.IS_HIDING:
                                    {
                                      if (isDelete) {
                                        firestoreInstance
                                            .collection("todos")
                                            .doc(widget.id)
                                            .delete();
                                        FlutterLocalNotificationsPlugin()
                                            .cancel(widget.time);
                                      }
                                      await LocalNotification()
                                          .cancelNotification(widget.notifId);
                                      break;
                                    }
                                  case FlushbarStatus.DISMISSED:
                                    {
                                      break;
                                    }
                                }
                              }
                              ..show(dialogContext);
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
