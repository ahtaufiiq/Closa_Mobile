import 'package:closa_flutter/widgets/BottomSheetAdd.dart';
import 'package:closa_flutter/widgets/BottomSheetEdit.dart';
import 'package:closa_flutter/widgets/OptionsBacklog.dart';
import 'package:closa_flutter/widgets/OptionsTodo.dart';
import 'package:flutter/material.dart';

class ShowBottomSheet {
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

  static editTodo(context, data) {
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
              id: data.id,
              type: data["type"],
              description: data['description'],
              time: data['timestamp'],
              timeReminder: data["timeReminder"],
              notifId: data['notificationId'],
            ));
  }

  static editOptionsTodo(context, widget) {
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
              type: widget.type,
              description: widget.description,
              time: widget.time,
              timeReminder: widget.timeReminder,
              notifId: widget.notifId,
            ));
  }

  static showBottomEditBacklog(context, data) {
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
              id: data.id,
              type: data["type"],
              isBacklog: true,
              description: data['description'],
              time: data['timestamp'],
              timeReminder: data["timeReminder"],
              notifId: data['notificationId'],
            ));
  }

  static optionsBacklog(context, data) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => OptionsBacklog(
            id: data.id,
            description: data["description"],
            type: data["type"],
            time: data["timestamp"],
            timeReminder: data["timeReminder"],
            notifId: data['notificationId']));
  }

  static optionsTodo(context, data) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => OptionsTodo(
            id: data["id"],
            description: data["description"],
            type: data["type"],
            notifId: data["notifId"],
            timeReminder: data["timeReminder"],
            time: data["time"]));
  }
}
