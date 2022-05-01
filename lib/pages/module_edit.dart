import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';

import '../helpers/module_add_text.dart';

class ModuleEdit extends StatefulWidget {
  @override
  _ModuleEditState createState() => _ModuleEditState();
}

class _ModuleEditState extends State<ModuleEdit> {
  // the GlobalKey is needed to animate the list
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  // backing data
  List<String> _data = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Last Item'];

  @override
  Widget build(BuildContext context) {
    final _scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'заменить или удалить AppBar',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            //fontFamily: Utils.ubuntuRegularFont
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
                ModuleAddText(),
                Expanded(
                  child: AnimatedList(
                    /// Key to call remove and insert item methods from anywhere
                    key: _listKey,
                    initialItemCount: _data.length,
                    itemBuilder: (context, index, animation) {
                      return _buildItem(_data[index], animation, index);
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

  Widget _buildItem(String item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation as Animation<double>,
      child: Card(
        elevation: 5.0,
        child: ListTile(
          title: Text(
            item,
            style: TextStyle(fontSize: 20),
          ),
          trailing: GestureDetector(
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
    if (_data.length > 0) {
      insertIndex = _data.length;
    } else {
      insertIndex = 0;
    }
    String item = "Item insertIndex + 1";
    _data.insert(insertIndex, item);
    _listKey.currentState!.insertItem(insertIndex);
  }

  /// Method to remove an item at an index from the list
  void _removeSingleItems(int removeAt) {
    int removeIndex = removeAt;
    String removedItem = _data.removeAt(removeIndex);
    // This builder is just so that the animation has something
    // to work with before it disappears from view since the original
    // has already been deleted.
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      // A method to build the Card widget.
      return _buildItem(removedItem, animation, removeAt);
    };
    _listKey.currentState!.removeItem(removeIndex, builder);
  }
}
