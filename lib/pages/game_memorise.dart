//import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/helpers/fb_hlp.dart';
import 'package:myapp/helpers/img_hlp.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/main.dart';

//слова
List _words1 = [];
List _words2 = [];
//имена файлов
List _imgs = [];
//карточки с картинками
List<FlashCard> imgCard = [];

int index = 0;
//final _random = Random();
//List<bool> _generated = [];

////карточки сформированы?
bool _cardsReady = false;
//List<int> shuffledindex = []; //массив перемешанных индексов

//массив массивов индексов
List<List<int>> _indexCards = [];
//показывать смайлики?
List<bool> _visFlag = [];

//массив очков по количеству терминов в модуле
List<int> _scores = [];
//массив признаков правильного ответа
List<bool> _scoresFinal = [];

class GameMemorise extends ConsumerStatefulWidget {
  const GameMemorise({
    Key? key,
    required this.mapdata,
    required this.usermapdata,
  }) : super(key: key);
  final Map<String, dynamic> mapdata;
  final Map<String, dynamic> usermapdata;

  @override
  ConsumerState<GameMemorise> createState() => _GameMemoriseState();
}

class _GameMemoriseState extends ConsumerState<GameMemorise> {
  @override
  void initState() {
    super.initState();
    index = 0;
    _cardsReady = false;
    _indexCards = [];
    //_generated = List.generate(_words1.length, (index) => false);
    //shuffledindex = [];
    imgCard.clear();
    _visFlag = [false, false, false, false];
    _scores.clear();
  }

  @override
  Future<void> dispose() async {
    imgCard.clear();
    // подсчет и запись суммы в FS
    var scoresSumm = 0;
    for (var i = 0; i < _scores.length; i++) {
      scoresSumm += _scores[i];
    }
    // если модуль не использовали или не набрали очков, то не записываем ничего
    if (scoresSumm > 0) {
      final scoresData = widget.usermapdata['scores'] as Map<String, dynamic>;
      scoresData[widget.mapdata['id'].toString()] = scoresSumm;
      await updateFS(
        collection: 'users',
        id: widget.usermapdata['userid'].toString(),
        val: 'scores',
        valdata: scoresData,
      );
      //final ggg = widget.mapdata['score'].toList ;
      int scoreData = 0;
// ===================================  посчет вынести еще на ссылки перехр\ода на модули и выход
// для отображения общего счета

      //просуммируем все очки и запишем в 'score' в FS
      widget.usermapdata['scores'].forEach((k, v) => scoreData += v as int);
      await updateFS(
        collection: 'users',
        id: widget.usermapdata['userid'].toString(),
        val: 'score',
        valdata: scoreData,
      );
    }
    _scores.clear();
    _scoresFinal.clear();
    super.dispose();
  }

