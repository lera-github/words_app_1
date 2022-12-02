import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/helpers/fb_hlp.dart';

Future<Uint8List> loadImg(String imgurl) async {
/*  ************ ВЫЗОВ
                      final Uint8List ttt = await loadImg(p
                        'https://101kote.ru/upload/medialibrary/46f/20.jpg',
                      );
                      print(ttt);
*/
  //используем бесплатный CORS Proxy, иначе имеем ошибку
  // https://scrappy-php.herokuapp.com/?url=
  // или https://pika-secret-ocean-49799.herokuapp.com/
  // https://api.codetabs.com/v1/proxy?quest=
  final http.Response response = await http.get(
    Uri.parse('https://api.codetabs.com/v1/proxy?quest=$imgurl'),
  );
  final Uint8List bytes = response.bodyBytes;
/*   Uint8List bytes = Uint8List.fromList([0]);
  await http.readBytes(
    Uri.parse(imgurl),
/*     headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'image/jpeg',
    }, */
  ).then((value) => bytes = value); */
  return bytes;
}

//загрузка изображений из FBS для всего модуля
Future<List<Uint8List>> getImgs({
  required List getImgsName,
  required bool isLoaded,
}) async {
  final List<Uint8List> ret = [];
  //получить файл "пустышку"
  Uint8List? placeholderimg = Uint8List.fromList([]);
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

//загрузка изображения из FBS или пустышку
Future<Uint8List> getImg({
  required String getImgName,
}) async {
  Uint8List ret = Uint8List.fromList([]);
  if (getImgName == 'placeholder.png') {
    ret = await getPlaceholderImg();
  } else {
    await fromFBS(getImgName).then((value) {
      if (value != null) {
        ret = value;
      }
    });
  }

  return ret;
}

class ImageLoader extends StatefulWidget {
  const ImageLoader({Key? key, required this.imgName}) : super(key: key);
  final String imgName;

  @override
  State<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  @override
  Widget build(BuildContext context) {
    Uint8List bytes;
    return FutureBuilder(
      future: getImg(
        getImgName: widget.imgName,
      ),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          );
        }
        if (snapshot.hasData) {
          bytes = snapshot.data!;

          return Image.memory(
            bytes,
            fit: BoxFit.cover,
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const SizedBox();
      },
    );
  }
}
