import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/helpers/appbarmenu.dart';
import 'package:myapp/helpers/styles.dart';
import 'package:myapp/pages/module_list.dart';

Future<void> main() async {
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Games',
      home: MyHomePage(),
      /* theme: ThemeData(
        primarySwatch: Colors.green,
      ), */
      /* routes: {
        '/': (BuildContext context) => const MyHomePage(),
        '/ProfileScreen': (BuildContext context) => const Profile(),
        '/ModulesScreen': (BuildContext context) => const Modules(),
        // '/GamesScreen': (BuildContext context) => const Games(),
      }, */
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //final Orientation _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 220),
        actions: [
          const SizedBox(
            width: 20,
          ),
          Align(
            child: Text(
              'Memory Games',
              style: titleStyle,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                LibButton(),
                SizedBox(
                  width: 20,
                ),
                //MyMenu(),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                /* decoration: const BoxDecoration(
                        color: Color.fromRGBO(0xFF, 0xFF, 0xF5, 0x9D),
                    ), */
                child: const ModuleList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
