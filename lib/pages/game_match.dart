import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/helpers/fb_hlp.dart';
import 'package:myapp/helpers/img_hlp.dart';
import 'package:myapp/helpers/other_hlp.dart';
import 'package:myapp/main.dart';
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

//массив очков по количеству терминов в модуле
List<int> _scores = [];
//массив признаков правильного ответа
//List<bool> _scoresFinal = [];
bool _timerActive = false;
// начальное значение начисляемых очков (увеличенное на 1)
int _timerScores = 4;
//делим время на 4 части и даем по 3-2-1-0 очков в зависимости от того какая часть времени идет сейчас

class GameMatch extends ConsumerStatefulWidget {
  const GameMatch({
    Key? key,
    required this.mapdata,
    required this.usermapdata,
  }) : super(key: key);
  final Map<String, dynamic> mapdata;
  final Map<String, dynamic> usermapdata;

  @override
  ConsumerState<GameMatch> createState() => _GameMatchState();
}

class _GameMatchState extends ConsumerState<GameMatch> {
// Key and Size of the widget

  final _random = Random();
  var _area = Size.zero; // размер области размещения карточек

  bool _offstage = true;
  // признаки обработанных карточек (совпадение установлено)
  List<bool> isDropped = [];

  //признак показа картинки
  List<bool> isVisImg = [];

  Timer? timer;
  int countdown = 0; //счетчик обратного отсчета
  int start = 0; // храним начальное значение этого счетчика

  void startTimer() {
    timer?.cancel();
    _timerActive = true;
    timer = null;
    final start = countdown;
    _timerScores = 4;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        if (countdown == 0) {
          timer?.cancel();
          //_timerActive = false;
        } else {
          countdown--;
          //debugPrint('$countdown ${countdown % (count ~/ 4)}');
          //уменьшаем число зарабатываемых очков в течением времени
          if (countdown % (start ~/ 4) == 0) {
            _timerScores--;
          }
        }
        ref
            .watch(scoresProvider.notifier)
            .updateTimer(n: countdown, m: _timerActive);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
    _imgs = widget.mapdata['imgs'] as List;
    isDropped = List<bool>.generate(_words1.length * 2, (index) => false);
    isVisImg = List<bool>.generate(_words1.length * 2, (index) => false);

    getMyCards();
    start = 0;
    countdown = _words1.length * 5; // по пять сукунд на термин
  }

  @override
  void dispose() {
    timer?.cancel();
    _timerActive = false;
    // подсчет и запись суммы в FS
    var scoresSumm = 0;
    for (var i = 0; i < _scores.length; i++) {
      scoresSumm += _scores[i];
    }
    // если игру не использовали или не набрали очков, то не записываем ничего
    if (scoresSumm > 0) {
      final scoresData = widget.usermapdata['scores'] as Map<String, dynamic>;
      List t = [0, 0];
      if (scoresData[widget.mapdata['id'].toString()] != null) {
        t = scoresData[widget.mapdata['id'].toString()] as List;
      }
      t[1] = scoresSumm;
      scoresData[widget.mapdata['id'].toString()] = t;
      //просуммируем все очки юзера и запишем в 'score' FS
      int scoreData = 0;
      scoresData.forEach(
        (k, v) {
          scoreData += (v as List)[0] as int;
          scoreData += v[1] as int;
        },
      );
      updateFS(
        collection: 'users',
        id: widget.usermapdata['userid'].toString(),
        val: 'score',
        valdata: scoreData,
      );
      retScore = scoreData;

      updateFS(
        collection: 'users',
        id: widget.usermapdata['userid'].toString(),
        val: 'scores',
        valdata: scoresData,
      );
    }
    _scores.clear();

    myCards.clear();
    super.dispose();
  }

///////////////  ===================== инициализируем провайдер данными из FS
  void scoresInit(int index) {
    final scoresData = widget.usermapdata['scores'] as Map<String, dynamic>;
    /* scoresData.isEmpty
          ? ref.read(scoresProvider.notifier).updateModuleScores(0)
          : ref.read(scoresProvider.notifier).updateModuleScores(
                scoresData[widget.mapdata['id'].toString()] as int,
              ); */
    if (scoresData.isEmpty ||
        scoresData[widget.mapdata['id'].toString()] == null) {
      ref.read(scoresProvider.notifier).updateModuleScores(0);
    } else {
      final t = scoresData[widget.mapdata['id'].toString()] as List;
      ref.read(scoresProvider.notifier).updateModuleScores(
            t[index] as int,
          );
    }
    ref.read(scoresProvider.notifier).updateUserScores(
          retScore,
        );
    updateScoresStates(ref);
  }

