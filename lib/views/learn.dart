import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_flutter_app/widgets/custom_text.dart';
import 'package:my_flutter_app/controllers/item_controller.dart';
import '../controllers/audio_controller.dart';
import '../widgets/word_card.dart';

class Learn extends StatelessWidget {
  AudioController audioController = Get.put(AudioController());
  ItemController? itemController;
  String category;
  String level;
  Box? db;

  Learn(this.category, this.level) {
    db = Hive.box("${category}_$level");
  }

  @override
  Widget build(context) {
    itemController = Get.put(ItemController(db!));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: height * 0.25,
              child: Center(
                  child: FittedBox(
                child: CustomText(
                    "${category == "syllables" ? "Slogovi " : "Riječi "}$level",
                    TextStyle(color: Colors.blue, fontSize: height * 0.1)),
              )),
            ),
            (db != null && db!.isNotEmpty)
                ? Expanded(
                    child: Hive.box('settings').get("listView")
                        ? ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (String entry in db!.keys)
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: category != "syllables"
                                        ? WordCard(
                                            category, level, entry, false)
                                        : _SyllableCard(category, level, entry))
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  iconSize: height * 0.3,
                                  onPressed: () => {
                                        itemController?.prevItem(),
                                        if (audioController.player.playing)
                                          audioController.player.stop(),
                                      },
                                  icon: const Icon(
                                    Icons.arrow_circle_left_outlined,
                                    color: Colors.blue,
                                  )),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: category != "syllables" &&
                                          itemController!
                                              .current.value.isNotEmpty
                                      ? Obx(() => WordCard(category, level,
                                          itemController!.current.value, false))
                                      : Obx(() => _SyllableCard(category, level,
                                          itemController!.current.value))),
                              IconButton(
                                  iconSize: height * 0.3,
                                  onPressed: () => {
                                        itemController?.nextItem(),
                                        if (audioController.player.playing)
                                          audioController.player.stop()
                                      },
                                  icon: const Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.blue,
                                  )),
                            ],
                          ),
                  )
                : const Expanded(child: SizedBox.shrink())
          ],
        ),
      ],
    ));
  }
}

class _SyllableCard extends StatelessWidget {
  AudioController c = Get.find();
  String category;
  String level;
  String entry;

  _SyllableCard(this.category, this.level, this.entry);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: height * 0.5,
        child: ElevatedButton(
            onPressed: () => {
                  c.player.setAudioSource(AudioSource.asset(
                      'assets/$category/level$level/$entry.m4a')),
                  c.player.play(),
                },
            child: FittedBox(
                child: Center(
                    child: CustomText(
                        entry, TextStyle(fontSize: height * 0.25))))),
      ),
    );
  }
}
