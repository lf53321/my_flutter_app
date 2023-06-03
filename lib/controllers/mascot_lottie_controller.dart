import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MascotLottieController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(
      vsync: this,
    );

    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(seconds: 5));
        controller.reverse();
        await Future.delayed(const Duration(seconds: 5));
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
