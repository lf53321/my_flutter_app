import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/controllers/audio_controller.dart';
import 'package:my_flutter_app/views/score.dart';
import '../controllers/quiz_animations_controller.dart';
import '../controllers/quiz_controller.dart';
import '../controllers/quiz_item_controller.dart';
import '../widgets/menu_item.dart';

class Quiz extends StatelessWidget {
  String localPath = Hive.box("settings").get("directory");
  QuizItemController quizItemController = Get.put(QuizItemController());
  QuizAnimationsController menuController = Get.put(QuizAnimationsController());
  String? category;
  String? level;
  Box? db;

  Quiz(this.category, this.level) {
    db = Hive.box("${category}_$level");
  }

  Quiz.userData() {
    db = Hive.box("user_data");
  }

  @override
  Widget build(context) {
    Get.delete<QuizController>();
    Get.delete<AudioController>();
    AudioController audioController = Get.put(AudioController());
    QuizController quizController = Get.put(QuizController(db!));
    category != null
        ? audioController.player.setAudioSource(AudioSource.asset(
            'assets/$category/level$level/${quizController.answer.toString()}.m4a'))
        : audioController.player.setAudioSource(AudioSource.file(
            '$localPath/userData/${quizController.answer.toString()}.mp3'));
    audioController.player.play();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleTouchRecognizerWidget(
      child: Scaffold(
        body: GetBuilder<QuizController>(builder: (_) {
          String oldAnswer = "";
          return quizController.index.value != 3
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        top: height * 0.1,
                        child: IconButton(
                            iconSize: height * 0.5,
                            onPressed: () => {
                              menuController.active.value ?
                                  {category != null
                                      ? audioController.player.setAudioSource(
                                          AudioSource.asset(
                                              'assets/$category/level$level/${quizController.answer.toString()}.m4a'))
                                      : audioController.player.setAudioSource(
                                          AudioSource.file(
                                              '$localPath/userData/${quizController.answer.toString()}.mp3')),
                                  audioController.player.play()} : null
                                },
                            icon: const Icon(
                              Icons.volume_up_rounded,
                              color: Colors.blue,
                            ))),
                    Positioned(
                      bottom: height * 0.05,
                      width: width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...(quizController.randomOptions)
                                .map((e) => Obx(() => menuController.active.value ? MenuItem(
                                    e.replaceAll("-", ""),
                                    () async => {
                                          menuController.disableClick(),
                                          audioController.player.stop(),
                                          oldAnswer =
                                              quizController.answer.toString(),
                                          await audioController.player
                                              .setAudioSource(category != null
                                                  ? AudioSource.asset(
                                                      'assets/$category/level$level/$e.m4a')
                                                  : AudioSource.file(
                                                      '$localPath/userData/$e.mp3')),
                                          await audioController.player.play(),
                                          await audioController.player.stop(),
                                          if(e == quizController.randomOptions.first) {
                                            menuController.setFirst(),
                                          } else if(e == quizController.randomOptions.last) {
                                            menuController.setThird(),
                                          } else { menuController.setSecond()
                                          },
                                          await audioController.player
                                              .setAudioSource(
                                            e ==
                                                    quizController.answer
                                                        .toString()
                                                ? AudioSource.asset(
                                                    'assets/quiz/correct.mp3')
                                                : AudioSource.asset(
                                                    'assets/quiz/wrong.mp3'),
                                          ),
                                          await audioController.player.play(),
                                          quizController.processAnswer(e).then((value) => menuController.allowClick()),
                                          if (quizController.index.value != 3 &&
                                              e == oldAnswer)
                                            {
                                              category != null
                                                  ? await audioController.player
                                                      .setAudioSource(
                                                          AudioSource.asset(
                                                              'assets/$category/level$level/${quizController.answer.toString()}.m4a'))
                                                  : await audioController.player
                                                      .setAudioSource(
                                                          AudioSource.file(
                                                              '$localPath/userData/${quizController.answer.toString()}.mp3')),
                                              await audioController.player
                                                  .play()
                                            }
                                        }) : MenuItem(e.replaceAll("-", ""), null)))
                                .toList()
                          ]),
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
                                        child: Lottie.asset(
                                            quizController.randomOptions.elementAt(0) == oldAnswer ? 'assets/lottie/success.json' : 'assets/lottie/fail.json',
                                            height: quizController.randomOptions.elementAt(0) == oldAnswer ? height * 0.2 : height * 0.15,
                                            controller:
                                                quizItemController.controller,
                                            onLoaded: (composition) {
                                          quizItemController.controller
                                              .duration = composition.duration;
                                          quizItemController.controller
                                              .forward()
                                              .then((value) => {
                                                    menuController.reset(),
                                                    quizItemController
                                                        .controller
                                                        .reset()
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
                                        child: Lottie.asset(
                                            quizController.randomOptions.elementAt(1) == oldAnswer ? 'assets/lottie/success.json' : 'assets/lottie/fail.json',
                                            height: quizController.randomOptions.elementAt(1) == oldAnswer ? height * 0.2 : height * 0.15,
                                            controller:
                                                quizItemController.controller,
                                            onLoaded: (composition) {
                                          quizItemController.controller
                                              .duration = composition.duration;
                                          quizItemController.controller
                                              .duration = composition.duration;
                                          quizItemController.controller
                                              .forward()
                                              .then((value) => {
                                                    menuController.reset(),
                                                    quizItemController
                                                        .controller
                                                        .reset()
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
                                        child: Lottie.asset(
                                            quizController.randomOptions.elementAt(2) == oldAnswer ? 'assets/lottie/success.json' : 'assets/lottie/fail.json',
                                            height: quizController.randomOptions.elementAt(2) == oldAnswer ? height * 0.2 : height * 0.15,
                                            controller:
                                                quizItemController.controller,
                                            onLoaded: (composition) {
                                          quizItemController.controller
                                              .duration = composition.duration;
                                          quizItemController.controller
                                              .duration = composition.duration;
                                          quizItemController.controller
                                              .forward()
                                              .then((value) => {
                                                    menuController.reset(),
                                                    quizItemController
                                                        .controller
                                                        .reset()
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
                          ],
                        )),
                  ],
                )
              : Score(category, level);
        }),
      ),
    );
  }
}

class _SingleTouchRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);

    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}

class SingleTouchRecognizerWidget extends StatelessWidget {
  final Widget child;
  SingleTouchRecognizerWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        _SingleTouchRecognizer:
            GestureRecognizerFactoryWithHandlers<_SingleTouchRecognizer>(
          () => _SingleTouchRecognizer(),
          (_SingleTouchRecognizer instance) {},
        ),
      },
      child: child,
    );
  }
}
