import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/fb_hlp.dart';

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

//------------------------------------------------------------------------------
// диалог выбора изображения
class ShowImgDialog extends StatelessWidget {
  final TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String s = '';
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
                labelText: 'ничего не вводите для удаления',
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
            // s для удобочитаемости
            s = txtController.text.trim();
            // если пустой ввод - вставим имя файла-'заглушки'
            if (s.isEmpty) s = 'placeholder.png';
            //if (s.isNotEmpty) {
            //вычленим расширение файла
            final String exts = s.substring(
              s.lastIndexOf('.'),
            );
            const regularExt = [
              '.JPEG',
              '.PNG',
              '.GIF',
              '.JPG',
              '.WEBP',
              '.BMP',
              '.WBMP'
            ];

            //проверка, в начале 'http', в конце одно из допустимых расширений
            // и это не "заглушка"
            if ((!regularExt.contains(exts.toUpperCase()) ||
                    s.substring(0, 4).toLowerCase() != 'http') &&
                (s != 'placeholder.png')) {
              showAlert(
                context: context,
                mytext: 'Неверный URL!\nИзображение получить невозможно.',
              );
            } else {
              //debugPrint(s);
              Navigator.pop(context, s);
              //Navigator.of(context).pop(s);
            }
            //}
          },
        ),
        TextButton(
          child: const Text(
            'Отмена',
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
      ],
    );
  }
}

// =================================================================== рейтинг
class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCollectionFS(
        collection: 'users',
        order: 'score',
        desc: true,
        limit: 10,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 40,
            ),
          );
        }
        if (snapshot.hasData) {
          return ListViewBuilder(maplist: snapshot.data!);
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return const SizedBox();
      },
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key, required this.maplist}) : super(key: key);
  final List<Object?> maplist;
  @override
  Widget build(BuildContext context) {
    final numItems = maplist.length;
    Map<String, dynamic> mapitem;
    //final listUserCollection = maplist as List<Map<String, dynamic>?>;
    Widget buildRow(int idx) {
      mapitem = maplist[idx]! as Map<String, dynamic>;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 28,
            child: CircleAvatar(
              maxRadius: 10,
              child: Text(
                '${idx + 1}',
                //textScaleFactor: 0.8,
              ),
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Expanded(
            child: Text(
              mapitem['username'].toString(), overflow: TextOverflow.ellipsis,
              //textScaleFactor: 0.5,
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            mapitem['score'].toString(),
            //textScaleFactor: 0.5,
          ),
          const SizedBox(
            width: 3,
          ),
        ],
      );
      /* ListTile(
        /* leading: CircleAvatar(
          maxRadius: 10,
          child: Text(
            '${idx + 1}',
            //textScaleFactor: 0.8,
          ),
        ), */
        title: Text(
          mapitem['username'].toString(),
          //textScaleFactor: 0.5,
        ),
        subtitle: Text(
          mapitem['score'].toString(),
          //textScaleFactor: 0.5,
        ),
      ); */
    }

    return ListView.builder(
      itemCount: numItems * 2,
      //padding: const EdgeInsets.all(3.0),
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return const Divider();
        final index = i ~/ 2;
        return buildRow(index);
      },
    );
  }
}






/*
Uint8List showImgDialogOLD({
  required BuildContext context,
}) {
  final TextEditingController txtController = TextEditingController();
  Uint8List? val; // = Uint8List.fromList([0]);
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
              // s для удобочитаемости
              final String s = txtController.text.trim();
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

              //проверка, есть ли в конце одно из допустимых расширений
              if (!regularExt.contains(exts.toUpperCase())) {
                showAlert(
                  context: context,
                  mytext: 'Неверный URL!\nИзображение получить невозможно.',
                );
                //    ВЫХОД!
              }

              Future.delayed(Duration.zero, () async {
                //  https://i.pinimg.com/originals/12/56/b0/1256b0c13c4d6bb9c5c471d1c04ddd24.gif
                //  https://i.pinimg.com/originals/13/84/72/1384724a21fc9943f65dedfb9619c2e9.png
                //получим изображение
                await loadImg(
                  s,
                ).then((value) {
                  val = value;
                });
              });
              Navigator.of(context).pop();
              /* Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModuleEdit(
                            collectionPath: collectionPath,
                            userid: userid,
                            mapdata: mapdata,
                            isAdd: false,
                            ), 
                          ),
                        ); */
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
  return val!;
}
 */
