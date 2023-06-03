import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/views/quiz.dart';
import '../controllers/mascot_lottie_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/menu_item.dart';
import 'learn.dart';
import 'my_terms.dart';

class ChooseLevel extends StatelessWidget {
  final mascotController = Get.put(MascotLottieController());
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
                  width: width * 0.85,
                  height: height * 0.5,
                  child: Row(
                    children: [
                      Lottie.asset(
                          width: width * 0.3,
                          'assets/lottie/elephant.json',
                          controller: mascotController.controller,
                          onLoaded: (composition) {
                        mascotController.controller.duration =
                            composition.duration;
                        mascotController.controller.forward();
                      }),
                      SizedBox(
                          width: width * 0.55,
                          child: CustomText(
                              "Odaberi razinu ${category == "syllables" ? "slogova" : "pojmova"}",
                              TextStyle(
                                  color: Colors.blue, fontSize: height * 0.1))),
                    ],
                  )),
              SizedBox(
                height: category == "words"
                    ? height * 0.5 : height * 0.4,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
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
                    ),
                    category == "words"
                        ? MenuItem(
                        "Moja razina",
                            () => {
                          if(mode == "learn") {
                            Get.to(() => MyTerms(false), transition: Transition.noTransition),
                            } else if (Hive.box("user_data").length >= 3){
                           Get.to(() => Quiz.userData(), transition: Transition.noTransition),
                            } else Get.defaultDialog(titleStyle: const TextStyle(color: Colors.blue), title: "Kviz vlastitih pojmova", middleText: "Potrebno je dodati barem troje \n pojmova za igranje kviza")
                        })
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
