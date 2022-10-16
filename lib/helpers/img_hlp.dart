import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List> getImg(String imgurl) async {
/*  ************ ВЫЗОВ
                      final Uint8List ttt = await getImg(
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
