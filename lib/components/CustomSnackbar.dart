import 'package:closa_flutter/features/backlog/BacklogScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static movedToBacklog(context) {
    final snackBar = SnackBar(
      content: Text("Moved to Backlog"),
      action: SnackBarAction(
        textColor: Colors.amber,
        label: 'View',
        onPressed: () {
          Get.to(BacklogScreen());
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static checkDone(context, clickUndo) {
    final snackBar = SnackBar(
      content: Text("Done"),
      action: SnackBarAction(
        textColor: Colors.amber,
        label: 'Undo',
        onPressed: () {
          clickUndo();
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static deleteTodo(context, clickUndo) {
    final snackBar = SnackBar(
      content: Text("Delete Todo"),
      action: SnackBarAction(
        textColor: Colors.amber,
        label: 'Cancel',
        onPressed: () {
          clickUndo();
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
