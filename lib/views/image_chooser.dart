import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'edit.dart';

class ImageChooser extends StatelessWidget {
  ImageController imageController = Get.find();
  Map<int, List<String>> names = {};

  ImageChooser(){
    Box db;
    for(int i = 1; i <= 3; i++) {
      db = Hive.box("words_$i");
      names[i] = (db.keys.map((e) => e.toString()).toList());
    }
  }
  
  @override
  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
          children: [
            Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                    iconSize: height * 0.1,
                    onPressed: () => {Get.back()},
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.blue,
                    ))),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.5,
                    child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for(int i = 1; i <= 3; i++)
                            for (String entry in names[i]!)
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8),
                                  child: SizedBox(
                                    child: ElevatedButton(
                                      child: SizedBox(
                                        child: Image.asset('assets/words/level$i/$entry.png',
                                            fit: BoxFit.fitHeight),
                                      ),
                                      onPressed: () => {
                                        imageController.placeImage(File('assets/words/level$i/$entry.png')),
                                        Get.back()
                                      }
                                    ),
                                  )),
                          ],
                        ),
                  ),
                ],
              ),
        ]));
  }
}