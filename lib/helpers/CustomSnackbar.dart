import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:closa_flutter/helpers/Network.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static checklistTodo(context, widget) {
    bool isDelete = true;
    Flushbar flushbar;
    flushbar = Flushbar(
        margin: EdgeInsets.only(bottom: 107, left: 24, right: 24),
        duration: Duration(seconds: 3),
        borderRadius: 4.0,
        icon: CustomIcon(type: "checkDone"),
        mainButton: FlatButton(
          onPressed: () {
            isDelete = false;
            flushbar.dismiss(true);
          },
          child: Text(
            "Undo",
            style: TextStyle(color: Colors.amber),
          ),
        ),
        message: "Done");

    flushbar
      ..onStatusChanged = (FlushbarStatus flushbarStatus) {
        switch (flushbarStatus) {
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
              break;
            }
          case FlushbarStatus.DISMISSED:
            {
              if (!isDelete) {
                FirebaseFirestore.instance
                    .collection("todos")
                    .doc(widget.id)
                    .update({"status": false, 'timestamp': widget.time});
              } else {
                Network.postDone(widget.description, widget.type);
                LocalNotification().cancelNotification(widget.notifId);
              }
              break;
            }
        }
      }
      ..show(context);
  }

  static movedToBacklog(context) {
    Flushbar flushbar;
    flushbar = Flushbar(
        margin: EdgeInsets.only(bottom: 107, left: 24, right: 24),
        duration: Duration(seconds: 3),
        borderRadius: 4.0,
        icon: CustomIcon(
          type: "arrowUpRight",
        ),
        mainButton: FlatButton(
          onPressed: () {
            Get.to(BacklogScreen());
          },
          child: Text(
            "View",
            style: TextStyle(color: Colors.amber),
          ),
        ),
        message: "Moved to Backlog");

    flushbar
      ..onStatusChanged = (FlushbarStatus status) async {
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
              break;
            }
          case FlushbarStatus.DISMISSED:
            {
              break;
            }
        }
      }
      ..show(context);
  }

  static deleteTodo(widget, dialogContext) {
    var todo = {
      "description": widget.description,
      "status": false,
      "timestamp": widget.time,
      "notificationId": widget.notifId,
      "timeReminder": widget.timeReminder,
      "type": widget.type,
      "userId": sharedPrefs.idUser
    };
    bool isDelete = true;
    Flushbar flushbar;
    flushbar = Flushbar(
        margin: EdgeInsets.only(bottom: 107, left: 24, right: 24),
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
      ..onStatusChanged = (FlushbarStatus status) async {
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
                await LocalNotification().cancelNotification(widget.notifId);
              }
              break;
            }
          case FlushbarStatus.DISMISSED:
            {
              if (!isDelete) {
                await FirebaseFirestore.instance.collection("todos").add(todo);
              }

              break;
            }
        }
      }
      ..show(dialogContext);
  }
}
