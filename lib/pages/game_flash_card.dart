import 'package:auto_size_text/auto_size_text.dart';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';

List _words1 = []; //массивы слов
List _words2 = [];

class GameFlashCard extends StatefulWidget {
  const GameFlashCard({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameFlashCard> createState() => _GameFlashCardState();
}

class _GameFlashCardState extends State<GameFlashCard> {
/*   @override
  void initState() {
    super.initState();
    _words1 = widget.mapdata['words1'] as List;
    _words2 = widget.mapdata['words2'] as List;
  } */

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
        height: 200,
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: ListView.builder(
              itemCount: flashCard.length,
              itemBuilder: (context, index) {
                return flashCard[index];
              },
            ),
          ),
        ),
      ),
    );
  }
}
