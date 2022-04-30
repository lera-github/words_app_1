import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';

class ModuleAddText extends StatelessWidget {
  ModuleAddText({Key? key}) : super(key: key);

  bool moduleNameOK = false;
  TextEditingController moduleNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /* const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ), */
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: /* TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Название',
            ),
          ), */

              TextFormField(
            textAlign: TextAlign.left,
            style: textStyle,
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.onUserInteraction, //always
            controller: moduleNameController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Название',
              hintText: 'Введите название модуля',
              hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            validator: (moduleNameValidator) {
              moduleNameOK = false;
              if (moduleNameValidator!.isEmpty) {
                return '* Обязательно для заполнения';
              } else {
                moduleNameOK = true;
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Описание',
            ),
          ),
        ),
      ],
    );
  }
}
