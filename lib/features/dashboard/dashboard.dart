import 'package:closa_flutter/core/base_action.dart';
import 'package:closa_flutter/core/base_view.dart';
import 'package:closa_flutter/features/profile/ProfileScreen.dart';
import 'package:closa_flutter/features/home/HomeScreen.dart';
import 'package:closa_flutter/widgets/BottomSheetAdd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DashboardState {
  PageController pageController = PageController();
  bool states = true;
  int selectedIndex = 0;
  DashboardState(this.pageController);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> widgetOptions = <Widget>[
    HomeScreen(),
    ProfileScreen(),
    ProfileScreen(),
  ];
}

class DashboardAction
    extends BaseAction<DashboardScreen, DashboardAction, DashboardState> {
  @override
  Future<DashboardState> initState() async {
    PageController pageController = PageController();
    pageController.addListener(() {
      if (state.pageController.page > 0.6 || state.pageController.page < 0.4) {
        state.states = state.pageController.page < 0.4;
        render();
      }
    });
    return DashboardState(pageController);
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

  void changeSelectedIndex(index) {
    state.selectedIndex = index;
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
    List<Widget> widgetOptions = state.widgetOptions;
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(state.selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.grey[800],
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Task',
                  ),
                  GButton(
                    icon: Icons.timeline,
                    text: 'Timeline',
                  ),
                  GButton(
                    icon: Icons.people,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: state.selectedIndex,
                onTabChange: (index) {
                  action.changeSelectedIndex(index);
                }),
          ),
        ),
      ),
    );
  }
}
