import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/views/quiz.dart';
import '../widgets/custom_text.dart';
import '../widgets/menu_item.dart';
import 'learn.dart';
import 'my_terms.dart';

class ChooseLevel extends StatelessWidget {
  String mode;
  String category;

  ChooseLevel(this.mode, this.category);

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
                  width: width * 0.8,
                  height: height * 0.25,
                  child: FittedBox(
                      child: CustomText(
                          "${mode == "quiz" ? "Kviz " : "Učenje "} ${category == "syllables" ? "slogova" : "riječi"}",
                          TextStyle(
                              color: Colors.blue, fontSize: height * 0.2)))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuItem(
                      "Razina 1",
                      () => {
                            Get.to(
                                () => mode == "quiz"
                                    ? Quiz(category, "1")
                                    : Learn(category, "1"),
                                transition: Transition.noTransition)
                          }),
                  MenuItem(
                      "Razina 2",
                      () => {
                            Get.to(
                                () => mode == "quiz"
                                    ? Quiz(category, "2")
                                    : Learn(category, "2"),
                                transition: Transition.noTransition)
                          }),
                  MenuItem(
                      "Razina 3",
                      () => {
                            Get.to(
                                () => mode == "quiz"
                                    ? Quiz(category, "3")
                                    : Learn(category, "3"),
                                transition: Transition.noTransition)
                          }),
                ],
              ),
              mode == "learn" && category == "words"
                  ? MenuItem(
                      "Moja razina",
                      () => {
                            Get.to(() => MyTerms(false),
                                transition: Transition.noTransition)
                          })
                  : const SizedBox.shrink()
            ],
          ),
        ],
      ),
    );
  }
}
