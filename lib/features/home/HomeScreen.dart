import 'package:closa_flutter/features/home/HistoryTaskScreen.dart';
import 'package:flutter/material.dart';
import '../home/TaskScreen.dart';
import '../../widgets/BottomSheetAdd.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  bool state = true;

  void _settingModalBottomSheet(context) {
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      if (_pageController.page > 0.6 || _pageController.page < 0.4) {
        setState(() {
          state = _pageController.page < 0.4;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
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
                          style: state
                              ? TextStyle(color: Colors.black, fontSize: 14.0)
                              : TextStyle(color: Colors.grey, fontSize: 14.0)),
                      onTap: () {
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        setState(() {
                          state = true;
                        });
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: GestureDetector(
                        child: Text("History",
                            style: state
                                ? TextStyle(color: Colors.grey, fontSize: 14.0)
                                : TextStyle(
                                    color: Colors.black, fontSize: 14.0)),
                        onTap: () {
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                          setState(() {
                            state = false;
                          });
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
                  controller: _pageController,
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
            onTap: () => _settingModalBottomSheet(context),
          ),
          bottom: 0,
          left: 0,
          right: 0,
        )
      ],
    )));
  }
}
