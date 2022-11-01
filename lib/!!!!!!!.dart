// ignore_for_file: file_names
///////
///     При регистрации добавить проверку уникальности email и username 
/// ============================================================================
/// на память - firebase deploy --only hosting
/// ===============================
/// 
/// Error: XMLHttpRequest error ->
///   https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
/// 1- Go to flutter\bin\cache and remove a file named: flutter_tools.stamp
/// 2- Go to flutter\packages\flutter_tools\lib\src\web and open the file chrome.dart.
/// 3- Find '--disable-extensions'
/// 4- Add '--disable-web-security'
