import 'package:closa_flutter/core/base_action.dart';
import 'package:closa_flutter/core/base_view.dart';
import 'package:closa_flutter/features/home/HistoryTaskScreen.dart';
import 'package:closa_flutter/features/home/TaskScreen.dart';
import 'package:closa_flutter/helpers/CustomScrolling.dart';
import 'package:closa_flutter/main.dart';
import 'package:closa_flutter/widgets/BottomSheetAdd.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DashboardState {
  PageController pageController = PageController();
  bool states = true;
}

class DashboardAction
    extends BaseAction<DashboardScreen, DashboardAction, DashboardState> {
  @override
  Future<DashboardState> initState() {
    state.pageController = PageController();
    state.pageController.addListener(() {
      if (state.pageController.page > 0.6 || state.pageController.page < 0.4) {
        state.states = state.pageController.page < 0.4;
        render();
      }
    });
  }

  void settingModalBottomSheet(context) {
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

  void stateStates(bool states) {
    state.states = states;
    render();
  }
}

class DashboardScreen
    extends BaseView<DashboardScreen, DashboardAction, DashboardState> {
  @override
  DashboardAction initAction() => DashboardAction();

  @override
  Widget loadingViewBuilder(BuildContext context) => Container(
        color: Colors.white24,
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.black,
            size: 50.0,
          ),
        ),
      );

  @override
  Widget render(
      BuildContext context, DashboardAction action, DashboardState state) {
    // TODO: implement render
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
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
                        state.pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        action.stateStates(true);
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        child: Text("History",
                            style: state.states
                                ? TextStyle(color: Colors.grey, fontSize: 14.0)
                                : TextStyle(
                                    color: Colors.black, fontSize: 14.0)),
                        onTap: () {
                          state.pageController.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                          action.stateStates(false);
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
                  children: [TaskScreen(), HistoryTaskScreen()],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          child: GestureDetector(
            child: Container(
                child: Icon(Icons.linear_scale),
                padding: EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0)),
            onTap: () => action.settingModalBottomSheet(context),
          ),
          bottom: 0,
          left: 0,
          right: 0,
        )
      ],
    )));
  }
}
