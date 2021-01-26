import 'package:closa_flutter/widgets/Text.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: TextHeader(text: "Coming Soon")),
      ),
    );
  }
}
