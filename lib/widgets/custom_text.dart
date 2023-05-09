import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class CustomText extends StatelessWidget {
  String text;
  TextStyle? textStyle;

  CustomText(this.text, this.textStyle);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, box, widget) {
        return Text(box.get("caps") ? text.toUpperCase() : text, style: box.get("highContrast") ? TextStyle(color: Colors.black, backgroundColor: Colors.yellow, fontSize: textStyle?.fontSize) : textStyle,);
    });
  }
}
