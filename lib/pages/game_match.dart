import 'package:flutter/material.dart';

class GameMatch extends StatefulWidget {
  const GameMatch({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameMatch> createState() => _GameMatchState();
}

class _GameMatchState extends State<GameMatch> {
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.account_circle_outlined,
      size: 100,
    );
  }
}
