import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:egetest/firebase_options.dart';
import 'package:egetest/globals.dart' as globals;
import 'package:egetest/helpers/db_hlp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;

@override
Future<void> initializeFBS() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

//CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void> deleteUser(Map<String, dynamic> _doc) async {
  //удаление документа var
  await FirebaseFirestore.instance
      .collection('users')
      .doc(
        '${_doc['myclas'] as String} ${_doc['myfio'] as String} ${_doc['mymail'] as String}',
      )
      .collection('vars')
      .get()
      .then((value) {
    for (final element in value.docs) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(
            '${_doc['myclas'] as String} ${_doc['myfio'] as String} ${_doc['mymail'] as String}',
          )
          .collection('vars')
          .doc(element.id)
          .delete();
    }
  });
  //удаление документа user
  await FirebaseFirestore.instance
      .collection('users')
      .doc(
        '${_doc['myclas'] as String} ${_doc['myfio'] as String} ${_doc['mymail'] as String}',
      )
      .delete();
}

Future<List<Object?>> getUsersVarsFS(Map<String, dynamic> _doc) async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(
          '${_doc['myclas'] as String} ${_doc['myfio'] as String} ${_doc['mymail'] as String}',)
      .collection('vars')
      .get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //debugPrint(allData.toString());
  return allData;
}

Future<List<Object?>> getUsersFS() async {
  await initializeFBS();
  // Get docs from collection reference
  final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

Future<void> updateUsersFS({
  required String parentdoc,
  required String doc,
  required String val,
  required bool valdata,
}) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(parentdoc)
      .collection('vars')
      .doc(doc)
      .update({val: valdata});
  /* .then((value) => print("User Updated"))
      .catchError((e) => print("Failed to update user: $e")); */
}

Future<void> initUserFS() async {
  await initializeFBS();
//     ЗАПИСЬ ИЗ БД В  FIREBASE ВСЕХ ФАЙЛОВ
  final String _prefx =
      'var${((globals.myindex + 1) < 10) ? '0' : ''}${globals.myindex + 1}';
  const String _postfx = '.webm'; //kIsWeb ? '.webm' : '.mp4';
  final List<String> _listfname = [
    '_task1_q1',
    '_task2_q1',
    '_task2_q2',
    '_task2_q3',
    '_task2_q4',
    '_task3_q1',
    '_task3_q2',
    '_task3_q3',
    '_task3_q4',
    '_task3_q5',
    '_task4_q1',
  ];

  final List<String> _filename = [];
  for (int i = 0; i < 11; i++) {
    final _buf = await getDB(_prefx + _listfname[i] + _postfx);
    //генератор имени файла
    final _generatedfilename = md5
        .convert(utf8.encode(DateTime.now().millisecondsSinceEpoch.toString()))
        .toString();
    //_filename!.add(await getDB(_prefx + _listfname[i] + _postfx));
    if (_buf != null) {
      _filename.add(_generatedfilename); //_buf
      //uploads(_prefx + _listfname[i] + _postfx);
      //запись файла
      await toFBS(
        _generatedfilename,
        _buf as Uint8List,
      );
    } else {
      _filename.add('');
    }
  }

  final Map<String, dynamic> idData = {
    'myfio': globals.myfio,
    'myclas': globals.myclas,
    'mymail': globals.mymail
  };
  final Map<String, dynamic> varsData = {
    'var': '${((globals.myindex + 1) < 10) ? '0' : ''}${globals.myindex + 1}',
    '_task1_q1': false,
    '_task2_q1': false,
    '_task2_q2': false,
    '_task2_q3': false,
    '_task2_q4': false,
    '_task3_q1': false,
    '_task3_q2': false,
    '_task3_q3': false,
    '_task3_q4': false,
    '_task3_q5': false,
    '_task4_q1': false,
    'audio_task1_q1': _filename[0],
    'audio_task2_q1': _filename[1],
    'audio_task2_q2': _filename[2],
    'audio_task2_q3': _filename[3],
    'audio_task2_q4': _filename[4],
    'audio_task3_q1': _filename[5],
    'audio_task3_q2': _filename[6],
    'audio_task3_q3': _filename[7],
    'audio_task3_q4': _filename[8],
    'audio_task3_q5': _filename[9],
    'audio_task4_q1': _filename[10]
  };

  await FirebaseFirestore.instance
      .collection('users')
      .doc('${globals.myclas} ${globals.myfio} ${globals.mymail}')
      .set(idData);
  await FirebaseFirestore.instance
      .collection('users')
      .doc('${globals.myclas} ${globals.myfio} ${globals.mymail}')
      .collection('vars')
      .doc(
        'var${((globals.myindex + 1) < 10) ? '0' : ''}${globals.myindex + 1}',
      )
      .set(varsData);
}

//извлечение из БД и запись в Firebase Storage
/* Future<void> uploads(String _fname) async {
  await initializeFBS();
  final _bytes = await getDB(_fname);
  if (_bytes != null) {
    await toFBS(
      _fname,
      _bytes as Uint8List,
    );
  }
} */

Future<void> toFBS(String name, Uint8List data) async {
/*   // имя файла
  String _path = '/${globals.myclas} ${globals.myfio}-$name';
  if ((globals.myclas == '') & (globals.myfio == '')) {
    _path = '/~temp-$name';
  }
  final fbs.Reference ref = fbs.FirebaseStorage.instance.ref(_path); */
  final fbs.Reference ref = fbs.FirebaseStorage.instance.ref(name);
  try {
    // Upload raw data.
    await ref.putData(data);
    // Get raw data.
    //final Uint8List? downloadedData = await ref.getData();

  } on fbs.FirebaseException catch (e) {
    // e.g,
    if (e.code == 'canceled') {}
    //print('toFBS error: $e');
  }
}

Future<Uint8List?> fromFBS(String _path) async {
  final fbs.Reference ref = fbs.FirebaseStorage.instance.ref(_path);
  try {
    // Upload raw data.
    //await ref.putData(data);
    // Get raw data.
    final Uint8List? downloadedData = await ref.getData();

    //debugPrint(downloadedData.toString());

    return downloadedData;
  } on fbs.FirebaseException catch (e) {
    // e.g,
    if (e.code == 'canceled') {}
    //print('fromFBS error: $e');
  }
  return null;
}

/* Future<List<fbs.Reference>> tstCount({required bool isfile}) async {
  if (!isfile) {
    globals.mydir = '';
  }
  final fbs.ListResult result =
      await fbs.FirebaseStorage.instance.ref('/${globals.mydir}').listAll();
  return isfile ? result.items.toList() : result.prefixes.toList();
  //result.prefixes.length;
}
 */
/* Future<String> getURL(String _path) async {
  final fbs.Reference ref = fbs.FirebaseStorage.instance.ref().child(_path);
  final String url = await ref.getDownloadURL();
  return url;
}

Future<void> listExample() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fbs.ListResult result =
      await fbs.FirebaseStorage.instance.ref().listAll();
  //await fbs.FirebaseStorage.instance.ref().list(const fbs.ListOptions(maxResults: 10, ));

  for (final ref in result.items) {
    debugPrint('Found file: ${ref.name}');
  }

  for (final ref in result.prefixes) {
    debugPrint('Found directory: ${ref.name}');
    debugPrint(result.prefixes.length.toString());
  }
}  */
