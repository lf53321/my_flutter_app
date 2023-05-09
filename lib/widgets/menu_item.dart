import 'package:flutter/material.dart';

import 'custom_text.dart';

class MenuItem extends StatelessWidget {
  String text;
  var function;

  MenuItem(this.text, this.function);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width*0.85/3,
        height: height*0.2,
        child: ElevatedButton(
            onPressed: function,
            child: FittedBox(child: CustomText(text, TextStyle(fontSize: height*0.1),)),
      ),
    ));
  }
}
