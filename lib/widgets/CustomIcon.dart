import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
enum Type { trash, edit, alarm }

class CustomIcon extends StatelessWidget {
  final String type;
  final Color color;
  CustomIcon({Key key, this.type, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return SvgPicture.asset(
        'icons/$type.svg',
        color: color ?? null,
      );
    }else{
      return SvgPicture.asset(
        'assets/icons/$type.svg',
        color: color ?? null,
      );
    }
  }
}
