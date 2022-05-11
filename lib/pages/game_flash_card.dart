import 'dart:ffi';

import 'package:flutter/material.dart';

class GameFlashCard extends StatefulWidget {
  const GameFlashCard({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameFlashCard> createState() => _GameFlashCardState();
}

class _GameFlashCardState extends State<GameFlashCard> {
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.ice_skating,
      size: 100,
    );
  }
}