  Future<List<Widget>> getMyCards() async {
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
          imgtag: i.toString(),
        ),
      );
      pos = cardNewPos(cardSizeX, cardSizeY);
      /* if (i < _words1.length) {
         _imgsBytes.add(
          await  getImg(
            getImgName: _imgs[i] as String,
          ),
        );
      } */
    }

    return myCards;
  }

  //получение случайных координат в области (sx-6
  //где 6 - отступ от нижнего, правого края)
  Offset cardNewPos(double sx, double sy) {
    return Offset(
      (_random.nextDouble() * (_area.width - sx - 6)).abs(),
      (_random.nextDouble() * (_area.height - sy - 6)).abs(),
    );
  }

  // размещаем карточки
  List<Widget> dragItems() {
    final List<Positioned> items = [];
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
                onDragStarted: () {
                  //  старт таймера   ================================
                  if (!_timerActive) {
                    startTimer();
                  }
                  if (!isVisImg[g] &&
                      _imgs[g % _words1.length] != 'placeholder.png') {
                    setState(() {
                      isVisImg[g] = true;
                    });

                    Future.delayed(
                      const Duration(seconds: 3),
                      () {
                        if (mounted) {
                          setState(() {
                            isVisImg[g] = false;
                          });
                        }
                      },
                    );
                  }
                },
                onDragEnd: (_) {
                  setState(() {
                    isVisImg[g] = false;
                  });
                },
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
                  _scores[g] = _timerScores;
                  scoresInit(1);
                } else {
                  isDropped[g] = true;
                  isDropped[g - _words1.length] = true;
                  _scores[g - _words1.length] = _timerScores;
                  scoresInit(1);
                }
              });
            },
          ),
        ),
      );
      items.add(item);
      //

      //пробуем разложить изображения ===============================================
      /* final Positioned itemImg = Positioned(
        top: _points[g].dy + 20,
        left: _points[g].dx + 30,
        child: Visibility(
          visible: isDropped[g],
          child: SizedBox(
            height: 30,
            child: Image.asset('logo1.png'),
          ),
        ),
      );

      //
      items.add(itemImg); */
    }

    // картинки положим сверху
    for (var g = 0; g < _words1.length * 2; g++) {
      /* return Offset(
      (_area.width - cardSizeX)
      (_random.nextDouble() * (_area.height - sy)).abs(), */
      double sx = _points[g].dx - 200;
      double sy = _points[g].dy - 160;
      if (_points[g].dx < _area.width / 2) {
        sx = _points[g].dx + cardSizeX;
      }
      if (_points[g].dy < _area.height / 2) {
        sy = _points[g].dy + cardSizeY;
      }
      final Positioned item = Positioned(
        top: sy,
        left: sx,
        child: Visibility(
          visible: isVisImg[g],
          child: SizedBox(
            height: 160,
            width: 200,
            child: Center(
              child: /* Image.memory(
                _imgsBytes[g % _words1.length],
                fit: BoxFit.cover,
              ), */
                  ImageLoader(
                imgName: _imgs[g % _words1.length] as String,
              ),
            ),
          ),
        ),
      );
      items.add(item);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (_scores.isEmpty) {
      _scores = List.generate(_words1.length, (index) => 0);
      //_scoresFinal = List.generate(_words1.length, (index) => false);
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (messageFl[2]) {
          showMessages(
            context: context,
            mytext:
                'Перетаскивай одну карточку на другую.\nОчки начисляются за скорость и точность!',
          );
          messageFl[2] = false;
        }
      },
      child: Scaffold(
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
      ),
    );
  }

//обновление очков
  void updateScoresStates(WidgetRef ref) {
    int summ = 0;
    for (var i = 0; i < _scores.length; i++) {
      summ += _scores[i];
    }
    ref.watch(scoresProvider.notifier).updateModuleScores(summ);

    var scoresSumm = 0;
    for (var i = 0; i < _scores.length; i++) {
      scoresSumm += _scores[i];
    }
    // если игру не использовали или не набрали очков, то не записываем ничего
    if (scoresSumm > 0) {
      final scoresData = widget.usermapdata['scores'] as Map<String, dynamic>;
      List t = [0, 0];
      if (scoresData[widget.mapdata['id'].toString()] != null) {
        t = scoresData[widget.mapdata['id'].toString()] as List;
      }
      t[1] = scoresSumm;
      scoresData[widget.mapdata['id'].toString()] = t;
      //просуммируем все очки юзера и запишем в 'score' FS
      int scoreData = 0;
      scoresData.forEach(
        (k, v) {
          //scoreData += (v as List<int>)[0];
          scoreData += (v as List)[0] as int;
          scoreData += v[1] as int;
        },
      );
      /* updateFS(
        collection: 'users',
        id: widget.usermapdata['userid'].toString(),
        val: 'score',
        valdata: scoreData,
      ); */
      retScore = scoreData;

      ref.watch(scoresProvider.notifier).updateUserScores(
            retScore,
          );
      ref
          .watch(scoresProvider.notifier)
          .updateTimer(n: countdown, m: _timerActive);
    }
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
    required this.imgtag,
  }) : super(key: key);
  final double sizeX;
  final double sizeY;
  final Color color;
  final String text;
  final String imgtag;

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

  /* void _showImg(BuildContext context, String _tag, String _imgname) {
    //heroed = true;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: /* SafeArea(
            child: Center(
              child: */
              SizedBox(
            height: 200,
            width: 160,
            child: Hero(
              tag: _imgname,
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
            ),
          ),
          /*    ),
          ), */
        ),
      ),
    );
  } */
}
