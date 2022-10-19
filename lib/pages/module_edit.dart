import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  }) : super(key: key);
  final String collectionPath;
  final String userid;
  final Map<String, dynamic> mapdata;
  final bool isAdd;
  @override
  _ModuleEditState createState() => _ModuleEditState();
}

class _ModuleEditState extends State<ModuleEdit> {
  // the GlobalKey is needed to animate the list
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  // backing data
  // List<String> _data = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Last Item'];
  List _words1 = [];
  List _words2 = [];
List _imgs = [];

  bool moduleNameOK = false;
  TextEditingController moduleNameController = TextEditingController();
  TextEditingController moduleDescriptionController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;
    if (!widget.isAdd) {
      moduleNameController.text = widget.mapdata['module'] as String;
      moduleDescriptionController.text =
          widget.mapdata['description'] as String;
    }
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
    _imgs = widget.mapdata['imgs'] as List;
    /* Uint8List? img;
    Future.delayed(Duration.zero, () async {
      await fromFBS('ffffffNDLokxzVclUdMs.png').then((value) {
        img = value;
      });
    }); */

    return FutureBuilder(
      future: //fromFBS('ffffffNDLokxzVclUdMs.png'),
      getImgs(imgname: _imgs),
      builder: (BuildContext context, AsyncSnapshot<List<Uint8List>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 40,
            ),
          );
        }
        if (snapshot.hasData) {
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

                            await FirebaseFirestore.instance
                                .collection(widget.collectionPath)
                                .doc(idx as String)
                                .update({
                              'words1': _words1,
                              'words2': _words2,
                              'module': moduleNameController.text.trim(),
                              'description':
                                  moduleDescriptionController.text.trim()
                            });
                            if (!mounted) return;
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
                            horizontal: 8, vertical: 8,),
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
                              onTap: () => _insertSingleItem(),
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

                          /// Key to call remove and insert item methods from anywhere  ///////////////////////////////
                          key: _listKey,
                          initialItemCount: _words1.length,
                          //_data.length,
                          itemBuilder: (context, index, animation) {
                            return _buildItem(
                              _words1[index] as String,
                              _words2[index] as String,
                              animation,
                              index,
                              snapshot.data![index],
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
            /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.playlist_add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => _insertSingleItem(),
      ), */
          );
        }

        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return const SizedBox();
      },
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
                  //Text(item2,style: TextStyle(fontSize: 14),),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 5,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: SizedBox(
                    width: 20,
                    child: Image.memory(img),

                    /* Image.network(
                      'https://cdn1.ozone.ru/s3/multimedia-h/6300467429.jpg', /////////////////////
                    ), */
                  ),
                  onTap: () {
                    ////////////////////////////////////
                    //showAlert(context: context, mytext: 'нажалось...');
                    showImgDialog(context: context);
                    setState(() {});
                  },
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
  void _insertSingleItem() {
    int insertIndex;
    if (_words1.isNotEmpty) {
      insertIndex = _words1.length;
    } else {
      insertIndex = 0;
    }
    _words1.insert(insertIndex, '');
    _words2.insert(insertIndex, '');
    _listKey.currentState!.insertItem(insertIndex);

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
    final AnimatedListRemovedItemBuilder builder =
        (context, animation) => _buildItem(
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
