import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:widget_finder/widget_finder.dart';

List _words1 = []; //массивы слов
List _words2 = [];
final myCards = <Widget>[];
const double cardSizeX = 120; //размер карточки
const double cardSizeY = 60;
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

  List<bool> isDropped =
      []; // признаки обработанных карточек (совпадение установлено)

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
  }

  @override
  void dispose() {
    myCards.clear();
    super.dispose();
  }

  List<Widget> getMyCards() {
    _points.clear();
    myCards.clear();
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;

    // начальные координаты первой карточки
    var _pos = cardNewPos(cardSizeX, cardSizeY);
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
          if (_tmp <= Offset(cardSizeX - _coverX, cardSizeY - _coverY)) {
            _pos = cardNewPos(cardSizeX, cardSizeY); //новая позиция карточки
            // включаем наложение карточек если 10000 и более раз не удается разместить
            if (_cnt >= 10000) {
              _coverX = cardSizeX - 10;
              _coverY = cardSizeY - 10;
            }
            if (_cnt >= 50000) {
              _coverX = cardSizeX - 30;
              _coverY = cardSizeY - 30;
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
        _tmptxt = _words1[i] as String;
      } else {
        _tmptxt = _words2[i - _words1.length] as String;
      }
      //формирование карточки
      myCards.add(
        TheCard(
          sizeX: cardSizeX,
          sizeY: cardSizeY,
          color: i < _words1.length ? Colors.blue : Colors.green,
          text: _tmptxt,
        ),
      );
      _pos = cardNewPos(cardSizeX, cardSizeY);
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

  // размещаем карточки
  List<Widget> dragItems() {
    final List<Positioned> _items = [];
    //
    for (var g = 0; g < _words1.length; g++) {
      final Positioned _item = Positioned(
        top: _points[g].dy,
        left: _points[g].dx,
        child: Visibility(
          visible: !isDropped[g],
          child: Draggable(
            data: g + _words1.length,
            feedback: Transform.scale(
              scale: 1.2,
              child: Opacity(
                opacity: 0.75,
                child: myCards[g],
              ),
            ),
            childWhenDragging: Container(),
            child: myCards[g],
          ),
        ),
      );
      _items.add(_item);
    }
    //

    //for (var g = _words1.length; g < _words1.length * 2; g++) {
    for (var g = 0; g < _words1.length * 2; g++) {
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
              //return myCards[g];
              return Draggable(
                data: g,
                feedback: Visibility(
                  visible: !isDropped[g],
                  child: Transform.scale(
                    scale: 1.2,
                    child: Opacity(
                      opacity: 0.75,
                      child: myCards[g],
                    ),
                  ),
                ),
                childWhenDragging: Container(),
                child: Visibility(
                  visible: !isDropped[g],
                  child: myCards[g],
                ),
              );
            },
            //условия совпадения карточек
            onWillAccept: (data) {
              final _data = data! as int;
              return (g < _words1.length)
                  ? (_data == g + _words1.length) && (_data != g)
                  : ((_data + _words1.length) == g) && (_data != g);
            },
            //действия при совпадении
            onAccept: (data) {
              setState(() {
                if (g < _words1.length) {
                  isDropped[g] = true;
                  isDropped[g + _words1.length] = true;
                } else {
                  isDropped[g] = true;
                  isDropped[g - _words1.length] = true;
                }
              });
            },
          ),
        ),
      );
      _items.add(_item);
    }
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Offstage(
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
            ),
          ),
        ),
      ),
    );
  }
}

// карточка
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
