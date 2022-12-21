import 'dart:async';
import 'dart:typed_data' show Uint8List;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;

Future<List<Object?>> getFS({
  required String collection,
  required String order,
  required String userid,
}) async {
  // Get docs from collection reference
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(collection)
      .orderBy(order)
      .where('keys', arrayContainsAny: ['#', userid])
      /* .where(
        'public',
        isEqualTo: true,
      )
      .where(
        'userid',
        isEqualTo: 'lut4hDl8Jqv5uyaY6CDL', 
      )*/
      .get();
  //.catchError((error) => print("$error"));
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

Future<List<Object?>> getCollectionFS({
  required String collection,
  required String order,
  required bool desc,
  required int limit,
}) async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(collection)
      .limit(limit)
      .orderBy(order, descending: desc)
      .get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

Future<List<Object?>> getModuleScoresFS({
  required String collection,
  required String field,
  required bool desc,
  required int limit,
  required String find,
}) async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(collection)
      .limit(limit)
      .where(field, isNotEqualTo: find)
      .get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

/* Future<List<String?>> getNamesFS({
  required String collection,
  required String id,
  required String list,
}) async {
  // Get docs from collection reference
  final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(collection).get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //allData as List<Map<String,dynamic>>;
  for (final element in allData) {
    if (element == list){

    }
  }
 
  return ret;
} */

Future<List<Object?>> getFSfind({
  required String collection,
  required String myfield,
  required String myvalue,
}) async {
  // Get docs from collection reference
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection(collection)
      .where(myfield, isEqualTo: myvalue)
      .get();
  // Get data from docs and convert map to List
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  return allData;
}

Future<void> updateFS({
  required String collection,
  required String id,
  required String val,
  required dynamic valdata,
}) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .doc(id)
      .update({val: valdata});
  /* .then((value) => print("User Updated"))
      .catchError((e) => print("Failed to update user: $e")); */
}

//изменение признака общего доступа модуля
Future<void> updatesharedFS({
  required String collection,
  required String id,
  required String val,
  required String valdata,
}) async {
  await FirebaseFirestore.instance.collection(collection).doc(id).update({
    val: FieldValue.arrayRemove([if (valdata == '#') '' else '#'])
  });

  await FirebaseFirestore.instance.collection(collection).doc(id).update({
    val: FieldValue.arrayUnion([valdata])
  });
}

//удаление модуля
Future<void> deleteFS({
  required String collection,
  required String id,
}) async {
  await FirebaseFirestore.instance.collection(collection).doc(id).delete();
}

//запись в FBS
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

//чтение из FBS
Future<Uint8List?> fromFBS(String path) async {
  final fbs.Reference ref = fbs.FirebaseStorage.instance.ref(path);
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

Future<void> delFBS(
  String path,
) async {
  final fbs.Reference ref = fbs.FirebaseStorage.instance.ref(path);
  //удаление файла
  await ref.delete();
}

//--------------------------------------------------------------------------------- ниже неактуально
Future<List<Object?>> getUsersVarsFS(Map<String, dynamic> doc) async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(
        '${doc['myclas'] as String} ${doc['myfio'] as String} ${doc['mymail'] as String}',
      )
      .collection('vars')
      .get();
  final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //debugPrint(allData.toString());
  return allData;
}

@override
Future<void> deleteUser(Map<String, dynamic> doc) async {
  //удаление документа var
  await FirebaseFirestore.instance
      .collection('users')
      .doc(
        '${doc['myclas'] as String} ${doc['myfio'] as String} ${doc['mymail'] as String}',
      )
      .collection('vars')
      .get()
      .then((value) {
    for (final element in value.docs) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(
            '${doc['myclas'] as String} ${doc['myfio'] as String} ${doc['mymail'] as String}',
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
        '${doc['myclas'] as String} ${doc['myfio'] as String} ${doc['mymail'] as String}',
      )
      .delete();
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
