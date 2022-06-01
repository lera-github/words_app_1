import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/pages/game_flash_card.dart';

List _words1 = []; //массивы слов
List _words2 = [];
int index = 0;

class GameMemorise extends StatefulWidget {
  const GameMemorise({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameMemorise> createState() => _GameMemoriseState();
}

class _GameMemoriseState extends State<GameMemorise> {
  final _random = Random();
  @override
  void initState() {
    super.initState();
    index = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
    //final List<int> _list = List.generate(_words1.length, (index) => index++, growable: false);
    //_list.shuffle();

    Card _fourCards(int idx) {
      //_list.shuffle();
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
            height: 80, //size
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
        ),
      );
    }

    final List<Widget> flashCard = List.generate(
      _words1.length,
      (index) {
        final int _answerindex =
            _random.nextInt(4); //в какой карточке будет ответ
        return Column(
          children: [
            SizedBox(
              height: 80,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_fourCards(0), _fourCards(1)], //_answerindex==0 ? :
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_fourCards(2), _fourCards(3)],
            ),
          ],
        );
      },
    );

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
              // Use a Builder here, otherwise DefaultTabController.of(context) below
              // returns null.
              child: Builder(
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const TabPageSelector(),
                      const SizedBox(
                        height: 18,
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
                                setState(() {
                                  index--;
                                  if (index < 0) {
                                    index = flashCard.length - 1;
                                  }
                                });

                                final TabController controller =
                                    DefaultTabController.of(context)!;
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
                                setState(() {
                                  index++;
                                  if (index > flashCard.length - 1) {
                                    index = 0;
                                  }
                                });

                                final TabController controller =
                                    DefaultTabController.of(context)!;
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
                ),
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
