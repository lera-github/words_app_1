import 'package:flutter/material.dart';

class GameMatch extends StatefulWidget {
  const GameMatch({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  State<GameMatch> createState() => _GameMatchState();
}

class _GameMatchState extends State<GameMatch> {
// Key and Size of the widget
  final _areaKey = GlobalKey();
  Size? _areaSize;
  List<int> positions = [];
  // This function is triggered when the floating button is pressed
  // You can trigger it by using other events
  void _getSize() {
    setState(() {
      _areaSize = _areaKey.currentContext!.size;
    });
  }

  void draw() async {
    // 1
    if (positions.length == 0) {
      positions.add(getRandomPositionWithinRange());
    }

    // 2
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    // 3
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    // 4
    positions[0] = await getNextPosition(positions[0]);
  }

  Widget getControls() {
    return ControlPanel(
      // 1
      onTapped: (Direction newDirection) {
        // 2
        direction = newDirection; // 3
      },
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    //draw();
    //drawFood();

    // 1
    for (var i = 0; i < length; ++i) {
      // 2
      if (i >= positions.length) {
        continue;
      }

      // 3
      pieces.add(
        Piece(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          // 4
          size: step,
          color: Colors.red,
        ),
      );
    }

    return pieces;
  }

  @override
  Widget build(BuildContext context) {
    _getSize();
    final areaWidth = _areaSize!.width;
    final areaHeight = _areaSize!.height;
    return Scaffold(
      body: Container(
        color: Color(0XFFF5BB00),
        child: Stack(
          children: [
            Stack(
              children: getPieces(),
            ),
            getControls(),
          ],
        ),
      ),
    );
  }
}

// виджет карточки
class Piece extends StatefulWidget {
  const Piece(
      {Key? key,
      required this.posX,
      required this.posY,
      required this.size,
      required this.color})
      : super(key: key);
  final int posX;
  final int posY;
  final int size;
  final Color color;

  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> {
  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.gps_fixed_outlined);
  }
}
