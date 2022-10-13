import 'package:auto_size_text/auto_size_text.dart';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';

List _words1 = []; //массивы слов
List _words2 = [];
int index = 0;

class GameFlashCard extends StatefulWidget {
  const GameFlashCard({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameFlashCard> createState() => _GameFlashCardState();
}

class _GameFlashCardState extends State<GameFlashCard> {
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
    final List<FlashCard> flashCard = List.generate(
      _words1.length,
      (index) => FlashCard(
        key: Key(index.toString()),
        frontWidget: Center(
          child: AutoSizeText(
            _words2[index] as String,
            textAlign: TextAlign.center,
            maxLines: 5,
            wrapWords: false,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        backWidget: Center(
          child: AutoSizeText(
            _words1[index] as String,
            textAlign: TextAlign.center,
            maxLines: 5,
            wrapWords: false,
            overflow: TextOverflow.ellipsis,
            minFontSize: 10,
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        width: 300,
      ),
    );

    return Scaffold(
      body: Center(
        child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child:
//
                  DefaultTabController(
                length: flashCard.length,
                // Use a Builder here, otherwise DefaultTabController.of(context) below
                // returns null.
                child: Builder(
                  builder: (BuildContext context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const TabPageSelector(),
                        SizedBox(
                          width: 320,
                          height: 220,
                          child: TabBarView(children: flashCard),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Transform.scale(
                              scale: 1.4,
                              child: ElevatedButton(
                                onPressed: () {
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

                            /* ElevatedButton(
                            onPressed: () {
                              final TabController controller =
                                  DefaultTabController.of(context)!;
                              if (!controller.indexIsChanging) {
                                controller.animateTo(flashCard.length - 1);
                              }
                            },
                            child: const Text('SKIP'),
                          ), */
                          ],
                        )
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
