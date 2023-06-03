import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

import '../controllers/audio_controller.dart';
import '../views/edit.dart';
import 'custom_text.dart';

class WordCard extends StatelessWidget {
  AudioController c = Get.find();
  String localPath = Hive.box("settings").get("directory");
  Box userData = Hive.box("user_data");
  String? category;
  String? level;
  String entry;
  bool editable;

  WordCard(this.category, this.level, this.entry, this.editable);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Stack(children: [
        SizedBox(
          width: height * 0.75,
          child: FittedBox(
            fit: BoxFit.fill,
            child: ElevatedButton(
                onPressed: () async => {
                      if (category != null)
                        {
                          await c.player.setAudioSource(
                              ConcatenatingAudioSource(children: [
                            for (String syllable in entry.split("-"))
                              AudioSource.asset(
                                  'assets/syllables/level$level/$syllable.m4a'),
                            AudioSource.asset(
                                'assets/$category/level$level/$entry.m4a')
                          ])),
                        }
                      else
                        {
                          await c.player.setAudioSource(AudioSource.file(
                              '$localPath/userData/$entry.mp3'))
                        },
                      c.player.play(),
                    },
                child: Column(
                  children: [
                    SizedBox(
                        height: height * 0.3,
                        child: FittedBox(
                            child: CustomText(
                                entry, TextStyle(fontSize: height * 0.3)))),
                    category != null
                        ? Image.asset('assets/$category/level$level/$entry.png',
                            fit: BoxFit.contain)
                        : SizedBox(
                            height: height,
                            width: width * 0.5,
                            child: Image.memory(
                                File('$localPath/userData/$entry.png').readAsBytesSync(),
                                fit: BoxFit.contain),
                          ),
                    SizedBox(
                        height: height * 0.3,
                        child: FittedBox(
                            child: CustomText(entry.replaceAll("-", ""),
                                TextStyle(fontSize: height * 0.3)))),
                  ],
                )),
          ),
        ),
        editable
            ? Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    iconSize: height * 0.1,
                    onPressed: () async => {
                          await File('$localPath/userData/$entry.png').delete(),
                          await File('$localPath/userData/$entry.mp3').delete(),
                          await userData.delete(entry.replaceAll("-", ""))
                        },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black54,
                    )))
            : const SizedBox.shrink(),
        editable
            ? Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                    iconSize: height * 0.1,
                    onPressed: () => {Get.to(() => Edit.old(entry))},
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black54,
                    )))
            : const SizedBox.shrink(),
      ]),
    );
  }
}
