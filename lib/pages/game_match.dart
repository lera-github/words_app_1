import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
//import 'package:controllable_widgets/controllable_widgets.dart';
import 'package:flutter/material.dart';
//import 'package:myapp/helpers/drag_drop_match.dart';
import 'package:myapp/pages/game_match_1.dart';
import 'package:widget_finder/widget_finder.dart';

List _words1 = []; //массивы слов
List _words2 = [];
final myCards = <Widget>[];
final double _cardSizeX = 90;
final double _cardSizeY = 60;

final List<Offset> _points = []; // массив позиций карточек

class GameMatch extends StatefulWidget {
  const GameMatch({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameMatch> createState() => _GameMatchState();
}

class _GameMatchState extends State<GameMatch> {
// Key and Size of the widget

  final _random = Random();
  var _area = Size.zero; // размер области размещения карточек

  bool _offstage = true;

  List<bool> isDropped = [];

  // обновление родительского виджета
/*   _refresh() {
     setState(() {});
  } */

  @override
  void initState() {
    super.initState();
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
    isDropped = List<bool>.generate(_words1.length * 2, (index) => false);

    getMyCards();
    /* WidgetsBinding.instance?.addPersistentFrameCallback((_) {
      // do something
      debugPrint("Build Completed");
    }); */
  }

/*   @override
  void setState(VoidCallback fn) {
    if (mounted) {
      _area = MediaQuery.of(context).size;
      super.setState(fn);
    }
  } */

  @override
  void dispose() {
    //_words1.clear();
    //_words2.clear();
    myCards.clear();
    super.dispose();
  }

/*   Size _getSize() {
    final RenderBox render =
        _key.currentContext!.findRenderObject()! as RenderBox;
    return render.size;
  } */

  List<Widget> getMyCards() {
    _points.clear();
    List<int> _indexListI = []; //массивы перемешанных индексов
    List<int> _indexListJ = [];
    //final List<List<double>> _posList = []; //массив координат

    // если карточки сформированы - выход для обхода перегенерации
    /* if (myCards.length == _words1.length * 2) {
      if (myCards.isNotEmpty) {
        return myCards;
      }
    } */
    myCards.clear();
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
    // Массивы  индексов перемешанный ВСЕХ слов
    _indexListI = List.generate(_words1.length, (index) => index);
    _indexListJ = List.generate(_words2.length, (index) => index);
    //перемешивание
    //_indexListI.shuffle();
    //_indexListJ.shuffle();
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
    var _pos = cardNewPos(_cardSizeX, _cardSizeY);
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
            _pos = cardNewPos(_cardSizeX, _cardSizeY); //новая позиция карточки
            // включаем наложение карточек если 500 и более раз не удается разместить
            if (_cnt >= 1000) {
              _coverX = _cardSizeX - 10;
              _coverY = _cardSizeY - 10;
            }
            if (_cnt >= 5000) {
              _coverX = _cardSizeX - 30;
              _coverY = _cardSizeY - 30;
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
        TheCard(
          sizeX: _cardSizeX,
          sizeY: _cardSizeY,
          color: i < _words1.length ? Colors.red : Colors.blue,
          text: _tmptxt,
        ),
        /* myCardWidget(
          ind: i,
          pos: _points[i], //_pos
          sizeX: _cardSizeX,
          sizeY: _cardSizeY,
          color: i < _words1.length ? Colors.red : Colors.blue,
          text: _tmptxt,
          //refresh: _refresh,
        ), */
      );

      _pos = cardNewPos(_cardSizeX, _cardSizeY);
    }

    return myCards;
  }

  //получение случайных координат в области
  Offset cardNewPos(double _sx, double _sy) {
    return Offset(
      (_random.nextDouble() * (_area.width - _sx)).abs(),
      (_random.nextDouble() * (_area.height - _sy)).abs(),
    );
  }

// виджет карточки
  Widget myCardWidget({
    int ind = 0,
    Offset pos = Offset.zero,
    double sizeX = 0,
    double sizeY = 0,
    Color color = Colors.black,
    String text = '',
  }) {
    return /* Positioned(
      top: pos.dy,
      left: pos.dx,
      child: */
        TheCard(
      sizeX: sizeX,
      sizeY: sizeY,
      color: color,
      text: text,
      // ),

////////////////////////////////////////////////////////////////////////////////
      /* ind < _words1.length * 2
          ? Draggable(
              data: myCards[ind],
              feedback: Opacity(
                opacity: 0.8,
                child: TheCard(
                  sizeX: sizeX,
                  sizeY: sizeY,
                  color: color,
                  text: text,
                ),
              ),
              childWhenDragging: Container(),
              child: TheCard(
                sizeX: sizeX,
                sizeY: sizeY,
                color: color,
                text: text,
              ),
            )
          : DragTarget(
              onAccept: (receivedItem) {
                if (receivedItem  == ind) {
                  setState(() {
                    //item.isAccepted = true;
                  });
                  print("ACCEPTED");
                  //widget.onMatched(receivedItem);
                }
                print("ACCEPTED");
              },
              onLeave: (receivedItem) {
                print("NOT ACCEPTED");
                /* item.willAccept = false;
                  widget.onMisMatched(receivedItem!); */
              },
              /*   onWillAccept: (receivedItem) {
                  final bool willAccept =
                      receivedItem?.ind == myCards[widget.ind] && !item.isAccepted == true;
                  item.willAccept = willAccept;
                  return willAccept;
                }, */
              builder: (context, acceptedItems, rejectedItem) => Container(
                alignment: Alignment.center,
                //margin: const EdgeInsets.all(8.0),
                child: Container(
                  color: /* item.isAccepted */ true
                      ? Colors.green
                      : Colors.transparent,
                  child: TheCard(
                    sizeX: sizeX,
                    sizeY: sizeY,
                    color: color,
                    text: text,
                  ), //item.dropChild,
                ),
              ),
            ), */

////////////////////////////////////////////////////////////////////////////////////////
    );
  }

