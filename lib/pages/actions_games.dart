import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/game_flash_card.dart';
import 'package:myapp/pages/game_match.dart';

String actionSelect = '';

class ActionsAndGames extends StatefulWidget {
  const ActionsAndGames({Key? key, required this.mapdata}) : super(key: key);
  final Map<String, dynamic> mapdata;

  @override
  _ActionsAndGamesState createState() => _ActionsAndGamesState();
}

class _ActionsAndGamesState extends State<ActionsAndGames> {
  // the GlobalKey is needed to animate the list

  @override
  Widget build(BuildContext context) {
    final _scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 220),
        actions: [
          const SizedBox(
            width: 20,
          ),
          Align(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Text(
                'Memory Games',
                style: titleStyle,
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //здесь можно кнопки положить (см. как в module_list например)
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints.expand(width: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    TextButton(
                      onPressed: () {
                        actionSelect = 'GameFlashCard';
                        setState(() {});
                      },
                      child: Text(
                        'Карточки',
                        style: titleStyle,
                        textScaleFactor: 0.7,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        actionSelect = 'GameMatch';
                        setState(() {});
                      },
                      child: Text(
                        'Подбор',
                        style: titleStyle,
                        textScaleFactor: 0.7,
                      ),
                    )
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.expand(width: _scrwidth),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            widget.mapdata['favourite'] as bool
                                ? Icons.star_rate_rounded
                                : Icons.star_border_rounded,
                            color: widget.mapdata['favourite'] as bool
                                ? Colors.yellow.shade600
                                : Colors.grey.shade400,
                          ),
                          Expanded(
                            child: AutoSizeText(
                              widget.mapdata['module'] as String,
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          widget.mapdata['description'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                        ),
                      ),
                    ),
                    Expanded(
                      child:
/////////////////////////////////////////////////////////////////////   сюда идет поле игры
                          /// Icon   - это для примера
                          ///
                          actionSelector(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.playlist_add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => _insertSingleItem(),
      ), */
    );
  }

  Widget actionSelector() {
    switch (actionSelect) {
      case 'GameFlashCard':
        return GameFlashCard(mapdata: widget.mapdata);
      case 'GameMatch':
        return GameMatch(mapdata: widget.mapdata);
      default:
        GameFlashCard(mapdata: widget.mapdata);
    }
    return GameFlashCard(mapdata: widget.mapdata);
  }
}
