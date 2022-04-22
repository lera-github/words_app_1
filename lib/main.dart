import 'package:flutter/material.dart';
import 'package:myapp/pages/profile.dart';
import 'package:myapp/pages/modules.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Games',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/': (BuildContext context) => const MyHomePage(title: 'Memory Games'),
        '/ProfileScreen': (BuildContext context) => const Profile(),
        '/ModulesScreen': (BuildContext context) => const Modules(),
      // '/GamesScreen': (BuildContext context) => const Games(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final Orientation _orientation = MediaQuery.of(context).orientation;
    final TextStyle titleStyle = TextStyle(
      color: Colors.green.shade700,
      fontSize: 36.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontFamily: 'Georgia',
      shadows: const <Shadow>[
        Shadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 1.0,
        ),
        Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: Colors.lightGreen,
        ),
      ],
    );

    // стиль кнопок
    final ButtonStyle btnstyle = ElevatedButton.styleFrom(
      textStyle: TextStyle(
        color: Colors.blue.shade100,
        fontSize: 26.0,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: 'Roboto',
        shadows: const <Shadow>[
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
          ),
        ],
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
           color: Color.fromRGBO(0xFF, 0xFF, 0xF5, 0x9D), 
          ),
          child: Flex(
            direction: _orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Column(
                        children: [
                          const Spacer(flex: 4),
                          Expanded(
                            flex: 20,
                            child: Text(
                              'Memory Games',
                              style: titleStyle,
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 20,
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(flex: 10),
// пункт меню 1
                    Expanded(
                      flex: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            style: btnstyle,
                            onPressed: () {
                              Navigator.pushNamed(context, '/ProfileScreen');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.settings_applications_outlined,
                                    color: Colors.green.shade600,
                                    size: 36,
                                  ),
                                ),
                                const Text('Profile')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
// пункт меню 2
                    Expanded(
                      flex: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            style: btnstyle,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/ModulesScreen',
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.wysiwyg_rounded,
                                    color: Colors.green.shade600,
                                    size: 36,
                                  ),
                                ),
                                const Text('Modules')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
// пункт меню 3
                    Expanded(
                      flex: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(
                            style: btnstyle,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/GamesScreen',
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 10.0,
                                  ),
                                  child: Icon(
                                    Icons.widgets_outlined,
                                    color: Colors.green.shade600,
                                    size: 36,
                                  ),
                                ),
                                const Text('Games')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
