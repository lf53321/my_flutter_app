import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'custom_text.dart';

class GuideDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
          child: Stack(
            children: [
              Positioned(
                  top: 5,
                  left: 10,
                  child: IconButton(
                      iconSize: width * 0.05,
                      onPressed: () => {Get.back()},
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.blue,
                      ))),
              Column(
                children: [
                  CustomText("Dodavanje vlastitih pojmova", const TextStyle(color: Colors.blue, fontSize: 30)),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                        child: Column(
                          children: [
                            CustomText(
                                "Ovo je ekran za dodavanje vlastitih elemenata.\n"
                                    "U lijevom dijelu ekrana odaberite sliku iz jednog od mogućih izvora.\n"
                                    "Nakon odabira slike možete, ako niste zadovoljni, odabrati drugu sliku pritiskom na tipku u gornjem dijelu ekrana.\n"
                                    "Primjerice:\n",
                                const TextStyle(fontSize: 20)),
                            Image.asset(
                              'assets/examples/add_image.png',
                              fit: BoxFit.fitHeight,
                            ),
                            CustomText(
                                "U desnom dijelu ekrana nalazi se polje za unos teksta pojma rastavljenog na slogove (npr. ako je pojam \"Mama\" unesite \"Ma-ma\").\n",
                                const TextStyle(fontSize: 20)),
                            Image.asset(
                              'assets/examples/add_text.png',
                              fit: BoxFit.fitHeight,
                            ),
                            CustomText("Ispod njega nalaze se tri ikonice.\n"
                                "Prva je ikona mikrofona. Pritiskom na nju se počinje snimati audio sve do kada ponovne ne pritisnite na ikonu.\n"
                                "Pokraj nje je ikona pritiskom na koju možete preslušati snimljeni audio i ako niste zadovoljni snimljenim možete obrisati trenutni audio zapis pritiskom na treću ikonu u redu.\n"
                                "Primjer ekrana nakon dodanog audio zapisa:\n"
                                , const TextStyle(fontSize: 20)),
                            Image.asset(
                              'assets/examples/add_audio.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
