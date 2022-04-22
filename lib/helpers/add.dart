import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
//import 'package:myapp/pages/modules.dart';

class Modules extends StatefulWidget {
  const Modules({Key? key}) : super(key: key);
  @override
  State<Modules> createState() => ModulesState();
}

class ModulesState extends State<Modules> {
  final _formKey = GlobalKey<FormState>();
  final TextStyle titleStyle = TextStyle(
    color: Colors.green[800],
    fontSize: 20.0,
    shadows: const <Shadow>[
      Shadow(
        offset: Offset(1.0, 1.0),
        blurRadius: 0.5,
      ),
    ],
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );
  final TextStyle descriptionStyle = TextStyle(
    color: Colors.brown[800],
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontFamily: 'Raleway',
  );
  final TextStyle txtStyle = TextStyle(
    color: Colors.brown[800],
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontFamily: 'Raleway',
  );
  String word = '';
  String meaning = '';
  // проверки полей ввода
  bool wordOK = false;
  bool meaningOK = false;
  TextEditingController wordController = TextEditingController();
  TextEditingController meaningController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //для исключения ошибки ResizeOverflow
      resizeToAvoidBottomInset: false,
      appBar: NewGradientAppBar(
        title: const Text('Modules'),
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreenAccent],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () => _goForward(),
          ),
        ],
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0xFF, 0xFF, 0xF5, 0x9D),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 200,
                    maxWidth: 520,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                          textAlign: TextAlign.center,
                          style: txtStyle,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: wordController,
                          decoration: const InputDecoration(
                            hintText: 'Введите термин',
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          validator: (word) {
                            wordOK = false;
                            if (word!.isEmpty) {
                              return '* Обязательно для заполнения';
                            } else {
                              wordOK = true;
                            }
                          }),
                      const SizedBox(height: 20.0),
                      TextFormField(
                          textAlign: TextAlign.center,
                          style: txtStyle,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: meaningController,
                          decoration: const InputDecoration(
                            hintText: 'Введите определение',
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          validator: (meaning) {
                            meaningOK = false;
                            if (meaning!.isEmpty) {
                              return '* Обязательно для заполнения';
                            } else {
                              wordOK = true;
                            }
                          }),
                      SizedBox(height: MediaQuery.of(context).size.height / 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveData(bool _direction) {
    if (!(meaningOK & wordOK)) {
      Fluttertoast.showToast(
        msg: "Не все данные сохранены, исправте ошибки!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        webPosition: 'center',
        webBgColor: "linear-gradient(to right, #ef0000, #af0000)",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _goForward() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          'Далее:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.green[700],
          ),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop("Save"),
            isDefaultAction: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Сохранить и выйти      ',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.widgets_outlined,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Сохранить и перейти к модулям',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ],
            ),
            onPressed: () => Navigator.of(context).pop('Modules'),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text(
            'Отмена',
            style: TextStyle(fontSize: 18, color: Colors.green),
          ),
          onPressed: () => Navigator.of(context).pop("Cancel"),
          //isDestructiveAction: true,
        ),
      ),
    ).then(
      (option) {
        if (option != null) {
          switch (option.toString()) {
            case 'Save':
              _saveData(false);
              break;
            case 'Modules':
              _saveData(true);
              break;
          }
        }
      },
    );
  }
}
