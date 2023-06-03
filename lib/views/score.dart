import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/views/my_terms.dart';
import '../controllers/mascot_lottie_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/menu_item.dart';
import 'choose_category.dart';
import 'home.dart';
import 'learn.dart';

class Score extends StatelessWidget {
  final mascotController = Get.put(MascotLottieController());
  String? category;
  String? level;

  Score(this.category, this.level);

  Score.user();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
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
                  child: CustomText("Bravo! Odaberi što dalje",
                      TextStyle(color: Colors.blue, fontSize: height * 0.1)),
                ),
              ],
            ),
          ),
        SizedBox(
          height: height * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MenuItem(
                  "Nova igra",
                  () => {
                        Get.offUntil(
                            GetPageRoute(
                                page: () => ChooseCategory("quiz"),
                                transition: Transition.noTransition),
                            (route) => route.settings.name == "/Home"),
                      }),
              MenuItem(
                  "Ponovi gradivo",
                  () async => {
                        await Get.offUntil(
                            GetPageRoute(
                                page: () => category != null ? Learn(category!, level!) : MyTerms(false),
                                transition: Transition.noTransition),
                            (route) => route.settings.name == '/Home'),
                      }),
              MenuItem(
                  "Povratak",
                  () => {
                        Get.offAll(() => Home(),
                            transition: Transition.noTransition)
                      }),
            ],
          ),
        )
      ],
    ));
  }
}
