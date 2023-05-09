import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_flutter_app/widgets/custom_text.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ValueListenableBuilder(
      valueListenable: Hive.box('settings').listenable(),
      builder: (context, box, widget) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                      iconSize: height * 0.1,
                      onPressed: () => {
                        Get.back()
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.blue,
                      ))),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                        width: width * 0.8,
                        height: height * 0.2,
                        child: FittedBox(
                          child: CustomText("POSTAVKE",
                              TextStyle(color: Colors.blue, fontSize: height * 0.15)),
                        )),
                  SwitchListTile(
                    title: ListTile(
                      leading: const Icon(
                        Icons.contrast,
                        color: Colors.blue,
                      ),
                      title: CustomText("Kontrast", null),
                      subtitle: box.get("highContrast")
                          ? CustomText("Povećani kontrast", null)
                          : CustomText("Normalni kontrast", null),
                    ),
                    value: box.get("highContrast"),
                    onChanged: (bool value) {
                      box.put("highContrast", value);
                      Get.changeTheme(ThemeData(fontFamily: 'Andika', elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if (value) {
                          return Colors.yellow;
                        }
                        return Colors.blue;
                      })))));
                    },
                  ),
                  SwitchListTile(
                    title: ListTile(
                      leading: const Icon(
                        Icons.font_download,
                        color: Colors.blue,
                      ),
                      title: CustomText("Veličina slova", null),
                      subtitle: box.get("caps")
                          ? CustomText("Velika slova", null)
                          : CustomText("Mala slova", null),
                    ),
                    value: box.get("caps"),
                    onChanged: (bool value) {
                      box.put("caps", value);
                    },
                  ),
                  SwitchListTile(
                    title: ListTile(
                      leading: const Icon(
                        Icons.view_list,
                        color: Colors.blue,
                      ),
                      title: CustomText("Prikaz", null),
                      subtitle: box.get("listView")
                          ? CustomText("Lista", null)
                          : CustomText("Pojedinačno", null),
                    ),
                    value: box.get("listView"),
                    onChanged: (bool value) {
                      box.put("listView", value);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
