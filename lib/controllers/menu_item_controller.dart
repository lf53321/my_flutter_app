import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MenuItemController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
