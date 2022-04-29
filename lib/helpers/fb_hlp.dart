import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;

@override
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
        '${_doc['myclas'] as String} ${_doc['myfio'] as String} ${_doc['mymail'] as String}',
      )
      .collection('vars')
      .get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //debugPrint(allData.toString());
  return allData;
}

Future<List<Object?>> getUsersFS() async {
  // Get docs from collection reference
  final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('modules').get();
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
