import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/controllers/mascot_lottie_controller.dart';
import 'package:my_flutter_app/controllers/menu_item_controller.dart';
import 'package:my_flutter_app/views/settings.dart';
import '../controllers/menu_animations_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/menu_item.dart';
import 'choose_category.dart';
import 'my_terms.dart';

class Home extends StatelessWidget {
  final mascotController = Get.put(MascotLottieController());
  MenuItemController menuItemController = Get.put(MenuItemController());
  MenuAnimationsController menuController = Get.put(MenuAnimationsController());

  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        bool close = false;
        Get.defaultDialog(
            title: "IZLAZ",
            titleStyle: const TextStyle(color: Colors.blue),
            middleText: "Jeste li sigurni da želite izaći?",
            textConfirm: "Izađi",
            textCancel: "Povratak",
            onConfirm: () => {
              close = true,
              if (Platform.isAndroid)
                {SystemNavigator.pop()}
              else if (Platform.isIOS)
                {exit(0)}
            });
        return close;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                    iconSize: height * 0.2,
                    onPressed: () => {
                          Get.to(() => Settings(),
                              transition: Transition.noTransition)
                        },
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.blue,
                    ))),
            Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                    iconSize: height * 0.2,
                    onPressed: () => {
                          Get.defaultDialog(
                              title: "IZLAZ",
                              titleStyle: const TextStyle(color: Colors.blue),
                              middleText: "Jeste li sigurni da želite izaći?",
                              textConfirm: "Izađi",
                              textCancel: "Povratak",
                              onConfirm: () => {
                                    if (Platform.isAndroid)
                                      {SystemNavigator.pop()}
                                    else if (Platform.isIOS)
                                      {exit(0)}
                                  }),
                        },
                    icon: const Icon(
                      Icons.exit_to_app_rounded,
                      color: Colors.blue,
                    ))),
            Positioned(
                top: height * 0.05,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                        height: height * 0.2,
                        child: FittedBox(
                          child: CustomText(
                              "SLOGALO",
                              TextStyle(
                                  color: Colors.blue, fontSize: height * 0.3)),
                        )),
                  ],
                ))),
            Positioned(
                top: height * 0.05,
                child: Lottie.asset('assets/lottie/elephant.json',
                    height: height * 0.7, controller: mascotController.controller,
                    onLoaded: (composition) {
                  mascotController.controller.duration = composition.duration;
                  mascotController.controller.forward();
                })),
            Positioned(
              bottom: height * 0.05,
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuItem(
                      "Učenje",
                      () => {
                            menuController.setFirst(),
                          }),
                  MenuItem(
                      "Igra",
                      () => {
                            menuController.setSecond(),
                          }),
                  MenuItem(
                      "Galerija",
                      () => {
                            menuController.setThird(),
                          }),
                ],
              ),
            ),
            Positioned(
                bottom: height * 0.19,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => menuController.first.value
                          ? IgnorePointer(
                              child: SizedBox(
                                width: width * 0.85 / 3,
                                child: Lottie.asset('assets/lottie/learning.json',
                                    height: height * 0.2,
                                    controller: menuItemController.controller,
                                    onLoaded: (composition) {
                                  menuItemController.controller.duration =
                                      composition.duration;
                                  menuItemController.controller
                                      .forward()
                                      .then((value) => {
                                            menuController.reset(),
                                            menuItemController.controller.reset(),
                                            Get.to(() => ChooseCategory("learn"),
                                                transition:
                                                    Transition.noTransition),
                                          });
                                }),
                              ),
                            )
                          : IgnorePointer(
                              child: SizedBox(
                                width: width * 0.85 / 3,
                              ),
                            ),
                    ),
                    Obx(
                      () => menuController.second.value
                          ? IgnorePointer(
                              child: SizedBox(
                                width: width * 0.85 / 3,
                                child: Lottie.asset('assets/lottie/quiz.json',
                                    height: height * 0.2,
                                    controller: menuItemController.controller,
                                    onLoaded: (composition) {
                                  menuItemController.controller.duration =
                                      composition.duration;
                                  menuItemController.controller
                                      .forward()
                                      .then((value) => {
                                            menuController.reset(),
                                            menuItemController.controller.reset(),
                                            Get.to(() => ChooseCategory("quiz"),
                                                transition:
                                                    Transition.noTransition),
                                          });
                                }),
                              ),
                            )
                          : IgnorePointer(
                              child: SizedBox(
                                width: width * 0.85 / 3,
                              ),
                            ),
                    ),
                    Obx(
                      () => menuController.third.value
                          ? IgnorePointer(
                              child: SizedBox(
                                width: width * 0.85 / 3,
                                child: Lottie.asset('assets/lottie/gallery.json',
                                    height: height * 0.2,
                                    controller: menuItemController.controller,
                                    onLoaded: (composition) {
                                  menuItemController.controller.duration =
                                      composition.duration;
                                  menuItemController.controller
                                      .forward()
                                      .then((value) => {
                                            menuController.reset(),
                                            menuItemController.controller.reset(),
                                            Get.to(() => MyTerms(true),
                                                transition:
                                                    Transition.noTransition),
                                          });
                                }),
                              ),
                            )
                          : IgnorePointer(
                              child: SizedBox(
                                width: width * 0.85 / 3,
                              ),
                            ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
