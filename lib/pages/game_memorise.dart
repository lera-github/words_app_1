import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:myapp/helpers/styles.dart';

List _words1 = []; //массивы слов
List _words2 = [];
int index = 0;
final _random = Random();
//List<bool> _generated = []; //карточки сформированы?
bool _cardsReady = false;
//List<int> _shuffledindex = []; //массив перемешанных индексов
List<List<int>> _indexCards = [];
List<bool> _visFlag = [];

class GameMemorise extends StatefulWidget {
  const GameMemorise({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameMemorise> createState() => _GameMemoriseState();
}

class _GameMemoriseState extends State<GameMemorise> {
  @override
  void initState() {
    super.initState();
    index = 0;
    _cardsReady = false;
    _indexCards = [];
    //_generated = List.generate(_words1.length, (index) => false);

    //_shuffledindex = [];

    _visFlag = [false, false, false, false];
  }

//=============================================================================
  @override
  Widget build(BuildContext context) {
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
    bool _hasListeners = false;
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
        final List<int> _shuffledindex = List.generate(
          _words1.length,
          (j) => j,
        );

        bool eqfl = false;
        do {
          //перемешать
          _shuffledindex.shuffle();
          //первые 4 элемента проверяем на наличие индекса ответа

          for (int j = 0; j < 4; j++) {
            if (_shuffledindex[j] == i) {
              eqfl = true;
            }
          }
        } while (eqfl);
        //вставить по индексу _answerindexplace правильный ответ i
        //_shuffledindex[_answerindexplace] = i;

        _indexCards.add([i]);
        _indexCards[i] = [
          _shuffledindex[0],
          _shuffledindex[1],
          _shuffledindex[2],
          _shuffledindex[3],
        ];
        //print(i.toString());
        //print(_indexCards[i].toString());

      }

      _cardsReady = true;
    }

    //final List<int> _list = List.generate(_words1.length, (index) => index++, growable: false);
    //_list.shuffle();
    //--------------------------------------------------------------
    Card _card({
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
    final List<Widget> flashCard = List.generate(
      _words1.length,
      (ind) {
        return Column(
          children: [
            SizedBox(
              height: 80,
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
                      _visFlag[0] = true;
                    });
                  },
                  child: _card(
                    idx: _indexCards[index][0],
                    visFlag: _visFlag[0],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _visFlag[1] = true;
                    });
                  },
                  child: _card(
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
                      _visFlag[2] = true;
                    });
                  },
                  child: _card(
                    idx: _indexCards[index][2],
                    visFlag: _visFlag[2],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _visFlag[3] = true;
                    });
                  },
                  child: _card(
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

                  if (!_hasListeners) {
                    controller.addListener(() {
                      _hasListeners = true;
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: ElevatedButton(
                                onPressed: () {
                                  index--;
                                  if (index < 0) {
                                    index = flashCard.length - 1;
                                  }
                                  _visFlag = [false, false, false, false];

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
                                  index++;
                                  if (index > flashCard.length - 1) {
                                    index = 0;
                                  }
                                  _visFlag = [false, false, false, false];

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
