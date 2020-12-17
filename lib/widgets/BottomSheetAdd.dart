import 'package:closa_flutter/helpers/sharedPref.dart';
import 'package:flutter/material.dart';
import './InputText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/FormatTime.dart';
import 'dart:math';
import 'package:closa_flutter/widgets/Text.dart';

class BottomSheetAdd extends StatefulWidget {
  final String type;

  const BottomSheetAdd({Key key, this.type}) : super(key: key);
  @override
  _BottomSheetAddState createState() => _BottomSheetAddState();
}

class _BottomSheetAddState extends State<BottomSheetAdd> {
  TextEditingController controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime dateNow = DateTime.now();
  String time;
  @override
  void initState() {
    super.initState();
    if (dateNow.minute > 15) {
      dateNow = dateNow.subtract(Duration(minutes: dateNow.minute));
      dateNow = dateNow.add(Duration(hours: 2));
    } else {
      dateNow = dateNow.subtract(Duration(minutes: dateNow.minute));
      dateNow = dateNow.add(Duration(hours: 1));
    }
    timestamp = dateNow.millisecondsSinceEpoch;
    time = FormatTime.getTime(timestamp);
  }

  int timestamp = DateTime.now().millisecondsSinceEpoch;
  int addTime = 0;
  String date = "Today";
  final firestoreInstance = FirebaseFirestore.instance;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        timestamp = picked.millisecondsSinceEpoch;
        date = FormatTime.formatDate(selectedDate);
      });
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
        time = FormatTime.formatTime(selectedTime);
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
            hint: 'e.g. Read 10 page of Atomic Habits',
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
                    child: TextDescription(text: time),
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                GestureDetector(
                  onTap: () {
                    firestoreInstance.collection("todos").add({
                      "description": controller.text,
                      "status": false,
                      "timestamp": timestamp + addTime,
                      "type":
                          widget.type == "highlight" ? 'highlight' : 'others',
                      "userId": sharedPrefs.idUser
                    }).then((value) {
                      print(value.id);
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
                          text: "Add  ",
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