//////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Offstage(
        offstage: _offstage,
        child: WidgetFinder.sizeNotifer(
          onSizeChanged: (size) {
            setState(() {
              _offstage = false;
              _area = size as Size;
              getMyCards();
            });
          },
          child: Stack(
            children: dragItems(),

            //dragElements(),

            //myCards, //_area == Size.zero ? <Widget>[] : getMyCards(),
          ),
          //getControls(),
        ),
      ),
    );
  }

  List<Widget> dragItems() {
    final List<Positioned> _items = [];
    for (var g = 0; g < _words1.length; g++) {
      final Positioned _item = Positioned(
        top: _points[g].dy,
        left: _points[g].dx,
        child: Visibility(
          visible: !isDropped[g],
          child: Draggable(
            data: g + _words1.length,
            feedback: Opacity(
              opacity: 0.8,
              child: myCards[g],
            ),
            childWhenDragging: Container(),
            child: myCards[g],
          ),
        ),
      );
      _items.add(_item);
    }
    for (var g = _words1.length; g < _words1.length * 2; g++) {
      final Positioned _item = Positioned(
        top: _points[g].dy,
        left: _points[g].dx,
        child: Visibility(
          visible: !isDropped[g],
          child: DragTarget(
            builder: (
              BuildContext context,
              List<dynamic> accepted,
              List<dynamic> rejected,
            ) {
              return myCards[g];
            },
            onWillAccept: (data) {
              //print(data.toString() + '-' + g.toString());
              return data == g;
            },
            onAccept: (data) {
              setState(() {
                isDropped[g] = true;
                isDropped[g - _words1.length] = true;
                //print('попал');
              });
            },
          ),
        ),
      );
      _items.add(_item);
    }

    return _items;
  }
}

/////////////////////////////////////////////////////
/* 1.On Child Widget : add parameter Function paramter
class ChildWidget extends StatefulWidget {
  final Function() notifyParent;
  ChildWidget({Key key, @required this.notifyParent}) : super(key: key);
}
2.On Parent Widget : create a Function for the child to callback
refresh() {
  setState(() {});
}
3.On Parent Widget : pass parentFunction to Child Widget
new ChildWidget( notifyParent: refresh );
4.On Child Widget : call the Parent Function
  widget.notifyParent(); */

/* class MyNotify extends StatelessWidget {
  const MyNotify({Key? key, required this.notify, required this.child})
      : super(key: key);
  final Function notify;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return child;
  }
} */

/////////////////////////////////////////////////////

class TheCard extends StatelessWidget {
  const TheCard({
    Key? key,
    required this.sizeX,
    required this.sizeY,
    required this.color,
    required this.text,
  }) : super(key: key);
  final double sizeX;
  final double sizeY;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
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
          height: sizeY, //size
          width: sizeX,
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 10)),
            color: Colors.yellowAccent.shade100,
          ),
          padding: const EdgeInsets.all(2.0),
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            text,
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
    );
  }
}
