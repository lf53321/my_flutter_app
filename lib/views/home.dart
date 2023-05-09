import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/views/settings.dart';
import '../widgets/custom_text.dart';
import '../widgets/menu_item.dart';
import 'choose_category.dart';
import 'my_terms.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set landscape orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                        if (Platform.isAndroid)
                          {SystemNavigator.pop()}
                        else if (Platform.isIOS)
                          {exit(0)}
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
                  // SizedBox(height: height * 0.5, child: Lottie.asset('assets/lottie/elephant.json')),
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
              top: height * 0.175,
              child: Lottie.asset(
                'assets/lottie/elephant.json',
                height: height * 0.5,
              )),
          Positioned(
            bottom: height * 0.05,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MenuItem(
                    "Učenje",
                    () => {
                          Get.to(() => ChooseCategory("learn"),
                              transition: Transition.noTransition)
                        }),
                MenuItem(
                    "Igra",
                    () => {
                          Get.to(() => ChooseCategory("quiz"),
                              transition: Transition.noTransition)
                        }),
                MenuItem(
                    "Galerija",
                    () => {
                          Get.to(() => MyTerms(true),
                              transition: Transition.noTransition)
                        }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
