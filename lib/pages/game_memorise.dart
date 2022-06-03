import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';

List _words1 = []; //массивы слов
List _words2 = [];
int index = 0;
final _random = Random();
bool _generated = false; //карточки сформированы?
List<int> _shuffledindex = []; //массив перемешанных индексов

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

    _generated = false;
    _shuffledindex = [];

    _visFlag = [false, false, false, false];
  }

//=============================================================================
  @override
  Widget build(BuildContext context) {
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;

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
      (index) {
        if (!_generated) {
          //индекс карточки
          final int _answerindex = index;
          //в какой карточке будет ответ (0-3)
          final int _answerindexplace = _random.nextInt(4);
          //массив без текущего индекса карточки
          _shuffledindex = List.generate(
            _words1.length - 1,
            (index) {
              if (index >= _answerindex) {
                return index + 1;
              } else {
                return index;
              }
            },
          );
          //перемешать
          _shuffledindex.shuffle();
          //вставить по индексу _answerindexplace правильный ответ _answerindex
          _shuffledindex[_answerindexplace] = _answerindex;
          _generated = true;
        }
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
                    //debugPrint((idx == index).toString());
                  },
                  child: _card(
                    idx: _shuffledindex[0],
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
                    idx: _shuffledindex[1],
                    visFlag: _visFlag[1],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //_card(_shuffledindex[2]),
                //_card(_shuffledindex[3])
                InkWell(
                  onTap: () {
                    setState(() {
                      _visFlag[2] = true;
                    });
                  },
                  child: _card(
                    idx: _shuffledindex[2],
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
                    idx: _shuffledindex[3],
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
        child: Container(
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
                  if (!controller.hasListeners) {
                    controller.addListener(() {
                      setState(() {
                        /* _generated = false;
                        _visFlag = [false, false, false, false]; */
                      });
                      print('ggg');
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
                                  //_list.shuffle();

                                  _generated = false;
                                  _visFlag = [false, false, false, false];
                                  index--;
                                  if (index < 0) {
                                    index = flashCard.length - 1;
                                  }

                                  /* final TabController controller =
                                      DefaultTabController.of(context)!; */
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
                                  //_list.shuffle();

                                  _generated = false;
                                  _visFlag = [false, false, false, false];
                                  index++;
                                  if (index > flashCard.length - 1) {
                                    index = 0;
                                  }

                                  /* final TabController controller =
                                      DefaultTabController.of(context)!; */
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

//
          //flashCard[1],
          /* ListView.builder(
              itemCount: flashCard.length,
              itemBuilder: (context, index) {
                return flashCard[index];
              },
            ), */
        ),
      ),
    );
  }
}
