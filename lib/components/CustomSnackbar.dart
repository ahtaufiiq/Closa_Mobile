import 'package:closa_flutter/model/Todo.dart';
import 'package:closa_flutter/widgets/BottomSheetAdd.dart';
import 'package:closa_flutter/widgets/BottomSheetEdit.dart';
import 'package:closa_flutter/widgets/OptionsBacklog.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static addTodo(context, {type = "default"}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => BottomSheetAdd(
              type: type,
            ));
  }

  static deleteTodo() {}

  static optionsTodo(context, Todo todo, id) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => OptionsBacklog(id: id, todo: todo));
  }

  static editTodo(context, Todo todo, id, {isBacklog: false}) {
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
              isBacklog: isBacklog,
              id: id,
              type: todo.type,
              description: todo.description,
              time: todo.timestamp,
              timeReminder: todo.timeReminder,
              notifId: todo.notificationId,
            ));
  }
}
