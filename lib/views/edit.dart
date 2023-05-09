import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/audio_controller.dart';
import '../widgets/custom_text.dart';
import 'my_terms.dart';

class ImageController extends GetxController {
  var hasData = false.obs;
  File? imageFile;
  placeImage(File? imageFile) {
    this.imageFile = imageFile;
    if (imageFile != null) {
      hasData.value = true;
    } else {
      hasData.value = false;
    }
    update();
  }
}

class UserAudioController extends GetxController {
  AudioController c = Get.put(AudioController());
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  var isRecording = false.obs;
  var hasData = false.obs;
  File? audioFile;

  UserAudioController() {
    recorder.openRecorder();
  }

  Future start() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }
    await recorder.startRecorder(toFile: 'audio');
    isRecording.value = true;
    update();
  }

  Future stop() async {
    var path = await recorder.stopRecorder();
    audioFile = File(path!);
    hasData.value = true;
    isRecording.value = false;
    update();
  }

  void play() {
    if (audioFile != null) {
      c.player.setAudioSource(AudioSource.file(audioFile!.path));
      c.player.play();
    }
  }

  void setFile(File audioFile) {
    this.audioFile = audioFile;
    hasData.value = true;
    update();
  }

  @override
  InternalFinalCallback<void> get onDelete {
    recorder.closeRecorder();
    isRecording.value = false;
    hasData.value = false;
    return super.onDelete;
  }

  void clear() {
    audioFile = null;
    hasData.value = false;
  }
}

class Edit extends StatelessWidget {
  ImageController imageController = Get.put(ImageController());
  UserAudioController audioController = Get.put(UserAudioController());
  // final controllerTerm = TextEditingController();
  final controllerSyllables = TextEditingController();
  String localPath = Hive.box("settings").get("directory");
  String? oldData;

  Edit();

  Edit.old(this.oldData) {
    imageController.placeImage(File('$localPath/userData/$oldData.png'));
    audioController.setFile(File('$localPath/userData/$oldData.mp3'));
    controllerSyllables.text = oldData!;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Box userData = Hive.box("user_data");
    return Scaffold(
        body: Row(
      children: [
        GetBuilder<ImageController>(builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              width: width * 0.65,
              alignment: Alignment.center,
              child: imageController.imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: CustomText("Slika iz galerije", null),
                        ),
                        Container(
                          height: 40.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _getFromCamera();
                          },
                          child: CustomText("Slika iz kamere", null),
                        )
                      ],
                    )
                  : Stack(fit: StackFit.expand, children: [
                      Image.file(
                        imageController.imageFile!,
                        fit: BoxFit.fitHeight,
                      ),
                      Positioned(
                          top: 20,
                          right: 20,
                          child: IconButton(
                              iconSize: height * 0.1,
                              onPressed: () =>
                                  {imageController.placeImage(null)},
                              icon: const Icon(
                                Icons.restart_alt,
                                color: Colors.blue,
                              ))),
                    ]),
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: width * 0.3,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TextField(
                  //     controller: controllerTerm,
                  //     decoration: const InputDecoration(
                  //       border: OutlineInputBorder(),
                  //       labelText: 'Pojam',
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controllerSyllables,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Po-jam',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            iconSize: height * 0.15,
                            onPressed: () async {
                              if (!audioController.recorder.isRecording) {
                                await audioController.start();
                              } else {
                                await audioController.stop();
                              }
                            },
                            icon: Obx(() => Icon(
                                  !audioController.isRecording.value
                                      ? Icons.mic
                                      : Icons.stop,
                                  color: Colors.blue,
                                ))),
                        Obx(() => IconButton(
                            iconSize: height * 0.15,
                            icon: Icon(
                              Icons.play_arrow,
                              color: audioController.hasData.value
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: !audioController.hasData.value
                                ? null
                                : () => audioController.play())),
                        Obx(() => IconButton(
                            iconSize: height * 0.15,
                            onPressed: !audioController.hasData.value
                                ? null
                                : () => audioController.clear(),
                            icon: Icon(
                              Icons.restart_alt,
                              color: audioController.hasData.value
                                  ? Colors.blue
                                  : Colors.grey,
                            ))),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => IconButton(
                          iconSize: height * 0.2,
                          onPressed: audioController.hasData.value &&
                                  imageController.imageFile != null &&
                                  !audioController.isRecording.value &&
                                  controllerSyllables.text != ""
                              ? () async => {
                                    await saveTerm(
                                        imageController.imageFile,
                                        audioController.audioFile,
                                        controllerSyllables.text),
                                    if (oldData != null &&
                                        oldData?.replaceAll("-", "") !=
                                            controllerSyllables.text
                                                .replaceAll("-", ""))
                                      {
                                        await File(
                                                '$localPath/userData/$oldData.mp3')
                                            .delete(),
                                        await File(
                                                '$localPath/userData/$oldData.png')
                                            .delete(),
                                        await userData.delete(oldData?.replaceAll("-", ""))
                                      },
                                    if(!userData.containsKey(controllerSyllables.text
                                        .replaceAll("-", ""))) {
                                      userData.put(
                                          controllerSyllables.text
                                              .replaceAll("-", ""),
                                          controllerSyllables.text),
                                    },
                                    Get.offUntil(
                                        PageRouteBuilder(
                                            transitionDuration: 1.seconds,
                                            pageBuilder: (context, _, __) =>
                                                MyTerms(true)),
                                        (route) => route.settings.name == '/')
                                  }
                              : null,
                          icon: Icon(
                            Icons.check,
                            color: audioController.hasData.value &&
                                    imageController.hasData.value &&
                                    !audioController.isRecording.value &&
                                    controllerSyllables.text != ""
                                ? Colors.blue
                                : Colors.grey,
                          ))),
                      IconButton(
                          iconSize: height * 0.2,
                          onPressed: () => {Get.back()},
                          icon: const Icon(
                            Icons.close,
                            color: Colors.blue,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  /// Get from gallery
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageController.placeImage(File(pickedFile.path));
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageController.placeImage(File(pickedFile.path));
    }
  }

  saveTerm(File? imageFile, File? audioFile, String name) async {
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    File file = File('$localPath/userData/$name.png');
    if(!await file.exists()) {
      await file.create(recursive: true);
    }
    if(imageFile?.path != file.path) {
      await imageFile?.copy(file.path);
    }
    file = File('$localPath/userData/$name.mp3');
    if(!await file.exists()) {
      await file.create(recursive: true);
    }
    if (audioFile?.path != file.path) {
      await audioFile?.copy(file.path);
    }
  }
}
