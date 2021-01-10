import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  const TextHeader({Key key, this.text, this.align})
      : super(
          key: key,
        );

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return new Text(
      text,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(fontSize: 24.0, fontFamily: "InterSemiBold"),
    );
  }
}

class TextSectionTitle extends StatelessWidget {
  const TextSectionTitle({Key key, this.text, this.align, this.color})
      : super(
          key: key,
        );
  final Color color;
  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return new Text(
      text,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
          fontSize: 18.0,
          fontFamily: "InterSemiBold",
          color: color ?? Color(0xFF222222)),
    );
  }
}

class TextSectionDivider extends StatelessWidget {
  const TextSectionDivider({Key key, this.text, this.align, this.color})
      : super(
          key: key,
        );
  final Color color;
  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return new Text(
      text,
      textAlign: align ?? TextAlign.center,
      style: TextStyle(
          fontSize: 14.0,
          fontFamily: "InterSemiBold",
          color: color ?? Color(0xFF222222)),
    );
  }
}

class TextContent extends StatelessWidget {
  const TextContent({Key key, this.text, this.align, this.fontWeight})
      : super(
          key: key,
        );

  final String text;
  final TextAlign align;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return new Text(
      text,
      textAlign: align ?? TextAlign.start,
      style: TextStyle(
          fontFamily: "Inter", fontSize: 16.0, fontWeight: fontWeight ?? null),
    );
  }
}

class TextDescription extends StatelessWidget {
  const TextDescription(
      {Key key, this.text, this.align, this.color, this.fontWeight})
      : super(
          key: key,
        );

  final String text;
  final FontWeight fontWeight;
  final TextAlign align;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return new Text(
      text,
      textAlign: align ?? TextAlign.start,
      style: TextStyle(
          fontFamily: "Inter",
          fontSize: 14.0,
          color: color ?? Color(0xFF222222),
          fontWeight: fontWeight ?? FontWeight.normal),
    );
  }
}

class TextSmall extends StatelessWidget {
  const TextSmall({Key key, this.text, this.align, this.color})
      : super(
          key: key,
        );

  final String text;
  final TextAlign align;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return new Text(
      text,
      textAlign: align ?? TextAlign.start,
      style:
          TextStyle(fontFamily: "Inter", fontSize: 12.0, color: color ?? null),
    );
  }
}
