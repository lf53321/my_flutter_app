import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/mascot_lottie_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/menu_item.dart';
import 'choose_level.dart';

class ChooseCategory extends StatelessWidget {
  final mascotController = Get.put(MascotLottieController());
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
                  height: height * 0.5,
                  width: width * 0.85,
                  child: Row(
                        children: [
                           Lottie.asset(
                             width: width * 0.3,
                            'assets/lottie/elephant.json',
                            controller: mascotController.controller,
                            onLoaded: (composition) {
                              mascotController.controller.duration = composition.duration;
                              mascotController.controller.forward();
                            }
                      ),
                          SizedBox(
                            width: width * 0.55,
                              child: Container(
                                child: CustomText(
                                    mode == "quiz" ? "Odaberi kategoriju za kviz" : "Odaberi kategoriju za učenje",
                                    TextStyle(
                                        color: Colors.blue, fontSize: height * 0.1)),
                              ),
                            ),
                        ],
                      )),
              SizedBox(
                height: height * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: height * 0.1,
                          child: Image.asset('assets/desc/syllables.PNG',
                              fit: BoxFit.fitWidth),
                        ),
                        MenuItem(
                            "Slogovi",
                            () => {
                                  Get.to(() => ChooseLevel(mode, "syllables"),
                                      transition: Transition.noTransition)
                                }),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: height * 0.1,
                          child: Image.asset('assets/desc/terms.PNG',
                              fit: BoxFit.fitWidth),
                        ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
