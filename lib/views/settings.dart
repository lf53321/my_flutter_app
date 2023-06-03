import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.contrast,
                            color: Colors.blue,
                            size: height * 0.05,
                          ),
                        ],
                      ),
                      title: CustomText("Kontrast", TextStyle(fontSize: height * 0.06)),
                      subtitle: box.get("highContrast")
                          ? CustomText("Povećani kontrast", TextStyle(fontSize: height * 0.04))
                          : CustomText("Normalni kontrast", TextStyle(fontSize: height * 0.04)),
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
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.font_download,
                            color: Colors.blue,
                            size: height * 0.05,
                          ),
                        ],
                      ),
                      title: CustomText("Veličina slova", TextStyle(fontSize: height * 0.06)),
                      subtitle: box.get("caps")
                          ? CustomText("Velika slova", TextStyle(fontSize: height * 0.04))
                          : CustomText("Mala slova", TextStyle(fontSize: height * 0.04)),
                    ),
                    value: box.get("caps"),
                    onChanged: (bool value) {
                      box.put("caps", value);
                    },
                  ),
                  SwitchListTile(
                    title: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.view_list,
                            color: Colors.blue,
                            size: height * 0.05,
                          ),
                        ],
                      ),
                      title: CustomText("Prikaz", TextStyle(fontSize: height * 0.06)),
                      subtitle: box.get("listView")
                          ? CustomText("Lista", TextStyle(fontSize: height * 0.04))
                          : CustomText("Pojedinačno", TextStyle(fontSize: height * 0.04)),
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
