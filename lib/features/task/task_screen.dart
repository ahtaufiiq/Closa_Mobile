import 'package:closa_flutter/core/base_action.dart';
import 'package:closa_flutter/core/base_view.dart';
import 'package:closa_flutter/features/home/HistoryTaskScreen.dart';
import 'package:closa_flutter/features/home/TaskScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class TaskState {
  PageController pageController = PageController();
  bool states = true;
}

class TaskAction extends BaseAction<TaskScreen, TaskAction, TaskState> {
  @override
  Future<TaskState> initState() async {
    return TaskState();
  }

  void animateToPage(int page, bool states) {
    state.pageController.animateToPage(page,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    state.states = states;
    render();
  }
}

class TaskScreen extends BaseView<TaskScreen, TaskAction, TaskState> {
  @override
  TaskAction initAction() => TaskAction();

  @override
  Widget loadingViewBuilder(BuildContext context) => Container();

  @override
  Widget render(BuildContext context, TaskAction action, TaskState state) {
    // TODO: implement render
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 24.0, bottom: 24.0, left: 24.0),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Task",
                        style: state.states
                            ? TextStyle(color: Colors.black, fontSize: 14.0)
                            : TextStyle(color: Colors.grey, fontSize: 14.0)),
                    onTap: () {
                      action.animateToPage(0, true);
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: GestureDetector(
                      child: Text("History",
                          style: state.states
                              ? TextStyle(color: Colors.grey, fontSize: 14.0)
                              : TextStyle(color: Colors.black, fontSize: 14.0)),
                      onTap: () {
                        action.animateToPage(1, false);
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 40,
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: state.pageController,
                children: [TaskScreen1(), HistoryTaskScreen()],
              ),
            ),
          ],
        ),
      ),
    ])));
  }
}
