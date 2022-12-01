import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/pages/module_edit.dart';
import 'package:myapp/pages/mysignin.dart';

class LibButton extends StatefulWidget {
  const LibButton({
    Key? key,
    required this.collectionPath,
    //required this.userid,
    required this.usermapdata,
  }) : super(key: key);
  final String collectionPath;
  //final String userid;
  final Map<String, dynamic> usermapdata;

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
              'imgs': ['placeholder.png'],
              'keys': [widget.usermapdata['userid'], ''],
            };

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleEdit(
                  collectionPath: widget.collectionPath,
                  //userid: widget.userid,
                  usermapdata: widget.usermapdata,
                  mapdata: cleanModule,
                  isAdd: true,
                  //imgsData: List.empty(), //  Uint8List.fromList([0]),
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
