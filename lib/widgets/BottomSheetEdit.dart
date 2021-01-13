import 'package:closa_flutter/core/utils/local_notification.dart';
import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:flutter/material.dart';
import 'CustomIcon.dart';
import 'InputText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/FormatTime.dart';
import 'package:closa_flutter/widgets/Text.dart';

import 'OptionsTodo.dart';

class BottomSheetEdit extends StatefulWidget {
  final String description;
  final int time;
  final String id;
  final String type;
  final int notifId;
  final String timeReminder;

  const BottomSheetEdit(
      {Key key,
      this.id,
      this.description,
      this.time,
      this.type,
      this.notifId,
      this.timeReminder})
      : super(key: key);
  @override
  _BottomSheetEditState createState() => _BottomSheetEditState(
      description, DateTime.fromMillisecondsSinceEpoch(time));
}

class _BottomSheetEditState extends State<BottomSheetEdit> {
  String description = "";
  int timestamp;
  String textTime = "";
  DateTime dateTime;
  _BottomSheetEditState(this.description, this.dateTime);
  TextEditingController controller = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  int addTime = 0;

  @override
  void initState() {
    super.initState();
    controller.text = description;
    selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    textTime = FormatTime.formatTime(selectedTime);
    timestamp = DateTime(dateTime.year, dateTime.month, dateTime.day)
        .millisecondsSinceEpoch;
    addTime = FormatTime.addTime(selectedTime.hour, selectedTime.minute);
  }

  void setNotificationTime() async {
    DateTime time = DateTime.now();

    time = new DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        selectedTime.hour, selectedTime.minute - 10);

    LocalNotification().setNotification(
        '${controller.text} at ${FormatTime.getInfoTime(selectedTime.hour, selectedTime.minute)}',
        time,
        widget.notifId);
  }

  DateTime selectedDate = DateTime.now();

  String date = "Today";

  final firestoreInstance = FirebaseFirestore.instance;
  void optionsBottomSheet(context, data) {
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
            notifId: data["notificationId"],
            timeReminder: data["timeReminder"],
            time: data["time"]));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        timestamp = picked.millisecondsSinceEpoch;
        date = FormatTime.formatDate(selectedDate);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        addTime = FormatTime.addTime(selectedTime.hour, selectedTime.minute);
        textTime = FormatTime.formatTime(selectedTime);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          SizedBox(
            height: 12.0,
          ),
          InputText(
            controller: controller,
            hint: 'Eg: Read 10 page of Atomic Habits',
            focus: true,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 4.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: TextDescription(text: date),
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                  ),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: TextDescription(text: textTime),
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 4.0),
            child: Row(
              children: [
                CustomIcon(
                  type: "bell",
                ),
                SizedBox(
                  width: 10.0,
                ),
                TextDescription(text: widget.timeReminder),
                SizedBox(
                  width: 24.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    var data = {
                      "id": widget.id,
                      "description": controller.text,
                      "type": widget.type,
                      "time": timestamp + addTime,
                      "timeReminder": widget.timeReminder,
                      "notifId": widget.notifId
                    };
                    optionsBottomSheet(context, data);
                  },
                  child: CustomIcon(
                    type: "more",
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    firestoreInstance
                        .collection("todos")
                        .doc(widget.id)
                        .update({
                      "description": controller.text,
                      "timestamp": timestamp + addTime,
                      "type": widget.type,
                      "userId": sharedPrefs.idUser
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: Row(
                      children: [
                        TextDescription(
                          text: "Edit  ",
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 14.0,
                        )
                      ],
                    ),
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
        ],
      ),
    ));
  }
}
