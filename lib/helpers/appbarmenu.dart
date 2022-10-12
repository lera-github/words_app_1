import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/pages/module_edit.dart';
import 'package:myapp/pages/mysignin.dart';

class LibButton extends StatefulWidget {
  const LibButton({Key? key}) : super(key: key);

  @override
  State<LibButton> createState() => _LibButtonState();
}

class _LibButtonState extends State<LibButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: [
        /* ElevatedButton(
          style: menuButtonStyle,
          onPressed: () {},
          child: const Text("Библиотека модулей"),
        ),*/
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          style: menuButtonStyle,
          onPressed: () {
            //_offsetPopup();

            final cleanModule = {
              'id': '',
              'module': '',
              'description': '',
              'favourite': false,
              'words1': [''],
              'words2': [''],
            };

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleEdit(
                  mapdata: cleanModule,
                  isAdd: true,
                ),
              ),
            );
          },
          child: const Text("Создать модуль"),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
          child: const Text("Выйти"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ),
              );
            });
          },
        ),
      ],
    );
  }
}
