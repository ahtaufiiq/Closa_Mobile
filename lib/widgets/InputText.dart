import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    print(oldValue);
    return TextEditingValue(
      text: newValue.text?.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class InputText extends StatelessWidget {
  InputText(
      {Key key, this.controller, this.hint, this.focus = false, this.update})
      : super(
          key: key,
        );

  final TextEditingController controller;
  final String hint;
  final update;
  final bool focus;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24.0, right: 24.0),
      child: TextField(
          // inputFormatters: [UpperCaseTextFormatter()],
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            update(value);
          },
          controller: controller,
          autofocus: true,
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w600, fontFamily: "Inter"),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(color: Color(0xFFCCCCCC)))),
    );
  }
}
