import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';
import '../widgets/menu_item.dart';
import 'choose_level.dart';

class ChooseCategory extends StatelessWidget {
  String mode;

  ChooseCategory(this.mode);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                  iconSize: height * 0.1,
                  onPressed: () => {Get.back()},
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.blue,
                  ))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: height * 0.25,
                  width: width * 0.8,
                  child: FittedBox(
                      child: CustomText(
                          mode == "quiz" ? "Kviz" : "Učenje",
                          TextStyle(
                              color: Colors.blue, fontSize: height * 0.2)))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuItem(
                      "Slogovi",
                      () => {
                            Get.to(() => ChooseLevel(mode, "syllables"),
                                transition: Transition.noTransition)
                          }),
                  MenuItem(
                      "Pojmovi",
                      () => {
                            Get.to(() => ChooseLevel(mode, "words"),
                                transition: Transition.noTransition)
                          }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
