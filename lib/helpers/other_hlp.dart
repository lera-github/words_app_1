import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/fb_hlp.dart';
import 'package:myapp/helpers/img_hlp.dart';

// показ предупреждений
void showAlert({
  required BuildContext context,
  required String mytext,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      elevation: 1.2,
      backgroundColor: Colors.red.shade900,
      shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Text(
            mytext,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 18,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(
            context,
          );
        },
      ),
    ),
  );
}

class TTip extends StatelessWidget {
  const TTip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);
  final Widget child;
  final String message;
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      waitDuration: const Duration(seconds: 1),
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}

// диалог выбора изображения
void showImgDialog({
  required BuildContext context,
}) {
  final TextEditingController txtController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 24,
        title: const Text('Введите URL адрес изображения'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: txtController,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black.withOpacity(0.9)),
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.image_search_outlined,
                    color: Colors.blue,
                  ),
                  labelText: 'URL изображения',
                  labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.url,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Сохранить',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Uint8List? val;
              // s для удобочитаемости
              final String s = txtController.text.trim();
              Future.delayed(
                Duration.zero,
                () async {
                  /// введён URL?
                  if (s.isNotEmpty) {
                    //получим изображение
                    await loadImg(
                      s,
                      //'https://i.pinimg.com/originals/12/56/b0/1256b0c13c4d6bb9c5c471d1c04ddd24.gif',
                      //https://i.pinimg.com/originals/13/84/72/1384724a21fc9943f65dedfb9619c2e9.png
                    ).then((value) {
                      val = value;
                    });

                    //вычленим расширение файла
                    final String exts = s.substring(
                      s.lastIndexOf('.'),
                    );
                    const regularExt = [
                      '.JPEG',
                      '.PNG',
                      '.GIF',
                      '.JPG',
                      '.WebP',
                      '.BMP',
                      '.WBMP'
                    ];
                    debugPrint(exts);
                    //проверка, есть ли в конце одно из допустимых расширений
                    if (regularExt.contains(exts.toUpperCase())) {
                      //генератор имени файла
                      final generatedfilename = md5
                          .convert(
                            utf8.encode(
                              DateTime.now().millisecondsSinceEpoch.toString(),
                            ),
                          )
                          .toString();
                      //запишем в FBS
                      await toFBS(generatedfilename, val!);
                      //debugPrint(val!.toString());
                      //debugPrint(txtController.text.trim());
                    } else {
                      showAlert(
                          context: context,
                          mytext:
                              'Неверный URL!\nИзображение получить невозможно.',);
                    }
                  } else {
                    //если не введен URL
                    //удалить файл из FBS, если он там есть
                    showAlert(context: context, mytext: 'Изображение удалено!');
                    //УДАЛИТЬ ИЗ FBS
                    ///
                    ///
                  }
                },
              );
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'Отмена',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
