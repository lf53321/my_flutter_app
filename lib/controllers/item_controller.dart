import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ItemController extends GetxController {
  RxInt index = 0.obs;
  RxString current = "".obs;
  List<String> all = [];
  Box db;

  ItemController(this.db) {
    all.addAll(db.keys.map((e) => e.toString()).toList());
    if (all.isNotEmpty) {
      current = all.first.obs;
    }
  }

  void prevItem() {
    if (index.value == 0) {
      index.value = all.length - 1;
    } else {
      index.value--;
    }
    getItem(index.value);
    update();
  }

  void nextItem() {
    if (index.value == all.length - 1) {
      index.value = 0;
    } else {
      index.value++;
    }
    getItem(index.value);
    update();
  }

  void getItem(int index) {
    current.value = all.elementAt(index);
  }
}
