import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:widget_finder/widget_finder.dart';

//слова
List _words1 = [];
List _words2 = [];
//имена файлов
List _imgs = [];
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
    _imgs = widget.mapdata['imgs'] as List;
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
    _imgs = widget.mapdata['imgs'] as List;

    // начальные координаты первой карточки
    var pos = cardNewPos(cardSizeX, cardSizeY);
    for (var i = 0; i < _words1.length * 2; i++) {
      if (_points.isEmpty) {
        // сохр. координат карточки
        _points.add(pos);
      } else {
        int cnt = 0; //счетчик попыток наложения карточки
        double coverX = 0.0; //наложение при нехватке места в области
        double coverY = 0.0; //наложение при нехватке места в области
        // проверка перекрытия имеющихся карточек новой
        for (var p = 0; p < _points.length; p++) {
          var tmp = Offset.zero;
          if (pos > _points[p]) {
            tmp = pos - _points[p];
          } else {
            tmp = _points[p] - pos;
          }
          //требуется ли включать наложение?
          if (tmp <= Offset(cardSizeX - coverX, cardSizeY - coverY)) {
            pos = cardNewPos(cardSizeX, cardSizeY); //новая позиция карточки
            // включаем наложение карточек если 10000 и более раз не удается разместить
            if (cnt >= 10000) {
              coverX = cardSizeX - 10;
              coverY = cardSizeY - 10;
            }
            if (cnt >= 50000) {
              coverX = cardSizeX - 30;
              coverY = cardSizeY - 30;
            }
            //увеличиваем счетчик попыток и перезапускаем цикл
            p = -1;
            cnt++;
            continue;
          }
        }
        // сохр. координат карточки
        _points.add(pos);
      }
      // выбор текста из нужного массива
      var tmptxt = '';
      if (i < _words1.length) {
        tmptxt = _words1[i] as String;
      } else {
        tmptxt = _words2[i - _words1.length] as String;
      }
      //формирование карточки
      myCards.add(
        TheCard(
          sizeX: cardSizeX,
          sizeY: cardSizeY,
          color: i < _words1.length ? Colors.blue : Colors.green,
          text: tmptxt,
          imgtag: i.toString() + tmptxt,
        ),
      );
      pos = cardNewPos(cardSizeX, cardSizeY);
    }
    return myCards;
  }

  //получение случайных координат в области
  Offset cardNewPos(double sx, double sy) {
    return Offset(
      (_random.nextDouble() * (_area.width - sx)).abs(),
      (_random.nextDouble() * (_area.height - sy)).abs(),
    );
  }

  // размещаем карточки
  List<Widget> dragItems() {
    final List<Positioned> items = [];
    //
    for (var g = 0; g < _words1.length; g++) {
      final Positioned item = Positioned(
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
      items.add(item);
    }
    //

    //for (var g = _words1.length; g < _words1.length * 2; g++) {
    for (var g = 0; g < _words1.length * 2; g++) {
      final Positioned item = Positioned(
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
              final dat = data! as int;
              return (g < _words1.length)
                  ? (dat == g + _words1.length) && (dat != g)
                  : ((dat + _words1.length) == g) && (dat != g);
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
      items.add(item);
    }
    return items;
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
class TheCard extends StatefulWidget {
  const TheCard({
    Key? key,
    required this.sizeX,
    required this.sizeY,
    required this.color,
    required this.text,
    required this.imgtag,
  }) : super(key: key);
  final double sizeX;
  final double sizeY;
  final Color color;
  final String text;
  final String imgtag;

  @override
  State<TheCard> createState() => _TheCardState();
}

class _TheCardState extends State<TheCard> {
  @override
  Widget build(BuildContext context) {
    double _animatedContainerHeight = 100;
    double _animatedContainerWidth = 100;
    return MouseRegion(
      /* onEnter: (_) => _showImg(
        context,
        imgtag,
        'logo1.png',
      ), */
      /* child: Hero(
        tag: imgtag, */
      onEnter: (value) {
        setState(() {
          _animatedContainerHeight = 100;
          _animatedContainerWidth = 150;
        });
      },
      onExit: (value) {
        setState(() {
          _animatedContainerHeight = 100;
          _animatedContainerWidth = 100;
        });
      },
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: _animatedContainerHeight,
        width: _animatedContainerWidth,
        child:

            //
            Card(
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
          //),
          //),
        ),
      ),
    );
  }
}

void _showImg(BuildContext context, String _tag, String _imgname) {
  //heroed = true;
  final Orientation _orientation = MediaQuery.of(context).orientation;
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => Scaffold(
        body: SafeArea(
          child: Center(
            /* child: Hero(
                tag: _imgname, */
            child: Flex(
              direction: _orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      //heroed = false;
                      Navigator.of(context).pop();
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(
                            _imgname,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            //),
          ),
        ),
      ),
    ),
  );
}
