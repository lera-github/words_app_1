import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Data with ChangeNotifier {
  String _data = 'Change Notifier Provider';
  String get getData => _data;

  void changeData(String newdata) {
    _data = newdata;
    notifyListeners();
  } 
}
