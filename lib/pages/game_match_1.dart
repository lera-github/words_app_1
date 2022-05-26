import 'dart:js';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:controllable_widgets/controllable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_finder/widget_finder.dart';

List _words1 = []; //массивы слов
List _words2 = [];
final myCards = <MyCard>[];
List<Map<String, dynamic>> _cardProperties = [];

class GameMatch1 extends StatefulWidget {
  const GameMatch1({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameMatch1> createState() => _GameMatch1State();
}

class _GameMatch1State extends State<GameMatch1> {
  @override
  void initState() {
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyCardModel(),
      child: const MyCards(),

      /* Scaffold(
        body: Offstage(
          offstage: _offstage,
          child: WidgetFinder.sizeNotifer(
            onSizeChanged: (size) {
              setState(() {
                _area = size as Size;
                if (_area != Size.zero) {
                  _offstage = false;
                }
              });
            },
            child: Stack(
              children: 

              //getControls(),
            ),
          ),
        ),
      ), */
    );
  }
}

// данные
class MyCardModel extends ChangeNotifier {
  var _area = Size.zero; // размер области размещения карточек
  bool _offstage = true;
  String _data = '';
  String get getData => _data;

  List<Map<String, dynamic>> _saveddata = [];
  void refresh(List<Map<String, dynamic>> newdata) {
    myCards.clear();
    for (int i = 0; i < _cardProperties.length; i++) {
      myCards.add(
        MyCard(
          ind: newdata[i]['ind'] as int,
          pos: newdata[i]['pos'] as Offset, //_pos
          sizeX: newdata[i]['sizeX'] as double,
          sizeY: newdata[i]['sizeY'] as double,
          color: newdata[i]['color'] as Color,
          text: newdata[i]['text'] as String,
        ),
      );
    }
    _saveddata = newdata;
    notifyListeners();
  }

  void changeData(String newdata) {
    _data = newdata;
    notifyListeners();
  }
}

//  вьюшка
class MyCards extends StatelessWidget {
  const MyCards({Key? key}) : super(key: key);

  List<Map> getMyCards() {
    var _area = Size(500, 400);
    const double _cardSizeX = 90;
    const double _cardSizeY = 60;
    final List<Offset> _points = []; // массив позиций карточек
    List<int> _indexListI = []; //массивы перемешанных индексов
    List<int> _indexListJ = [];
    //final List<List<double>> _posList = []; //массив координат
    final _random = Random();

    // если карточки сформированы - выход для обхода перегенерации
    if (myCards.length == _words1.length * 2) {
      //setState(() {});

      return _cardProperties;
    }
    myCards.clear();
    // Массивы  индексов перемешанный ВСЕХ слов
    _indexListI = List.generate(_words1.length, (index) => index);
    _indexListJ = List.generate(_words2.length, (index) => index);
    //перемешивание
    _indexListI.shuffle();
    _indexListJ.shuffle();
/*     for (int i = _indexListI.length - 1; i >= 1; i--) {
      final int j = _random.nextInt(i + 1);
      // обменять значения
      final _temp = _indexListI[j];
      _indexListI[j] = _indexListI[i];
      _indexListI[i] = _temp;
    }
    for (int i = _indexListJ.length - 1; i >= 1; i--) {
      final int j = _random.nextInt(i + 1);
      // обменять значения
      final _temp = _indexListJ[j];
      _indexListJ[j] = _indexListJ[i];
      _indexListJ[i] = _temp;
    } */

    // начальные координаты первой карточки
    var _pos = cardNewPos(_cardSizeX, _cardSizeY, _area);
    for (var i = 0; i < _words1.length * 2; i++) {
      if (_points.isEmpty) {
        // сохр. координат карточки
        _points.add(_pos);
      } else {
        int _cnt = 0; //счетчик попыток наложения карточки
        double _coverX = 0.0; //наложение при нехватке места в области
        double _coverY = 0.0; //наложение при нехватке места в области
        // проверка перекрытия имеющихся карточек новой
        for (var p = 0; p < _points.length; p++) {
          var _tmp = Offset.zero;
          if (_pos > _points[p]) {
            _tmp = _pos - _points[p];
          } else {
            _tmp = _points[p] - _pos;
          }
          //требуется ли включать наложение?
          if (_tmp <= Offset(_cardSizeX - _coverX, _cardSizeY - _coverY)) {
            _pos = cardNewPos(
                _cardSizeX, _cardSizeY, _area); //новай позиция карточки
            // включаем наложение карточек если 500 и более раз не удается разместить
            if (_cnt >= 500) {
              _coverX = _cardSizeX - 30;
              _coverY = _cardSizeY - 30;
            }
            if (_cnt >= 1000) {
              _coverX = _cardSizeX - 10;
              _coverY = _cardSizeY - 10;
            }
            //увеличиваем счетчик попыток и перезапускаем цикл
            p = -1;
            _cnt++;
            continue;
          }
        }
        // сохр. координат карточки
        _points.add(_pos);
      }
      // выбор текста из нужного массива
      var _tmptxt = '';
      if (i < _words1.length) {
        _tmptxt = _words1[_indexListI[i]] as String;
      } else {
        _tmptxt = _words2[_indexListJ[i - _words1.length]] as String;
      }
      //формирование карточки
      _cardProperties.add({
        'ind': i,
        'pos': _points[i],
        'sizeX': _cardSizeX,
        'sizeY': _cardSizeY,
        'color': i < _words1.length ? Colors.red : Colors.blue,
        'text': _tmptxt,
      });
      /* myCards.add(
        MyCard(
          ind: i,
          pos: _points[i], //_pos
          sizeX: _cardSizeX,
          sizeY: _cardSizeY,
          color: i < _words1.length ? Colors.red : Colors.blue,
          text: _tmptxt,
          //refresh: _refresh,
        ),
      ); */

      _pos = cardNewPos(_cardSizeX, _cardSizeY, _area);
    }
    //setState(() {});

    return _cardProperties;
  }

