import 'dart:async';
import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/helpers/fb_hlp.dart';

Future<Uint8List> loadImg(String imgurl) async {
/*  ************ ВЫЗОВ
                      final Uint8List ttt = await loadImg(
                        'https://101kote.ru/upload/medialibrary/46f/20.jpg',
                      );
                      print(ttt);
*/
  late http.Response response;
  await http
      .get(
    Uri.parse(imgurl),
  )
      .then((value) {
    response = value;
  });

  final Uint8List bytes = response.bodyBytes;
  debugPrint(bytes.toString());
  return bytes;
}

//загрузка изображений из FBS для всего модуля
Future<List<Uint8List>> getImgs({
  required List getImgsName,
  required bool isLoaded,
}) async {
  final List<Uint8List> ret = [];
  //получить файл "пустышку"
  Uint8List? placeholderimg = Uint8List.fromList([0]);
  placeholderimg = await getPlaceholderImg();
  if (!isLoaded) {
    for (int i = 0; i < getImgsName.length; i++) {
      await fromFBS(getImgsName[i] as String).then((value) {
        if (value != null) {
          ret.add(value);
        } else {
          ret.add(placeholderimg!);
        }
      }).onError((_, __) {
        ret.add(placeholderimg!);
      });
    }
  }
  return ret;
}

//файл "пустышки"
Future<Uint8List> getPlaceholderImg() async {
  ByteData bytes;
  late Uint8List ret;
  await rootBundle.load('placeholder.png').then((value) {
    bytes = value;
    ret = bytes.buffer.asUint8List();
  });
  return ret;
  //return null;
  //return Uint8List.fromList([0]);
}


/* //  ======================  УБРАТЬ ОБРАБОТКУ ЗАГЛУШКИ - ВСЕГДА ДОЛЖНО БЫТЬ ИЗОБРАЖЕНИЕ
//загрузка изображений из FBS для всего модуля
Future<List<Uint8List>> getImgs({required List getImgsName}) async {
  final List<Uint8List> ret = [];
  Uint8List placeholderimg = Uint8List.fromList([0]);
  await fromFBS('placeholder.png').then((value) {
    placeholderimg = value!;
  });
  for (int i = 0; i < getImgsName.length; i++) {
    await fromFBS(getImgsName[i] as String).then((value) {
      ret.add(value!);
      //если случайно изображения не будет, заменить его "заглушкой"
    }).onError((_, __) {
      ret.add(placeholderimg);
    });
  }
  return ret;
} */
