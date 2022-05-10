import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/pages/module_edit.dart';

class LibButton extends StatefulWidget {
  const LibButton({Key? key}) : super(key: key);

  @override
  State<LibButton> createState() => _LibButtonState();
}

Widget _offsetPopup() => PopupMenuButton<int>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 1,
          child: Text(
            "Flutter Open",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text(
            "Flutter Tutorial",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      icon: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const ShapeDecoration(
          color: Colors.blue,
          shape: StadiumBorder(
            side: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        //child: Icon(Icons.menu, color: Colors.white), <-- You can give your icon here
      ),
    );

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
            _offsetPopup();

            /* final cleanModule = {
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
            ); */
          },
          child: const Text("Создать модуль"),
        ),
      ],
    );

/*     Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.0, color: Colors.lightBlue.shade900),
        ),
      ),
      child: Text('Библиотека модулей',
          textAlign: TextAlign.center, style: menuButtonStyle),
    ); */
  }
}

/* class MyMenu extends StatefulWidget {
  const MyMenu({Key? key}) : super(key: key);

  @override
  State<MyMenu> createState() => _MyMenuState();
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class _MyMenuState extends State<MyMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<WhyFarther>(
   
      onSelected: (WhyFarther result) {
        setState(() {
          final _selection = result;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.harder,
          child: Text('Working a lot harder'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.smarter,
          child: Text('Being a lot smarter'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.selfStarter,
          child: Text('Being a self-starter'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.tradingCharter,
          child: Text('Placed in charge of trading charter'),
        ),
      ],
    );
  }
} */

/* class CreateMenu extends StatefulWidget {
  const CreateMenu({Key? key}) : super(key: key);

  @override
  State<CreateMenu> createState() => _CreateMenuState();
}

class _CreateMenuState extends State<CreateMenu> {
  String dropdownValue = 'Создать';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      //icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: TextStyle(color: menuItemsColor),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Создать', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class LibMenu extends StatefulWidget {
  const LibMenu({Key? key}) : super(key: key);

  @override
  State<LibMenu> createState() => _LibMenuState();
}

class _LibMenuState extends State<LibMenu> {
  String dropdownValue = 'Библиотека модулей';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      //icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: TextStyle(color: menuItemsColor),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Библиотека модулей', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
} */
