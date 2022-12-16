import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/helpers/fb_hlp.dart';
import 'package:myapp/helpers/other_hlp.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/actions_games.dart';
import 'package:myapp/pages/module_edit.dart';

class ModuleList extends ConsumerStatefulWidget {
  const ModuleList({
    Key? key,
    required this.collectionPath,
    //required this.userid,
    required this.usermapdata,
  }) : super(key: key);
  final String collectionPath;
  //final String userid;
  final Map<String, dynamic> usermapdata;

  @override
  ModuleListState createState() => ModuleListState();
}

class ModuleListState extends ConsumerState<ModuleList> {
  @override
  Widget build(BuildContext context) {
    final scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;
    final scrheight = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: getFS(
        collection: widget.collectionPath,
        order: 'module',
        userid: widget.usermapdata['userid'] as String,
      ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 68,
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: const [
                                    SizedBox(
                                      height: 6,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ' 10 лучших:\n',
                                      style: text14Style,
                                    ),
                                  ],
                                ),
                                ////////                                       //  лист рейтинга
                                SizedBox(
                                  height: scrheight - 323 > 40
                                      ? scrheight - 323
                                      : 40,
                                  child: /* Container(
                              padding: const EdgeInsets.all(6),
                              child:  */
                                      const Rating(),
                                  //),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(
                        width: scrwidth,
                        height: scrheight,
                      ),
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
                                    height: 52,
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
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return const SizedBox();
      },
    );
  }

  Widget gridcont(BuildContext context, int index, Object? obj) {
    final moduleCollection = obj! as Map<String, dynamic>;
    final moduleName = '${moduleCollection['module']}';
    final moduleDescription = '${moduleCollection['description']}';
    /* var favourite = false;
    if (moduleCollection['favourite'] != null) {
      favourite = moduleCollection['favourite'] as bool;
    } */
    //bool favourite = moduleCollection['favourite'] as bool;

    //значения массива keys - id польз-ля и признак общего доступа
    final List shared = moduleCollection['keys'] as List;
    //признак общего доступа
    String sharedfl = '';
    if (shared[1] == '#') {
      sharedfl = '#';
    }
    //цвет папочки (значок общего доступа)
    Color sharedColor =
        (sharedfl == '#') ? Colors.blue.shade600 : Colors.grey.shade400;
    //если модуль не текущего польз-ля
    if (shared[0] != widget.usermapdata['userid'] as String) {
      sharedColor = Colors.blue.shade600;
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
              const SizedBox(
                width: 6,
              ),
              //общий доступ
              TTip(
                message: (sharedfl == '#')
                    ? 'Модуль доступен всем'
                    : 'Модуль доступен только вам',
                //'Общий доступ',
                child: IconButton(
                  icon: Transform.scale(
                    scale: 1.4,
                    child: Icon(
                      (sharedfl == '#')
                          ? Icons.folder_shared //star_rate_rounded
                          : Icons.folder_shared_outlined, //star_border_rounded,
                      color: sharedColor
                      /* (sharedfl == '#')
                          ? Colors.yellow.shade600
                          : Colors.grey.shade400, */
                      ,
                    ),
                  ),
                  // избранное
                  onPressed: () {
                    Future.delayed(Duration.zero, () async {
                      if (sharedfl == '#') {
                        sharedfl = '';
                      } else {
                        sharedfl = '#';
                      }
                      if (shared[0] == widget.usermapdata['userid'] as String) {
                        await updatesharedFS(
                          collection: widget.collectionPath,
                          id: '${moduleCollection['id']}',
                          val: 'keys',
                          valdata: sharedfl,
                        ).then((value) => setState(() {}));
                      } else {
                        showAlert(
                          context: context,
                          mytext:
                              'Вы не можете изменить\nмодуль другого пользователя',
                        );
                      }
                    });
                  },
                ),
              ),

              /* Future.delayed(
                        Duration.zero,
                        () async {
                          //диалог подтверждения удаления
                          await delModuleDialog(context).then((value) async {
                            if (value) {
                              //удаление и обновление страницы
                              await delModule(moduleCollection).then(
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

              //текст
              Expanded(
                child: TTip(
                  message: 'Переход к модулю',
                  child: InkWell(
                    onTap: () {
                      ///////////////  ===================== инициализируем провайдер данными из FS
                      /// перед переходом к играм
                      /////////////// var sum = lists.reduce((value, current) => value + current);
                      final scoresData =
                          widget.usermapdata['scores'] as Map<String, dynamic>;
                      if (scoresData.isEmpty) {
                        ref.read(scoresProvider.notifier).updateModuleScores(0);
                      } else {
                        final t = scoresData[moduleCollection['id'].toString()]
                            as List;
                        ref.read(scoresProvider.notifier).updateModuleScores(
                              t[0] as int,
                            );
                      }

                      /* ref.read(scoresProvider.notifier).updateUserScores(
                            widget.usermapdata['score'] as int,
                          ); */
                      /* if (retScore != widget.usermapdata['score'] as int) {
                      } else {
                        retScore = widget.usermapdata['score'] as int;
                      } */
                      ref.read(scoresProvider.notifier).updateUserScores(
                            retScore,
                          );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActionsAndGames(
                            collectionPath: widget.collectionPath,
                            usermapdata: widget.usermapdata,
                            mapdata: moduleCollection,
                          ),
                        ),
                      );
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      //  child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            moduleName,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            //minFontSize: 12,
                            //textAlign: TextAlign.center,
                          ),
                          AutoSizeText(
                            moduleDescription,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            //textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      //),
                    ),
                  ),
                ),
              ),
              //редактирование
              Visibility(
                visible: shared[0] == widget.usermapdata['userid'] as String,
                child: TTip(
                  message: 'Изменить',
                  child: IconButton(
                    icon: Transform.scale(
                      scale: 1.4,
                      child: Icon(
                        Icons.edit_note_rounded,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    onPressed: () {
                      _gotoedit(
                        widget.collectionPath,
                        widget.usermapdata,
                        context,
                        moduleCollection,
                      );
                    },
                  ),
                ),
              ),
              //удаление
              Visibility(
                visible: shared[0] == widget.usermapdata['userid'] as String,
                child: TTip(
                  message: 'Удалить',
                  child: IconButton(
                    icon: Transform.scale(
                      scale: 1.4,
                      child: Icon(
                        Icons.clear_rounded,
                        color: Colors.red.shade900,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 24,
                            title: const Text('Подтверждаете удаление модуля?'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                    moduleName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Да',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                                onPressed: () {
                                  //удаление
                                  Future.delayed(
                                    Duration.zero,
                                    () async {
                                      await deleteFS(
                                        collection: widget.collectionPath,
                                        id: '${moduleCollection['id']}',
                                      );
                                    },
                                  );
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                        collectionPath: widget.collectionPath,
                                        usermapdata: widget.usermapdata,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  'Нет',
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
                    },
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}

//переход на редактирование модуля
void _gotoedit(
  String collectionPath,
  Map<String, dynamic> usermapdata,
  BuildContext context,
  Map<String, dynamic> mapdata,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ModuleEdit(
        collectionPath: collectionPath,
        usermapdata: usermapdata,
        mapdata: mapdata,
        isAdd: false,
      ),
    ),
  );
}

/*Future<void> _gotoedit(
  String collectionPath,
  String userid,
  BuildContext context,
  Map<String, dynamic> mapdata,
) async {
  List<Uint8List> imgsData = [];
  Future.delayed(Duration.zero, () async {
    //debugPrint('init-${DateTime.now()}');
    await getImgs(getImgsName: mapdata['imgs'] as List).then((value) {
      imgsData = value;
      //debugPrint('done-${DateTime.now()}');
      //if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModuleEdit(
            collectionPath: collectionPath,
            userid: userid,
            mapdata: mapdata,
            isAdd: false,
            imgsData: imgsData,
          ),
        ),
      );
    });
  }); 
}*/

/* Future<void> delModule(
  Map<String, dynamic> moduleCollection,
) async {
  final List<Object?> obj = await getUsersVarsFS(moduleCollection);
  final fbs.ListResult result =
      await fbs.FirebaseStorage.instance.ref().listAll();
  for (int i = 0; i < obj.length; i++) {
    final _datalist = obj[i]! as Map<String, dynamic>;
    //debugPrint(_data['var'].toString());
    //debugPrint(obj.length.toString());
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
    await deleteUser(moduleCollection);
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
} */

/* //удаление модуля
Future<bool> delModuleDialog(
  BuildContext context,
) async {
  bool excode = false;
  CupertinoContextMenu(
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
  ); */

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
/*   return excode;
} */
