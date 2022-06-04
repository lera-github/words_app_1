import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:myapp/helpers/sp_hlp.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
//import 'package:myapp/pages/modules.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
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
  String myfio = '';
  String mymail = '';
  String password = '';
  // проверки полей ввода
  bool myfioOK = false;
  bool mymailOK = false;
  bool passwordOK = false;
  TextEditingController myfioController = TextEditingController();
  TextEditingController mymailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void get obscureText => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //для исключения ошибки ResizeOverflow
      resizeToAvoidBottomInset: false,
      appBar: NewGradientAppBar(
        title: const Text('Profile'),
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
                      Text(
                        'Имя пользователя:',
                        style: titleStyle,
                      ),
                      TextFormField(
                          textAlign: TextAlign.center,
                          style: txtStyle,
                          keyboardType: TextInputType.name,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: myfioController,
                          decoration: const InputDecoration(
                            hintText: 'Введите свое Имя',
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          validator: (myfio) {
                            myfioOK = false;
                            if (myfio!.isEmpty) {
                              return '* Обязательно для заполнения';
                            } else {
                              if (myfio.length < 3) {
                                return '* Не может быть менее трех символов';
                                //  } else {
                                //   if (myfio.trim().contains(' ') == false) {
                                //   return '* Разделите слова пробелами';
                              } else {
                                myfioOK = true;
                              }
                            }
                            return null;
                          }
                          //},
                          ,),
                      const SizedBox(height: 20.0),
                      Text(
                        'E-mail:',
                        style: titleStyle,
                      ),
                      TextFormField(
                        textAlign: TextAlign.center,
                        style: txtStyle,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: mymailController,
                        decoration: const InputDecoration(
                          hintText: 'Введите свой e-mail',
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        validator: (value) {
                          mymailOK = false;
                          if (value!.isEmpty) {
                            return '* Обязательно для заполнения';
                          }
                          const String regExpMailStr =
                              '[a-zA-Z0-9+._%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+';
                          final RegExp regExpMail = RegExp(regExpMailStr);
                          if (regExpMail.hasMatch(value)) {
                            mymailOK = true;
                            return null;
                          }
                          return '* E-mail введен не корректно';
                        },
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Пароль:',
                        style: titleStyle,
                      ),
                      TextFormField(
                        textAlign: TextAlign.center,
                        style: txtStyle,
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Введите пароль',
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        validator: (password) {
                          passwordOK = false;
                          if (password!.isEmpty) {
                            return '* Обязательно для заполнения';
                          } else {
                            if (password.length < 3) {
                              return '* Не может быть менее трех символов';
                            } else {
                              passwordOK = true;
                            }
                          }
                          return null;
                        },
                      ),
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
    if (!(myfioOK & mymailOK & passwordOK)) {
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
