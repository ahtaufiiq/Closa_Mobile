import 'package:closa_flutter/features/profile/ProfileScreen.dart';
import 'package:closa_flutter/widgets/BottomSheetEdit.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'package:closa_flutter/core/base_action.dart';
import 'package:closa_flutter/core/base_view.dart';
import '../../widgets/Text.dart';
import '../../widgets/CardTodo.dart';
import '../../helpers/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../helpers/FormatTime.dart';
import '../../widgets/OptionsTodo.dart';
import 'package:closa_flutter/widgets/BottomSheetAdd.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskState {
  int totalTodo = 0;
  bool emptyTodo = false;
  bool emptyHighlight = false;
  bool doneHighlight = false;
}

class TaskAction extends BaseAction<TaskScreen, TaskAction, TaskState> {
  @override
  Future<TaskState> initState() async {
    return TaskState();
  }

  void saveValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getValue(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  void incrementTotalTodo() {
    state.totalTodo++;
    print(state.totalTodo);
  }

  void decrementTotalTodo() {
    state.totalTodo--;
    print(state.totalTodo);
  }

  void showBottomAdd(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
          ),
        ),
        builder: (_) => BottomSheetAdd());
  }

  void showBottomEdit(context, data) {
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
              description: data['description'],
              time: data['timestamp'],
            ));
  }

  Stream<QuerySnapshot> getHighlight() {
    return FirebaseFirestore.instance
        .collection('todos')
        .where('userId', isEqualTo: "andi")
        .where('type', isEqualTo: 'highlight')
        .where("timestamp",
            isGreaterThanOrEqualTo: FormatTime.getTimestampToday())
        .where("timestamp", isLessThan: FormatTime.getTimestampTomorrow())
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getTodo() {
    return FirebaseFirestore.instance
        .collection('todos')
        .where('status', isEqualTo: false)
        .where("timestamp",
            isGreaterThanOrEqualTo: FormatTime.getTimestampToday())
        .where("timestamp", isLessThan: FormatTime.getTimestampTomorrow())
        .snapshots();
  }

  void addTodoBottomSheet(context, {type = "default"}) {
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

  void openScreenProfile(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

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
            id: data.id,
            description: data['description'],
            time: data['timestamp']));
  }
}

class TaskScreen extends BaseView<TaskScreen, TaskAction, TaskState> {
  @override
  TaskAction initAction() => TaskAction();

  @override
  Widget loadingViewBuilder(BuildContext context) => Container();

  @override
  Widget render(BuildContext context, action, state) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFB),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 60.0,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 24.0, top: 28.0),
                        child: TextDescription(
                          text: "Task",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 16.0, left: 24.0, right: 24.0),
                        child: TextHeader(text: FormatTime.getToday()),
                      ),
                      state.doneHighlight
                          ? Container()
                          : Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 24.0, right: 24.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.wb_sunny_outlined,
                                        color: Colors.grey,
                                        size: 16.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4.0),
                                      ),
                                      TextDescription(
                                        text: "Highlight",
                                        color: CustomColor.Grey,
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 24.0, right: 24.0),
                                  child: StreamBuilder(
                                      stream: action.getHighlight(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: Text("loading"),
                                          );
                                        }
                                        if (snapshot.data.docs.length == 0) {
                                          return Center(
                                              child: GestureDetector(
                                            onTap: () {
                                              action.addTodoBottomSheet(context,
                                                  type: "highlight");
                                            },
                                            child: Card(
                                              margin: EdgeInsets.only(
                                                  top: 16.0,
                                                  left: 2.0,
                                                  right: 2.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              elevation: 4.0,
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 24.0,
                                                      bottom: 24.0,
                                                      left: 16.0,
                                                      right: 24.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.wb_sunny_outlined,
                                                        color:
                                                            Color(0xFFFF9500),
                                                      ),
                                                      SizedBox(
                                                        width: 12.0,
                                                      ),
                                                      Expanded(
                                                          child: TextDescription(
                                                              text:
                                                                  "Set Highlight Today")),
                                                    ],
                                                  )),
                                            ),
                                          ));
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            action.optionsBottomSheet(context,
                                                snapshot.data.docs.last);
                                          },
                                          child: CardTodo(
                                            id: snapshot.data.docs.last.id,
                                            description: snapshot
                                                .data.docs.last['description'],
                                            time: snapshot
                                                .data.docs.last['timestamp'],
                                          ),
                                        );
                                      }),
                                ),
                                Divider(
                                  color: CustomColor.Divider,
                                  thickness: 1,
                                  height: 56.0,
                                ),
                              ],
                            ),
                      state.emptyTodo
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 24.0, right: 24.0),
                                  child: TextDescription(
                                    text: "Others",
                                    color: CustomColor.Grey,
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 24.0, right: 24.0),
                                  child: StreamBuilder(
                                      stream: action.getTodo(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                            child: Text("loading"),
                                          );
                                        }
                                        if (snapshot.data.docs.length == 0) {
                                          return Center(
                                            child: Text("Kosong"),
                                          );
                                        }
                                        return Column(
                                          children:
                                              snapshot.data.docs.map((data) {
                                            if (data['type'] != 'highlight') {
                                              return GestureDetector(
                                                onTap: () {
                                                  action.showBottomEdit(
                                                      context, data);
                                                },
                                                child: CardTodo(
                                                  id: data.id,
                                                  description:
                                                      data['description'],
                                                  time: data['timestamp'],
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }).toList(),
                                        );
                                      }),
                                ),
                                SizedBox(
                                  height: 10.0,
                                )
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                child: GestureDetector(
                  onTap: () => action.saveValue("tes", "testing pertama"),
                  child: CustomIcon(
                    type: "menu",
                  ),
                ),
                left: 24.0,
                bottom: 24.0),
            Positioned(
                child: GestureDetector(
                  // onTap: () => action.openScreenProfile(context),
                  onTap: () {
                    action.openScreenProfile(context);
                  },
                  child: CustomIcon(
                    type: "profile",
                  ),
                ),
                right: 24.0,
                bottom: 24.0),
            Positioned(
              child: GestureDetector(
                onTap: () => action.showBottomAdd(context),
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.12),
                        blurRadius: 6,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: CustomIcon(
                    type: "add",
                  ),
                ),
              ),
              bottom: 32.0,
            ),
          ],
        ),
      ),
    );
  }
}
