// ignore_for_file: file_names
///////
///     При регистрации добавить проверку уникальности email и username 
/// 
/// 
/// 
/// 
///  делим время на 4 части и даем по 3-2-1-0 очков в завис от того какая часть времени идет сейчас
/// 
/// сделать в каждом модуле с очками, рейтинг по участникам
/// 
/// ============================================================================
/// на память - 
/// 
///   flutter run -d chrome --web-renderer html
///   flutter build web --web-renderer html --release
/// 
/// gsutil cors set cors.json gs://words-app-1.appspot.com
/// 
/// flutter build web
/// из build\web\ положить в public\
/// .\firebase-tools-instant-win.exe
/// firebase deploy --only hosting
/// ===============================
/// 
/// Error: XMLHttpRequest error ->
///   https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
/// 1- Go to flutter\bin\cache and remove a file named: flutter_tools.stamp
/// 2- Go to flutter\packages\flutter_tools\lib\src\web and open the file chrome.dart.
/// 3- Find '--disable-extensions'
/// 4- Add '--disable-web-security'
/// 4- Add '--disable-site-isolation-trials',
/// 
/// BUGS:
/// после удаления картинки в модуле не видно заглушки - только на хостинге
