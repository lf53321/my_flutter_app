import 'dart:collection';
import 'dart:math';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class QuizController extends GetxController {
  int score = 0;
  RxInt index = 0.obs;
  RxString answer = "".obs;
  HashSet<String> options = HashSet<String>();
  Set<String> randomOptions = <String>{};
  late List<String> remaining;
  List<String> all = [];
  Box db;

  QuizController(this.db) {
    if(db.name == "user_data") {
      remaining = db.values.map((e) => e.toString()).toList();
    } else {
      remaining = db.keys.map((e) => e.toString()).toList();
    }
    all.addAll(remaining);
    getQuestion();
  }

  void getQuestion() {
    options.clear();
    randomOptions.clear();
    answer = remaining.elementAt(Random().nextInt(remaining.length)).obs;
    // nuditi prijasnje odgovore ili ne?
    remaining.remove(answer.value);
    options.add(answer.value);
    int count = 0;
    while (count < 2) {
      if (options.add(all.elementAt(Random().nextInt(all.length)))) {
        count++;
      }
    }
    count = 0;
    while (count < 3) {
      if (randomOptions
          .add(options.elementAt(Random().nextInt(options.length)))) {
        count++;
      }
    }
    update();
  }

  Future<void> processAnswer(String userAnswer) async {
    if (userAnswer != answer.value) return;
    if (userAnswer == answer.value) score++;
    index.value++;
    if (index.value == 3) {
      update();
      return;
    }
    getQuestion();
  }
}