  //=============================================================================
  @override
  Widget build(BuildContext context) {
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
    _imgs = widget.mapdata['imgs'] as List;
    bool haslisteners = false;
    //положим, что 3 очка дается за верный ответ,
    // а за каждое не попадание по ответу очко снимается
    if (_scores.isEmpty) {
      _scores = List.generate(_words1.length, (index) => 0);
      _scoresFinal = List.generate(_words1.length, (index) => false);
    }

    /* if (_generated.isEmpty) {
      _generated = List.generate(_words1.length, (index) => false);
    } */

    /* //проверка - должно быть >= 5 пар карточек, иначе диалог и выход
    if (_words1.length < 5) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          elevation: 1.2,
          backgroundColor: Colors.red.shade900,
          shape: RoundedRectangleBorder(
            side: const BorderSide(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: const Text(
                'Для этого модуля необходимо не менее 5 пар карточек!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                ),
              ),
            ),
            onTap: () {
              Navigator.pop(
                context,
              );
            },
          ),
        ),
      );
    } */

    if (!_cardsReady) {
      //индекс карточки
      for (int i = 0; i < _words1.length; i++) {
        //в какой карточке будет ответ (0-3)
        //final int _answerindexplace = _random.nextInt(4);
        //массив без текущего индекса карточки
        final List<int> shuffledindex = List.generate(
          _words1.length,
          (j) => j,
        );

        bool eqfl = false;
        do {
          //перемешать
          shuffledindex.shuffle();
          //первые 4 элемента проверяем на наличие индекса ответа

          for (int j = 0; j < 4; j++) {
            if (shuffledindex[j] == i) {
              eqfl = true;
            }
          }
        } while (!eqfl);
        //вставить по индексу _answerindexplace правильный ответ i
        //shuffledindex[_answerindexplace] = i;

        _indexCards.add([i]);
        _indexCards[i] = [
          shuffledindex[0],
          shuffledindex[1],
          shuffledindex[2],
          shuffledindex[3],
        ];
        //print(i.toString());
        //print(_indexCards[i].toString());

      }

      _cardsReady = true;
    }

    //final List<int> _list = List.generate(_words1.length, (index) => index++, growable: false);
    //_list.shuffle();
    //--------------------------------------------------------------

    // карточка
    Card cardX({
      required int idx,
      required bool visFlag,
    }) {
      //_list.shuffle();
      //var _visFlag = false;
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
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Container(
                height: 80,
                width: 300,
                padding: const EdgeInsets.all(6.0),
                alignment: Alignment.center,
                child: AutoSizeText(
                  idx < _words1.length ? _words1[idx] as String : '',
                  maxLines: 5,
                  wrapWords: false,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepPurple,
                  ),
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 8,
                ),
              ),
              Visibility(
                visible: visFlag,
                child: Container(
                  child: idx == index
                      ? const Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                          color: Colors.green,
                          size: 32,
                        )
                      : const Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          color: Colors.red,
                          size: 32,
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    //----------------------------------------------------------------------------
    // все карточки модуля в игровом поле
    final List<Widget> flashCard = List.generate(
      _words1.length,
      (ind) {
        return Column(
          children: [
            SizedBox(
              height: 40,
              child: Center(
                child: AutoSizeText(
                  _words2[index] as String,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  wrapWords: false,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 26,
                    //fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      //за каждое не попадание по ответу очко снимается
                      cardStates(0, ref);
                    });
                  },
                  child: cardX(
                    idx: _indexCards[index][0],
                    visFlag: _visFlag[0],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      cardStates(1, ref);
                    });
                  },
                  child: cardX(
                    idx: _indexCards[index][1],
                    visFlag: _visFlag[1],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      cardStates(2, ref);
                    });
                  },
                  child: cardX(
                    idx: _indexCards[index][2],
                    visFlag: _visFlag[2],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      cardStates(3, ref);
                    });
                  },
                  child: cardX(
                    idx: _indexCards[index][3],
                    visFlag: _visFlag[3],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (imgCard.isEmpty) {
      imgCard = List.generate(
        _words1.length,
        (index) => FlashCard(
          key: Key(index.toString()),
          frontWidget: Center(
            child: ImageLoader(
              imgName: _imgs[index] as String,
            ),
          ),
          backWidget: Center(
            child: Image.asset('placeholder.png'),
          ),
          height: 180,
          width: 280,
        ),
      );
    }

    //===================================
    return Scaffold(
      body: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: DefaultTabController(
              length: flashCard.length,
              child: Builder(
                builder: (BuildContext context) {
                  final TabController controller =
                      DefaultTabController.of(context)!;

                  if (!haslisteners) {
                    controller.addListener(() {
                      haslisteners = true;
                      setState(() {});
                    });
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        const TabPageSelector(),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: TabBarView(children: flashCard),
                        ),
                        SizedBox(
                          height: 130,
                          width: 180,
                          child: TabBarView(
                            children: imgCard,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: ElevatedButton(
                                onPressed: () {
                                  //--------------------------------------------------------------------------
                                  //updateScoresStates(ref);

                                  index--;
                                  if (index < 0) {
                                    index = flashCard.length - 1;
                                  }

                                  // показать смайлы, если ответы даны
                                  if (!_scoresFinal[index]) {
                                    _visFlag = [false, false, false, false];
                                  } else {
                                    _visFlag = [true, true, true, true];
                                  }

                                  if (!controller.indexIsChanging) {
                                    controller.animateTo(index);
                                  }
                                },
                                child: const Icon(
                                  Icons.arrow_back_outlined,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                            Text(
                              '${index + 1} / ${flashCard.length}',
                              style: textStyle,
                            ),
                            Transform.scale(
                              scale: 1.4,
                              child: ElevatedButton(
                                onPressed: () {
                                  //--------------------------------------------------------------------------
                                  //updateScoresStates(ref);
                                  index++;
                                  if (index > flashCard.length - 1) {
                                    index = 0;
                                  }

                                  // показать смайлы, если ответы даны
                                  if (!_scoresFinal[index]) {
                                    _visFlag = [false, false, false, false];
                                  } else {
                                    _visFlag = [true, true, true, true];
                                  }

                                  if (!controller.indexIsChanging) {
                                    controller.animateTo(index);
                                  }
                                },
                                child: const Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.yellow,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//обработка состояний и счет очков
void cardStates(int w, WidgetRef ref) {
  int cnt = 0; //счетчик промахов
  if (_indexCards[index][w] == index && !_scoresFinal[index]) {
    _scoresFinal[index] = true;
    for (var i = 0; i < 4; i++) {
      if (_visFlag[i]) cnt++;
    }
    _scores[index] = 3 - cnt;
  }
  _visFlag[w] = true;
  //print(_scores.toString());
  // обновление очков с каждым нажатием на карточку
  updateScoresStates(ref);
}

//обновление очков
void updateScoresStates(WidgetRef ref) {
  int summ = 0;
  for (var i = 0; i < _scores.length; i++) {
    summ += _scores[i];
  }
  ref.watch(scoresProvider.notifier).updateModuleScores(summ);
}
