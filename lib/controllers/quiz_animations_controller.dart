import 'package:get/get.dart';

class QuizAnimationsController extends GetxController {
  var first = false.obs;
  var second = false.obs;
  var third = false.obs;
  var active = true.obs;

  QuizAnimationsController();

  void setFirst(){
    first.value = true;
    update();
  }

  void setSecond(){
    second.value = true;
    update();
  }

  void setThird(){
    third.value = true;
    update();
  }

  void disableClick(){
    active.value = false;
    update();
  }

  void allowClick(){
    active.value = true;
    update();
  }

  void reset() {
    first.value = false;
    second.value = false;
    third.value = false;
    update();
  }
}
