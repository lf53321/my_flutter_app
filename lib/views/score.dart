import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_text.dart';
import '../widgets/menu_item.dart';
import 'choose_category.dart';
import 'home.dart';

class Score extends StatelessWidget {
  String category;
  String level;
  int score;

  Score(this.category, this.level, this.score);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Center(
          child: SizedBox(
            width: width * 0.8,
            child: FittedBox(
              child: CustomText("Rezultat: $score/3",
                  TextStyle(color: Colors.blue, fontSize: height * 0.3)),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MenuItem(
                "Kviz",
                () => {
                      Get.offUntil(
                          PageRouteBuilder(
                              pageBuilder: (context, a1, a2) =>
                                  ChooseCategory("quiz")),
                          (route) => route.settings.name == '/'),
                    }),
            MenuItem(
                "Učenje",
                () => {
                      Get.offUntil(
                          PageRouteBuilder(
                              pageBuilder: (context, a1, a2) =>
                                  ChooseCategory("learn")),
                          (route) => route.settings.name == '/'),
                    }),
            MenuItem(
                "Početna",
                () => {
                      Get.offAll(() => Home(),
                          transition: Transition.noTransition)
                    }),
          ],
        )
      ],
    ));
  }
}
