import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/views/home.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  await Hive.initFlutter();
  Box settings = await Hive.openBox("settings");
  if (settings.length == 0) {
    await settings.put("highContrast", false);
    await settings.put("caps", false);
    await settings.put("listView", false);
    final directory = await getApplicationDocumentsDirectory();
    String localPath = directory.path;
    await settings.put("directory", localPath);
    await settings.put("showGuide", true);
  }

  final manifestJson = await rootBundle.loadString('AssetManifest.json');

  for (int i = 1; i < 4; i++) {
    Box syllablesBox = await Hive.openBox("syllables_$i");
    Box wordsBox = await Hive.openBox("words_$i");
    if (syllablesBox.isEmpty) {
      final entry = json
          .decode(manifestJson)
          .keys
          .where((String key) => key.startsWith('assets/syllables/level$i'));
      for (var syllable in entry) {
        await syllablesBox.put(
            syllable.toString().substring(
                syllable.toString().lastIndexOf("/") + 1,
                syllable.toString().indexOf(".")),
            syllable.toString());
      }
    }
    if (wordsBox.isEmpty) {
      final entry = json
          .decode(manifestJson)
          .keys
          .where((String key) => key.startsWith('assets/words/level$i'));
      for (var term in entry) {
        await wordsBox.put(
            term.toString().substring(term.toString().lastIndexOf("/") + 1,
                term.toString().indexOf(".")),
            term.toString());
      }
    }
  }

  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.addPostFrameCallback((_) async {
    BuildContext context = binding.renderViewElement as BuildContext;
    if(context != null)
    {
      for (int i = 1; i < 4; i++) {
        for (var key in Hive.box("words_$i").keys) {
          await precacheImage(AssetImage('assets/words/level$i/$key.png'), context);
        }
      }
    }
  });

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  Box userData = await Hive.openBox("user_data");

  runApp(GetMaterialApp(
    routes: {
      '/Home': (context) => Home(),
    },
    initialRoute: "/Home",
    title: "Slogalo",
    home: Home(),
    theme: ThemeData(
        fontFamily: 'Andika',
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (settings.get("highContrast")) {
            return Colors.yellow;
          }
          return Colors.blue;
        })))),
    debugShowCheckedModeBanner: false,
  ));
}
