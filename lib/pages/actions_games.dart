import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/fb_hlp.dart';
import 'package:myapp/helpers/other_hlp.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/game_flash_card.dart';
import 'package:myapp/pages/game_match.dart';
import 'package:myapp/pages/game_memorise.dart';

String actionSelect = '';

class ActionsAndGames extends StatefulWidget {
  const ActionsAndGames({
    Key? key,
    required this.collectionPath,
    required this.userid,
    required this.mapdata,
  }) : super(key: key);
  final String collectionPath;
  final String userid;
  final Map<String, dynamic> mapdata;

  @override
  _ActionsAndGamesState createState() => _ActionsAndGamesState();
}

class _ActionsAndGamesState extends State<ActionsAndGames> {
  // the GlobalKey is needed to animate the list

  @override
  Widget build(BuildContext context) {
    final scrwidth = MediaQuery.of(context).size.width < 800.0
        ? MediaQuery.of(context).size.width
        : 800.0;
    final scrheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 255, 255, 220),
        actions: [
          const SizedBox(
            width: 20,
          ),
          Align(
            child: TTip(
              message: 'На домашнюю страницу...',
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
                      builder: (context) => MyHomePage(
                        collectionPath: widget.collectionPath,
                        userid: widget.userid,
                      ),
                    ),
                  );
                },
              ),
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
                      height: 59,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: const [
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                          // Карточки
                          TextButton(
                            onPressed: () {
                              setState(() {
                                actionSelect = 'GameFlashCard';
                              });
                            },
                            child: Text(
                              'Карточки',
                              style: titleStyle,
                              textScaleFactor: 0.7,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          // Заучивание
                          TextButton(
                            onPressed: () {
                              setState(() {
                                actionSelect = 'GameMemorise';
                              });
                            },
                            child: Text(
                              'Заучивание',
                              style: titleStyle,
                              textScaleFactor: 0.7,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          // Подбор
                          TextButton(
                            onPressed: () {
                              setState(() {
                                actionSelect = 'GameMatch';
                              });
                            },
                            child: Text(
                              'Подбор',
                              style: titleStyle,
                              textScaleFactor: 0.7,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: const [
                              SizedBox(
                                height: 6,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('check.png'),
                              const Text('  рейтинг:'),
                            ],
                          ),
                          ////////                                       //  лист рейтинга
                          SizedBox(
                            height: scrheight - 323 > 40 ? scrheight - 323 : 40,
                            child: /* Container(
                              padding: const EdgeInsets.all(6),
                              child:  */
                                const Rating(),
                            //),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              ConstrainedBox(
                constraints: BoxConstraints.expand(width: scrwidth),
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
                          /* Icon(
                            widget.mapdata['favourite'] as bool
                                ? Icons.star_rate_rounded
                                : Icons.star_border_rounded,
                            color: widget.mapdata['favourite'] as bool
                                ? Colors.yellow.shade600
                                : Colors.grey.shade400,
                          ), */
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
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: actionSelector(), // виджет игр
                    ),
                    const SizedBox(
                      height: 10,
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
      //break;
      case 'GameMemorise':
        return GameMemorise(mapdata: widget.mapdata);
      case 'GameMatch':
        return GameMatch(mapdata: widget.mapdata);
      default:
        return GameFlashCard(mapdata: widget.mapdata);
    }
  }
}

// =================================================================== рейтинг
class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCollectionFS(
        collection: 'users',
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 40,
            ),
          );
          //CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          // List<Map<String, dynamic>> _tmp = [];
          /////////////GENERATE вставить
          return ListViewBuilder(maplist: snapshot.data!);
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return const SizedBox();
      },
    );
  }
}

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key, required this.maplist}) : super(key: key);
  final List<Object?> maplist;
  @override
  Widget build(BuildContext context) {
    final numItems = maplist.length;
    Map<String, dynamic> mapitem;
    //final listUserCollection = maplist as List<Map<String, dynamic>?>;
    Widget buildRow(int idx) {
      mapitem = maplist[idx]! as Map<String, dynamic>;
      return ListTile(
        leading: CircleAvatar(
          maxRadius: 10,
          child: Text(
            '${idx + 1}',
            //textScaleFactor: 0.8,
          ),
        ),
        title: Text(
          mapitem['username'].toString(),
          //textScaleFactor: 0.5,
        ),
        trailing: Text(
          mapitem['score'].toString(),
          //textScaleFactor: 0.5,
        ),
      );
    }

    return ListView.builder(
      itemCount: numItems * 2,
      padding: const EdgeInsets.all(3.0),
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        return buildRow(index);
      },
    );
  }
}
