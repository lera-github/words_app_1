import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/game_flash_card.dart';

class ActionsAndGames extends StatefulWidget {
  const ActionsAndGames({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  _ActionsAndGamesState createState() => _ActionsAndGamesState();
}

class _ActionsAndGamesState extends State<ActionsAndGames> {
  // the GlobalKey is needed to animate the list
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  List _words1 = [];
  List _words2 = [];
  bool moduleNameOK = false;
  TextEditingController moduleNameController = TextEditingController();
  TextEditingController moduleDescriptionController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;

    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 220),
        actions: [
          const SizedBox(
            width: 20,
          ),
          Align(
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
                    builder: (context) => const MyHomePage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //здесь можно кнопки положить (см. как в module_list например)
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints.expand(width: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    TextButton(onPressed: () {}, child: Text('Карточки')),
                    TextButton(onPressed: () {}, child: Text('Подбор'))
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.expand(width: _scrwidth),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            widget.mapdata['favourite'] as bool
                                ? Icons.star_rate_rounded
                                : Icons.star_border_rounded,
                            color: widget.mapdata['favourite'] as bool
                                ? Colors.yellow.shade600
                                : Colors.grey.shade400,
                          ),
                          Expanded(
                            child: AutoSizeText(
                              widget.mapdata['module'] as String,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          widget.mapdata['description'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                        ),
                      ),
                    ),
                    const Expanded(
                      child:

///////////////////////////////////////////////   сюда идет поле игры
                          /// Icon   - это для примера
                          GameFlashCard(),
                      
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildItem(
    String item1,
    String item2,
    Animation animation,
    int index,
  ) {
    final TextEditingController item1Controller = TextEditingController();
    item1Controller.text = item1; //_words1[index] as String;
    final TextEditingController item2Controller = TextEditingController();
    item2Controller.text = item2; //_words2[index] as String;
    return SizeTransition(
      sizeFactor: animation as Animation<double>,
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
            ],
          ),
          trailing: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            onTap: () {
              _removeSingleItems(index);
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
  void _removeSingleItems(int removeAt) {
    final int removeIndex = removeAt;
    final String removedItem1 = _words1.removeAt(removeIndex) as String;
    final String removedItem2 = _words2.removeAt(removeIndex) as String;
    final AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removedItem1, removedItem2, animation, removeAt);
    };
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
