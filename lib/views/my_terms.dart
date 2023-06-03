import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import '../controllers/audio_controller.dart';
import '../controllers/item_controller.dart';
import '../widgets/custom_text.dart';
import '../widgets/word_card.dart';
import 'edit.dart';

class MyTerms extends StatelessWidget {
  AudioController audioController = Get.put(AudioController());
  String localPath = Hive.box("settings").get("directory");
  ItemController? itemController;
  Box db = Hive.box("user_data");
  bool editable;

  MyTerms(this.editable) {
    if (!editable && !Hive.box('settings').get("listView") && db.isNotEmpty) {
      audioController.player.setAudioSource(AudioSource.file(
          '$localPath/userData/${db.values.elementAt(0)}.mp3'));
      audioController.player.play();
    }
  }

  @override
  Widget build(context) {
    if (!editable) itemController = Get.put(ItemController(db));
    double height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
      builder: (context, box, widget) {
        return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: editable
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: height * 0.18,
                      height: height * 0.18,
                      child: FloatingActionButton(
                        onPressed: () => {
                          itemController?.onDelete(),
                          audioController.onDelete(),
                          Get.to(() => Edit(),
                              transition: Transition.rightToLeftWithFade),
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                  )
                : null,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.25,
                        child: Center(
                            child: FittedBox(
                          child: CustomText(
                              "Moji pojmovi",
                              TextStyle(
                                  color: Colors.blue, fontSize: height * 0.1)),
                        )),
                      ),
                      db.isNotEmpty
                          ? Expanded(
                              child: (Hive.box('settings').get("listView") ||
                                      editable)
                                  ? ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        for (String entry in db.values)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: WordCard(
                                                null, null, entry, editable),
                                          )
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                            iconSize: height * 0.3,
                                            onPressed: () => {
                                                  itemController?.prevItem(),
                                                  if (audioController
                                                      .player.playing)
                                                    audioController.player
                                                        .stop(),
                                                  audioController.player
                                                      .setAudioSource(
                                                          AudioSource.file(
                                                              '$localPath/userData/${itemController!.current.value}.mp3')),
                                                  audioController.player.play(),
                                                },
                                            icon: const Icon(
                                              Icons.arrow_circle_left_outlined,
                                              color: Colors.blue,
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Obx(() => WordCard(
                                              null,
                                              null,
                                              db.get(itemController!
                                                  .current.value),
                                              editable)),
                                        ),
                                        IconButton(
                                            iconSize: height * 0.3,
                                            onPressed: () => {
                                                  itemController?.nextItem(),
                                                  if (audioController
                                                      .player.playing)
                                                    audioController.player
                                                        .stop(),
                                                  audioController.player
                                                      .setAudioSource(
                                                          AudioSource.file(
                                                              '$localPath/userData/${itemController!.current.value}.mp3')),
                                                  audioController.player.play(),
                                                },
                                            icon: const Icon(
                                              Icons.arrow_circle_right_outlined,
                                              color: Colors.blue,
                                            )),
                                      ],
                                    ))
                          : const Expanded(child: SizedBox.shrink())
                    ]),
              ],
            ));
      },
      valueListenable: Hive.box('user_data').listenable(),
    );
  }
}