  //получение случайных координат в области
  Offset cardNewPos(double _sx, double _sy, Size _area) {
    final _random = Random();
    return Offset(
      _random.nextDouble() * (_area.width - _sx),
      _random.nextDouble() * (_area.height - _sy),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MyCardModel>();
    if (_cardProperties.length == 0) {
      getMyCards();
      for (int i = 0; i < _cardProperties.length; i++) {
        myCards.add(
          MyCard(
            ind: _cardProperties[i]['ind'] as int,
            pos: _cardProperties[i]['pos'] as Offset, //_pos
            sizeX: _cardProperties[i]['sizeX'] as double,
            sizeY: _cardProperties[i]['sizeY'] as double,
            color: _cardProperties[i]['color'] as Color,
            text: _cardProperties[i]['text'] as String,
            //refresh: _refresh,
          ),
        );
      }
    }
    return Scaffold(
      body: Stack(
        children: myCards,
      ),
    );

    /* Scaffold(
        body: Text(
      model._data,
    ) ////////////////////////////////
        ); */
  }
}
//////////////////////////////////////////////////////////////////////////
///
/////////////////////////////////////////////////////

// виджет карточки

class MyCard extends StatefulWidget {
  const MyCard({
    Key? key,
    required this.ind,
    required this.pos,
    required this.sizeX,
    required this.sizeY,
    required this.color,
    required this.text,
  }) : super(key: key);
  final int ind;
  final Offset pos;
  final double sizeX;
  final double sizeY;
  final Color color;
  final String text;

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<MyCardModel>();
    final CustomPositionedWidgetController _controller =
        CustomPositionedWidgetController(
      offsetBuilder: (contentSize) => Offset(widget.pos.dx, widget.pos.dy),
      padding: const EdgeInsets.all(4),
      canGoOffParentBounds: false,
    );
    return GestureDetector(
      onPanDown: (details) {
        if (_words1.length * 2 == myCards.length) {
          final _lastCard = _cardProperties[_cardProperties.length - 1];
          _cardProperties[_cardProperties.length - 1] =
              _cardProperties[widget.ind];
          _cardProperties[widget.ind] = _lastCard;
/*           final _lastCard = myCards[myCards.length - 1];
          myCards[myCards.length - 1] = myCards[widget.ind];
          myCards[widget.ind] = _lastCard; */
        }
        //context.watch<MyCardData>().getData;
        //model.refresh(_cardProperties);
      },
      onPanUpdate: (details) {
        final currentBuilder = _controller.offsetBuilder;
        _controller.offsetBuilder = (Size containerSize) {
          /*  _cardProperties[widget.ind]['pos'] =
                currentBuilder.call(containerSize) + details.delta; */
          return _cardProperties[widget.ind]['pos'] =
              currentBuilder.call(containerSize) + details.delta;
        };
        //model.refresh(_cardProperties);
        //_controller.notifyListeners();
      },
      child: CustomPositionedWidget(
        key: UniqueKey(),
        maxSize: Size(widget.pos.dx, widget.pos.dy),
        controller: _controller,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          shadowColor: Colors.blueAccent,
          elevation: 8,
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Container(
              height: widget.sizeY, //size
              width: widget.sizeX,
              decoration: BoxDecoration(
                border:
                    Border(left: BorderSide(color: widget.color, width: 10)),
                color: Colors.yellowAccent.shade100,
              ),
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                widget.text,
                maxLines: 5,
                wrapWords: false,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                overflow: TextOverflow.ellipsis,
                minFontSize: 8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}




/////////////////////////////////////////////////////////////////////////////////////////////////////
///
///

/* List<MyCard> getMyCards() {
    var _area = Size(500, 400);
    const double _cardSizeX = 90;
    const double _cardSizeY = 60;
    final List<Offset> _points = []; // массив позиций карточек
    List<int> _indexListI = []; //массивы перемешанных индексов
    List<int> _indexListJ = [];
    //final List<List<double>> _posList = []; //массив координат
    final _random = Random();

    // если карточки сформированы - выход для обхода перегенерации
    if (myCards.length == _words1.length * 2) {
      //setState(() {});
      
      return myCards;
    }
    myCards.clear();
    // Массивы  индексов перемешанный ВСЕХ слов
    _indexListI = List.generate(_words1.length, (index) => index);
    _indexListJ = List.generate(_words2.length, (index) => index);
    //перемешивание
    for (int i = _indexListI.length - 1; i >= 1; i--) {
      final int j = _random.nextInt(i + 1);
      // обменять значения
      final _temp = _indexListI[j];
      _indexListI[j] = _indexListI[i];
      _indexListI[i] = _temp;
    }
    for (int i = _indexListJ.length - 1; i >= 1; i--) {
      final int j = _random.nextInt(i + 1);
      // обменять значения
      final _temp = _indexListJ[j];
      _indexListJ[j] = _indexListJ[i];
      _indexListJ[i] = _temp;
    }

    // начальные координаты первой карточки
    var _pos = cardNewPos(_cardSizeX, _cardSizeY, _area);
    for (var i = 0; i < _words1.length * 2; i++) {
      if (_points.isEmpty) {
        // сохр. координат карточки
        _points.add(_pos);
      } else {
        int _cnt = 0; //счетчик попыток наложения карточки
        double _coverX = 0.0; //наложение при нехватке места в области
        double _coverY = 0.0; //наложение при нехватке места в области
        // проверка перекрытия имеющихся карточек новой
        for (var p = 0; p < _points.length; p++) {
          var _tmp = Offset.zero;
          if (_pos > _points[p]) {
            _tmp = _pos - _points[p];
          } else {
            _tmp = _points[p] - _pos;
          }
          //требуется ли включать наложение?
          if (_tmp <= Offset(_cardSizeX - _coverX, _cardSizeY - _coverY)) {
            _pos = cardNewPos(
                _cardSizeX, _cardSizeY, _area); //новай позиция карточки
            // включаем наложение карточек если 500 и более раз не удается разместить
            if (_cnt >= 500) {
              _coverX = _cardSizeX - 30;
              _coverY = _cardSizeY - 30;
            }
            if (_cnt >= 1000) {
              _coverX = _cardSizeX - 10;
              _coverY = _cardSizeY - 10;
            }
            //увеличиваем счетчик попыток и перезапускаем цикл
            p = -1;
            _cnt++;
            continue;
          }
        }
        // сохр. координат карточки
        _points.add(_pos);
      }
      // выбор текста из нужного массива
      var _tmptxt = '';
      if (i < _words1.length) {
        _tmptxt = _words1[_indexListI[i]] as String;
      } else {
        _tmptxt = _words2[_indexListJ[i - _words1.length]] as String;
      }
      //формирование карточки
      myCards.add(
        MyCard(
          ind: i,
          pos: _points[i], //_pos
          sizeX: _cardSizeX,
          sizeY: _cardSizeY,
          color: i < _words1.length ? Colors.red : Colors.blue,
          text: _tmptxt,
          //refresh: _refresh,
        ),
      );

      _pos = cardNewPos(_cardSizeX, _cardSizeY, _area);
    }
    //setState(() {});
    
    return myCards;
  }*/
