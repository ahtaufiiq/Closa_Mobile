import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  InputText({Key key, this.controller, this.hint, this.focus = false})
      : super(
          key: key,
        );

  final TextEditingController controller;
  final String hint;
  final bool focus;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24.0, right: 24.0),
      child: TextField(
        controller: controller,
        autofocus: true,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
