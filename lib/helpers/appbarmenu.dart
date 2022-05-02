import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';

import '../pages/module_edit.dart';

class LibButton extends StatefulWidget {
  LibButton({Key? key}) : super(key: key);

  @override
  State<LibButton> createState() => _LibButtonState();
}

class _LibButtonState extends State<LibButton> {
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: [
        ElevatedButton(
          child: Text("Библиотека модулей"),
          style: menuButtonStyle,
          onPressed: () {},
        ),
        SizedBox(
          width: 20,
        ),
        ElevatedButton(
          child: Text("Создать"),
          style: menuButtonStyle,
          onPressed: () {
            /* Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleEdit(),
              ),
            ); */
          },
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

class MyMenu extends StatefulWidget {
  MyMenu({Key? key}) : super(key: key);

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
          var _selection = result;
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
}

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