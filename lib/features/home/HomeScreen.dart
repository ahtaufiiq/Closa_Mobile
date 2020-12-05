import 'package:closa_flutter/core/base_action.dart';
import 'package:closa_flutter/core/base_view.dart';
import 'package:closa_flutter/features/home/HistoryTaskScreen.dart';
import 'package:closa_flutter/features/home/TaskScreen.dart';
import 'package:closa_flutter/helpers/color.dart';
import 'package:closa_flutter/widgets/Text.dart';
import 'package:closa_flutter/widgets/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../widgets/BottomSheetAdd.dart';

class HomeState {
  PageController pageController;
  bool states = true;
}

class HomeAction extends BaseAction<HomeScreen, HomeAction, HomeState> {
  @override
  Future<HomeState> initState() async {
    var homeState = HomeState();
    homeState.pageController = PageController();
    homeState.pageController.addListener(() {
      if (homeState.pageController.page > 0.6 ||
          homeState.pageController.page < 0.4) {
        state.states = state.pageController.page < 0.4;
        render();
      }
    });
    return homeState;
  }

  void animateToPage(int page, bool states) {
    state.pageController.animateToPage(page,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    state.states = states;
    render();
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

  void editTodo(context) {
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
}

class HomeScreen extends BaseView<HomeScreen, HomeAction, HomeState> {
  @override
  HomeAction initAction() => HomeAction();

  @override
  Widget loadingViewBuilder(BuildContext context) => Container();

  @override
  Widget render(BuildContext context, HomeAction action, HomeState state) {
    // TODO: implement render
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      backgroundColor: Colors.transparent,
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
                      child: state.states
                          ? TextDescription(
                              text: "Task",
                              fontWeight: FontWeight.w600,
                            )
                          : TextDescription(
                              text: "Task",
                              color: CustomColor.Grey,
                            ),
                      onTap: () {
                        action.animateToPage(0, true);
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        child: state.states
                            ? TextDescription(
                                text: "History",
                                color: CustomColor.Grey,
                              )
                            : TextDescription(
                                text: "History",
                                fontWeight: FontWeight.w600,
                              ),
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
                  children: [TaskScreen(), HistoryTaskScreen()],
                ),
              ),
            ],
          ),
        )
      ])),
      floatingActionButton: Container(
        width: 48.0,
        height: 48.0,
        child: FittedBox(
          child: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            child: CustomIcon(
              type: "add",
            ),
            onPressed: () => action.settingModalBottomSheet(context),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
