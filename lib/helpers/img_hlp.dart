import 'dart:typed_data';
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
  final http.Response response = await http.get(
    Uri.parse(imgurl),
  );
  final Uint8List bytes = response.bodyBytes;
  return bytes;
}

//загрузка изображений из FBS для всего модуля
Future<List<Uint8List>> getImgs({required List getImgsName}) async {
  final List<Uint8List> ret = [];
  for (int i = 0; i < getImgsName.length; i++) {
    await fromFBS(getImgsName[i] as String).then((value) {
      ret.add(value!);
    });
  }
  return ret;
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
