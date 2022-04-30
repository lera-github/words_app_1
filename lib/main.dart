import 'package:flutter/material.dart';
import 'package:myapp/helpers/appbarmenu.dart';
import 'package:myapp/pages/module_list.dart';
import 'helpers/styles.dart';
import 'pages/modules.dart';
import 'pages/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Games',
      /* theme: ThemeData(
        primarySwatch: Colors.green,
      ), */
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

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //
            SizedBox(
              height: 56,
              child: Container(
                color: upBarColor,
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Memory Games',
                      style: titleStyle,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LibButton(),
                            SizedBox(
                              width: 20,
                            ),
/*                             LibMenu(),
                            SizedBox(
                              width: 20,
                            ),
                            CreateMenu(),
                            SizedBox(
                              width: 20,
                            ), */
                            MyMenu(),
                          ]),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            //
            SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                /* decoration: const BoxDecoration(
                        color: Color.fromRGBO(0xFF, 0xFF, 0xF5, 0x9D),
                    ), */
                child: ModuleList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
