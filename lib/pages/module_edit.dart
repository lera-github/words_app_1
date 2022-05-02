import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helpers/fb_hlp.dart';
import '../helpers/module_add_text.dart';
import '../helpers/styles.dart';

class ModuleEdit extends StatefulWidget {
  ModuleEdit({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;
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
  @override
  Widget build(BuildContext context) {
    List<String> _data = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Last Item'
    ]; // убрать

    final _scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;

    bool moduleNameOK = false;
    TextEditingController moduleNameController = TextEditingController();
    TextEditingController moduleDescriptionController = TextEditingController();
    moduleNameController.text = widget.mapdata['module'];
    moduleDescriptionController.text = widget.mapdata['description'];
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'заменить или удалить AppBar',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(width: _scrwidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: textStyle,
                    keyboardType: TextInputType.text,
                    autovalidateMode:
                        AutovalidateMode.onUserInteraction, //always
                    controller: moduleNameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Название',
                      hintText: 'Введите название модуля',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
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
                      top: 0, bottom: 0, left: 8, right: 8),
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: text14Style,
                    keyboardType: TextInputType.text,
                    controller: moduleDescriptionController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Описание',
                      hintText: 'Введите описание модуля',
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 8, left: 8, right: 8),
                  child: Text(
                    'Термины в модуле (${_words1.length}):',
                  ),
                ),
                Expanded(
                  child: AnimatedList(
                    /// Key to call remove and insert item methods from anywhere  ///////////////////////////////
                    key: _listKey,
                    initialItemCount: _words1.length,
                    //_data.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(_words1[index] as String,
                          _words2[index] as String, animation, index);
                      //_buildItem(_data[index], animation, index);
                    },
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.playlist_add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => _insertSingleItem(),
      ),
    );
  }

  Widget _buildItem(
      String item1, String item2, Animation animation, int index) {
    TextEditingController item1Controller = TextEditingController();
    item1Controller.text = item1;
    TextEditingController item2Controller = TextEditingController();
    item2Controller.text = item2;
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
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: item1Controller,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) => _words1[index] = value,
                  ),
                  //Text(item1,style: TextStyle(fontSize: 14),),
                  onTap: () {},
                ),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 20,
                child: InkWell(
                  child: TextFormField(
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: item2Controller,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) => _words2[index] = value,
                  ),
                  //Text(item2,style: TextStyle(fontSize: 14),),
                  onTap: () {},
                ),
              ),
            ],
          ),
          trailing: InkWell(
            child: Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
            onTap: () {
              _removeSingleItems(index);
            },
          ),
        ),
      ),
    );
  }

  /// Method to add an item to an index in a list
  void _insertSingleItem() {
    int insertIndex;
    if (_words1.length > 0) {
      insertIndex = _words1.length;
    } else {
      insertIndex = 0;
    }
    //String item = "Item insertIndex + 1";
    _words1.insert(insertIndex, '');
    _words2.insert(insertIndex, '');
    _listKey.currentState!.insertItem(insertIndex);

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
    int removeIndex = removeAt;
    String removedItem = _words1.removeAt(removeIndex);
    _words2.removeAt(removeIndex);
    // This builder is just so that the animation has something
    // to work with before it disappears from view since the original
    // has already been deleted.
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      // A method to build the Card widget.
      return _buildItem(removedItem, removedItem, animation, removeAt);
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
}
