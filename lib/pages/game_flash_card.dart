import 'package:flutter/material.dart';

class GameFlashCard extends StatefulWidget {
  const GameFlashCard({Key? key}) : super(key: key);
  static const String title = 'Flutter Code Sample';
//  final Map<String, dynamic> mapdata;
  @override
  State<GameFlashCard> createState() => GameFlashCardState();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: const StatelessWidget(),
        ),
    );
  }
}

/* class GameFlashCardState extends State<GameFlashCard> {
  @override
  Widget build(BuildContext context) {

  } */

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            debugPrint('Card tapped.');
          },
          child: const SizedBox(
            width: 300,
            height: 100,
            child: Text('A card that can be tapped'),
          ),
        ),
      ),
    );
  }
}



