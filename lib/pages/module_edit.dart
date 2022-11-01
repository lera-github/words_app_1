import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/helpers/fb_hlp.dart';
import 'package:myapp/helpers/img_hlp.dart';
import 'package:myapp/helpers/other_hlp.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/main.dart';

class ModuleEdit extends StatefulWidget {
  const ModuleEdit({
    Key? key,
    required this.collectionPath,
    required this.userid,
    required this.mapdata,
    required this.isAdd,
    //required this._imgsData,
  }) : super(key: key);
  final String collectionPath;
  final String userid;
  final Map<String, dynamic> mapdata;
  final bool isAdd;
  //final List<Uint8List> _imgsData;
  @override
  _ModuleEditState createState() => _ModuleEditState();
}

class _ModuleEditState extends State<ModuleEdit> {
  // the GlobalKey is needed to animate the list
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  //слова
  List _words1 = [];
  List _words2 = [];
  //имена файлов
  List _imgs = [];
  //изображения
  List<Uint8List> _imgsData = [];
  //id автора модуля и признак общего доступа
  List _keys = [];

  //признак корректности текстового ввода
  bool moduleNameOK = false;
  // контроллеры
  TextEditingController moduleNameController = TextEditingController();
  TextEditingController moduleDescriptionController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  //признак - данные для интерфейса уже загружены в память?
  bool isLoaded = false;
  //массив удаленных файлов
  List<String> imgsToRemove = [];
  /*   @override
    void initState() {
    super.initState();
    imgName0 = widget.mapdata['imgs'] as List;
    } */

