import '../helpers/styles.dart';
import '/helpers/fb_hlp.dart';
import 'module_edit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModuleList extends StatefulWidget {
  const ModuleList({Key? key}) : super(key: key);

  @override
  ModuleListState createState() => ModuleListState();
}

class ModuleListState extends State<ModuleList> {
  @override
  Widget build(BuildContext context) {
    final _scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;
    return FutureBuilder(
      future: getFS(collection: 'modules'),
      builder: (BuildContext context, AsyncSnapshot<List<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 40,
            ),
          );
          //CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return Scaffold(
            /* appBar: NewGradientAppBar(
              title: const Text('Учащиеся:'),
              gradient: const LinearGradient(
                colors: [Colors.indigo, Colors.cyan],
              ),
            ), */
            body: SafeArea(
                child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(width: _scrwidth),
                child:

                    //Column(children: [
                    //ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600),

                    //s child:

                    /* SizedBox(
                      width: 32,
                    ), */

                    // ),
/*                     ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Text(
                        'Библиотека модулей',
                        style: textStyle,
                      ),
                    ), */
                    /* ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child:  */
                    /*                 Column(children: [
                    Text(
                      'Библиотека модулей',
                      style: textStyle,
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    Expanded(
                      child:  */
                    CustomScrollView(
                  primary: false,
                  slivers: <Widget>[
                    SliverAppBar(
                      titleTextStyle: textStyle,
                      backgroundColor:
                          ThemeData().scaffoldBackgroundColor, //цвет фона
                      //expandedHeight: 36,
                      //collapsedHeight: 36,
                      toolbarHeight: 36,
                      centerTitle: true,
                      pinned: true,
                      title: Text(
                        'Библиотека модулей',
                        style: textStyle,
                      ),
                      /*           flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        //titlePadding: EdgeInsets.only(top: 0),
                        title: Text(
                          'Библиотека модулей',
                          style: textStyle,
                        ),
                      ), */
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 16,
                              left: 14,
                              right: 14,
                            ),
                            child: SizedBox(
                              height: 48,
                              child: gridcont(
                                context,
                                index,
                                snapshot.data![index],
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                    ),
                  ],
                ),
                //   ),
                //  ])
              ),
            )),
          );
        }

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return const SizedBox();
      },
    );
  }

  Widget gridcont(BuildContext context, int index, Object? _obj) {
    final _aaa = _obj! as Map<String, dynamic>;
    final _txt = '${_aaa['module']}';
    var _favourite = false;
    if (_aaa['favourite'] != null) {
      _favourite = _aaa['favourite'] as bool;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 800),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.lime.shade50, Colors.lime.shade100],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 3.0,
                spreadRadius: 3.0,
                offset: Offset(3, 3),
              )
            ],
          ),
          //содержимое каждой плашки
          child: Row(
            children: [
              SizedBox(
                width: 6,
              ),
              //звезды
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 1.4,
                    child: IconButton(
                      icon: Icon(
                        _favourite
                            ? Icons.star_rate_rounded
                            : Icons.star_border_rounded,
                        color: _favourite
                            ? Colors.yellow.shade600
                            : Colors.grey.shade400,
                      ),
                      // избранное
                      onPressed: () {
                        Future.delayed(Duration.zero, () async {
                          _favourite = !_favourite;
                          await updateFS(
                            collection: 'modules',
                            id: '${_aaa['id']}',
                            val: 'favourite',
                            valdata: _favourite,
                          ).then((value) => setState(() {}));
                        });

                        /* Future.delayed(
                        Duration.zero,
                        () async {
                          //диалог подтверждения удаления
                          await delModuleDialog(context).then((value) async {
                            if (value) {
                              //удаление и обновление страницы
                              await delModule(_aaa).then(
                                (value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ModuleList(),
                                  ),
                                ),
                              );
                            }
                          });
                        },
                      ); */
                      },
                    ),
                  ),
                ],
              ),
              //текст
              Expanded(
                child: InkWell(
                  onTap: () => _gotonext(
                    context,
                    _aaa,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: AutoSizeText(
                        _txt,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              //удалить

              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}

//переход на редактирование модуля
void _gotonext(BuildContext context, Map<String, dynamic> _mapdata) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleEdit(
        mapdata: _mapdata,
        isAdd: false,
      ),
    ),
  );
}

//удаление модуля
Future<bool> delModuleDialog(
  BuildContext context,
) async {
  bool excode = false;
  await CupertinoContextMenu(
    actions: <Widget>[
      CupertinoContextMenuAction(
        child: const Text('Action one'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      CupertinoContextMenuAction(
        child: const Text('Action two'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ],
    child: Container(
      color: Colors.red,
    ),
  );

  /* showCupertinoModalPopup(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(
        'Подтвердите:',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          color: Colors.cyanAccent[700],
        ),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop('Dele'),
          isDefaultAction: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.delete_forever_outlined,
                color: Colors.blueGrey,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Удалить ответы учащегося?',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text(
          'Отмена',
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
        onPressed: () => Navigator.of(context).pop('Cancel'),
        //isDestructiveAction: true,
      ),
    ),
  ) .then(
    (option) {
      if (option != null) {
        if (option.toString() == 'Dele') {
          excode = true;
        }
      }
    },
  ); */
  return excode;
}

Future<void> delModule(
  Map<String, dynamic> _aaa,
) async {
  final List<Object?> _obj = await getUsersVarsFS(_aaa);
  final fbs.ListResult result =
      await fbs.FirebaseStorage.instance.ref().listAll();
  for (int i = 0; i < _obj.length; i++) {
    final _datalist = _obj[i]! as Map<String, dynamic>;
    //debugPrint(_data['var'].toString());
    //debugPrint(_obj.length.toString());
    final List<String> _datakey = _datalist.keys.toList();
    for (int j = 0; j < _datakey.length; j++) {
      if ((_datakey[j].contains('audio')) & (_datalist[_datakey[j]] != '')) {
        //debugPrint(_datalist[_datakey[j]].toString());
        for (final ref in result.items) {
          if (ref.name == _datalist[_datakey[j]] as String) {
            //debugPrint(ref.name);
            //удаление файлов
            await ref.delete();
          }
        }
      }
    }
    //здесь удалить doc в коллекции users
    await deleteUser(_aaa);
  }
  /* final fbs.ListResult result = await fbs.FirebaseStorage.instance.ref().listAll();
  //await fbs.FirebaseStorage.instance.ref().list(const fbs.ListOptions(maxResults: 10, ));
  for (final ref in result.items) {
    //debugPrint('Found file: ${ref.name}');
    //ref.delete(); ///////////////////////////////////////////////////////////////////////////////////////
  } */
  /* result = await fbs.FirebaseStorage.instance.ref().listAll();
  for (final ref in result.prefixes) {
    debugPrint('Found directory: ${ref.name}');
    debugPrint(result.prefixes.length.toString());
  } */
}
