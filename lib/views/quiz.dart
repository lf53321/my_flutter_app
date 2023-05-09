import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_flutter_app/controllers/audio_controller.dart';
import 'package:my_flutter_app/views/score.dart';
import '../controllers/quiz_controller.dart';
import '../widgets/menu_item.dart';

class Quiz extends StatelessWidget {
  String category;
  String level;
  Box? db;

  Quiz(this.category, this.level) {
    db = Hive.box("${category}_$level");
  }

  @override
  Widget build(context) {
    Get.delete<QuizController>();
    Get.delete<AudioController>();
    AudioController audioController = Get.put(AudioController());
    QuizController quizController = Get.put(QuizController(db!));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleTouchRecognizerWidget(
      child: Scaffold(
        body: GetBuilder<QuizController>(builder: (_) {
          return quizController.index.value != 3
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        top: height * 0.1,
                        child: IconButton(
                            iconSize: height * 0.5,
                            onPressed: () => {
                                  audioController.player.setAudioSource(
                                      AudioSource.asset(
                                          'assets/$category/level$level/${quizController.answer.toString()}.m4a')),
                                  audioController.player.play()
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
                                .map((e) => MenuItem(
                                    e.replaceAll("-", ""),
                                    () => {
                                          audioController.player.stop(),
                                          Timer(
                                              const Duration(milliseconds: 500),
                                              () {
                                            quizController.processAnswer(e);
                                          }),
                                        }))
                                .toList()
                          ]),
                    ),
                  ],
                )
              : Score(category, level, quizController.score);
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
      Timer(const Duration(milliseconds: 500), () {
        _p = 0;
      });
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