  @override
  Widget build(BuildContext context) {
    final scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;
    if (!isLoaded) {
      if (!widget.isAdd) {
        moduleNameController.text = widget.mapdata['module'] as String;
        moduleDescriptionController.text =
            widget.mapdata['description'] as String;
      }
      _words1 = widget.mapdata['words1'] as List;
      _words2 = widget.mapdata['words2'] as List;
      _imgs = widget.mapdata['imgs'] as List;
      _keys = widget.mapdata['keys'] as List;
    }
    //_imgsData = widget._imgsData;

    /* Future.delayed(Duration.zero, () async {
      await getImgs(imgName0: _imgs).then((value) => _imgsData = value);
    }); */
    /* Uint8List? img;
    Future.delayed(Duration.zero, () async {
      await fromFBS('ffffffNDLokxzVclUdMs.png').then((value) {
        img = value;
      });
    }); */

    //fb
    return FutureBuilder(
      future: getImgs(
        getImgsName: widget.mapdata['imgs'] as List,
        isLoaded: isLoaded,
      ),
      //.then((value) {_imgsData = value;});

      builder: (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 40,
            ),
          );
        }
        if (snapshot.hasData) {
          if (!isLoaded) {
            _imgsData = snapshot.data!;
          }
          isLoaded = true;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color.fromARGB(255, 255, 255, 220),
              actions: [
                const SizedBox(
                  width: 20,
                ),
                Align(
                  child: TTip(
                    message: 'На домашнюю страницу...',
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Text(
                        'Memory Games',
                        style: titleStyle,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyHomePage(
                              collectionPath: widget.collectionPath,
                              userid: widget.userid,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //----------------------------------------- кнопка Сохранить -----------------------------------------
                      ElevatedButton(
                        style: menuButtonStyle,
                        onPressed: () async {
                          bool moduleItemsOK = true;
                          for (int i = 0; i < _words1.length; i++) {
                            if ((_words1[i] == '') | (_words2[i] == '')) {
                              moduleItemsOK = false;
                            }
                          }
                          if (moduleNameOK & moduleItemsOK) {
                            var idx = widget.mapdata['id'];
                            //добавление модуля?
                            if (widget.isAdd) {
                              await FirebaseFirestore.instance
                                  .collection(widget.collectionPath)
                                  .add({'favourite': false}).then((value) {
                                idx = value.id;
                              });
                              await FirebaseFirestore.instance
                                  .collection(widget.collectionPath)
                                  .doc(idx as String)
                                  .update({'id': idx});
                            }
                            /////////////////////////запись изображений в FBS
                            for (int i = 0; i < _words1.length; i++) {
                              // "заглушку" не сохраняем
                              if (_imgs[i] != 'placeholder.png') {
                                //запись  файла
                                await toFBS(_imgs[i] as String, _imgsData[i]);
                              }
                            }
                            //удаление из FBS файлов изображений по списку
                            for (int i = 0; i < imgsToRemove.length; i++) {
                              await delFBS(
                                imgsToRemove[i],
                              );
                            }

                            /* // получим список имен изображений
                            final List<Object?> moduleData = await getFSfind(
                              collection: 'modules',
                              myfield: 'id',
                              myvalue: idx as String,
                            );
                            final moduleDataMap =
                                moduleData[0]! as Map<String, dynamic>;
                            //это список имен файлов из FBS
                            final moduleDataItem = moduleDataMap['imgs']
                                as List; // as List<String>;
                            //сравним исходный список имен файлов с изменённым
                            for (int i = 0; i < _words1.length; i++) {
                              //при неравенстве записываем файл
                              if (_imgs[i] != moduleDataItem[i]) {
                                //удаление старого файла, если это не "заглушка"
                                if (moduleDataItem[i] as String !=
                                    'placeholder.png') {
                                  await delFBS(
                                    moduleDataItem[i] as String,
                                  );
                                }
                                //запись нового файла
                                await toFBS(_imgs[i] as String, _imgsData[i]);
                              }
                            } */

                            // запись модуля в FB
                            await FirebaseFirestore.instance
                                .collection(widget.collectionPath)
                                .doc(idx as String)
                                .update({
                              'words1': _words1,
                              'words2': _words2,
                              'imgs': _imgs,
                              'keys': _keys,
                              'module': moduleNameController.text.trim(),
                              'description':
                                  moduleDescriptionController.text.trim()
                            });
                            if (!mounted) return;
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(
                                  collectionPath: widget.collectionPath,
                                  userid: widget.userid,
                                ),
                              ),
                            );
                          } else {
                            showAlert(
                              context: context,
                              mytext: 'Внесите обязательные данные!',
                            );
                          }
                        },
                        child: const Text("Сохранить"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            body: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(width: scrwidth),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: textStyle,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.always,
                          controller: moduleNameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Название',
                            hintText: 'Введите название модуля',
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          //onChanged: (value) => moduleNameController.text = value,
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
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: text14Style,
                          keyboardType: TextInputType.text,
                          controller: moduleDescriptionController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Описание',
                            hintText: 'Введите описание модуля',
                            hintStyle:
                                TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          //onChanged: (value) => moduleDescriptionController.text = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          bottom: 8,
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                'Термины в модуле (${_words1.length}):',
                              ),
                            ),
                            InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue.shade700,
                              ),
                              onTap: () async {
                                await _insertSingleItem();
                              },
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AnimatedList(
                          controller: scrollController,

                          /// Key to call remove and insert item methods from anywhere
                          key: _listKey,
                          initialItemCount: _words1.length,
                          itemBuilder: (context, index, animation) {
                            //сохраним в массив полученные изображения из FBS
                            //_imgsData[index] = snapshot.data![index];
                            return _buildItem(
                              _words1[index] as String,
                              _words2[index] as String,
                              animation,
                              index,
                              //snapshot.data![index],
                              _imgsData[index],
                            );
                            //_buildItem(_data[index], animation, index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        //fb

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const SizedBox();
      },

      //fb
    );
  }

  Widget _buildItem(
    String item1,
    String item2,
    Animation<double> animation,
    int index,
    Uint8List img,
  ) {
    final TextEditingController item1Controller = TextEditingController();
    item1Controller.text = item1; //_words1[index] as String;
    final TextEditingController item2Controller = TextEditingController();
    item2Controller.text = item2; //_words2[index] as String;
    var currentImg = img;

    return SizeTransition(
      sizeFactor: animation, // as Animation<double>,
      child: Card(
        elevation: 5.0,
        child: ListTile(
          title: Row(
            children: [
              Expanded(
                flex: 20,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 14),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: item1Controller,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (item1Validator) {
                      if (item1Validator!.isEmpty) {
                        return '* Обязательно для заполнения';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) => _words1[index] = value,
                  ),
                  //Text(item1,style: TextStyle(fontSize: 14),),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 20,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 14),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: item2Controller,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (item2Validator) {
                      if (item2Validator!.isEmpty) {
                        return '* Обязательно для заполнения';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) => _words2[index] = value,
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 5,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: SizedBox(
                    width: 20,
                    child: Image.memory(currentImg), // выводим изображение
                  ),
                  //клик по изображению
                  onTap: () async {
                    showDialog(
                      builder: (_) => ShowImgDialog(),
                      context: context,
                    ).then((value) async {
                      // введенный в диалоговом окне URL изображения (или имя заглушки)
                      if (value != null) {
                        final val = value as String;
                        //  value1 содержит изображение полученное по ссылке (bin)
                        //  _imgs[index] - массив строк с именами файлов
                        //  currentImg - изображение полученное по ссылке (bin)
                        //        сохраняем для отображения
                        if (value != 'placeholder.png') {
                          //  получим изображение:
                          await loadImg(val).then((value1) {
                            currentImg = value1;
                          });
                          //генератор имени файла
                          if (_imgs[index] == 'placeholder.png') {
                            _imgs[index] = md5
                                .convert(
                                  utf8.encode(
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                  ),
                                )
                                .toString();
                          }
                        } else {
                          //получить "заглушку"
                          await getPlaceholderImg().then((value1) {
                            currentImg = value1;
                          });
                          //запишем имя файла который надо будет удалить из FBS  в imgsToRemove !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                          if (_imgs[index] != 'placeholder.png') {
                            imgsToRemove.add(_imgs[index] as String);
                          }
                          //сохранить в массив имя заглушки 'placeholder.png'
                          _imgs[index] = value;
                        }
                        //сохранить в массив изображение
                        setState(() {
                          _imgsData[index] = currentImg;
                        });
                      }
                    });
                  },
                  /* async {
                    //Вызов диалога загрузки изображения
                    await showImgDialog(context: context).then((value) {
                      setState(() {
                        _imgs[index] = value;
                      });
                    }).onError((error, stackTrace) {});
                    debugPrint(_imgs[index].toString());
                  }, */
                ),
              ),
            ],
          ),
          trailing: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            onTap: () {
              _removeSingleItems(index, img);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  /// Method to add an item to an index in a list
  Future<void> _insertSingleItem() async {
    int insertIndex;
    if (_words1.isNotEmpty) {
      insertIndex = _words1.length;
    } else {
      insertIndex = 0;
    }
    _words1.insert(insertIndex, '');
    _words2.insert(insertIndex, '');
    _imgs.insert(insertIndex, 'placeholder.png');
    /* //файл пустышки
    ByteData bytes;
    await rootBundle.load('placeholder.png').then((value) {
      bytes = value;
      _imgsData.insert(insertIndex, bytes.buffer.asUint8List());
    }); */
    await getPlaceholderImg()
        .then((value) => _imgsData.insert(insertIndex, value));

    _listKey.currentState!.insertItem(insertIndex);
    //прокрутка в конец
    _scrollDown();
    setState(() {});

    /*     int insertIndex;
    if (_data.length > 0) {
      insertIndex = _data.length;
    } else {
      insertIndex = 0;
    }
    String item = "Item insertIndex + 1";
    _data.insert(insertIndex, item);
    _listKey.currentState!.insertItem(insertIndex); */
  }

  /// Method to remove an item at an index from the list
  void _removeSingleItems(int removeAt, Uint8List img) {
    final int removeIndex = removeAt;
    final String removedItem1 = _words1.removeAt(removeIndex) as String;
    final String removedItem2 = _words2.removeAt(removeIndex) as String;
    imgsToRemove.add(_imgs[removeIndex] as String);
    _imgs.removeAt(removeIndex);

    Widget builder(context, Animation<double> animation) => _buildItem(
          removedItem1,
          removedItem2,
          animation,
          removeAt,
          img,
        );
    _listKey.currentState!.removeItem(removeIndex, builder);
/*     int removeIndex = removeAt;
    String removedItem = _data.removeAt(removeIndex);
    // This builder is just so that the animation has something
    // to work with before it disappears from view since the original
    // has already been deleted.
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      // A method to build the Card widget.
      return _buildItem(removedItem, animation, removeAt);
    };
    _listKey.currentState!.removeItem(removeIndex, builder); */
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 700)).then((value) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    });
  }
}
