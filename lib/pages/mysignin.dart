import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/fb_hlp.dart';
import 'package:myapp/helpers/other_hlp.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/mysignup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final scrwidth = MediaQuery.of(context).size.width < 600.0
        ? MediaQuery.of(context).size.width
        : 600.0;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffcb2b93), Color(0xff9546c4), Color(0xff5e61f4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(width: scrwidth),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).size.height * 0.05,
                  20,
                  0,
                ),
                child: Column(
                  children: <Widget>[
                    logoWidget("assets/logo1.png"),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField(
                      text: "Введите имя пользователя",
                      icon: Icons.person_outline,
                      isPasswordType: false,
                      controller: _userNameTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                      text: "Введите пароль",
                      icon: Icons.lock_outline,
                      isPasswordType: true,
                      controller: _passwordTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    signInSignUpButton(
                      context: context,
                      isLogin: true,
                      onTap: () async {
                        //поиск пользователя
                        final List<Object?> userCollection = await getFSfind(
                          collection: 'users',
                          myfield: 'username',
                          myvalue: _userNameTextController.text.trim(),
                        );
                        //такой пользователь зарегистрирован?

                        if (userCollection.isEmpty) {
                          myAlert(
                            context: context,
                            mytext:
                                'Пользователя с таким именем не существует!\nЗарегистрируйтесь!',
                          );
                          return;
                        }

                        final userCollectionItem =
                            userCollection[0]! as Map<String, dynamic>;
                        final emailText = '${userCollectionItem['useremail']}';
                        final userid = '${userCollectionItem['userid']}';

                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          //-----------------------------------------------------  ВРЕМЕННО! -  ПОСТОЯННАЯ АВТОРИЗАЦИЯ
                          //email: "aaaaaa@ya.ru",
                          //password: "aaaaaa",
                          //email: _emailTextController.text.trim(),
                          email: emailText,
                          password: _passwordTextController.text.trim(),
                        )
                            .then((value) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                collectionPath: 'modules',
                                //    'users/${userCollectionItem['userid']}/modules',
                                userid: userid, //'lut4hDl8Jqv5uyaY6CDL',
                              ),
                            ),
                          );
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                      },
                    ),
                    signUpOption()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Не можете войти?  ",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: const Text(
            "Зарегистрируйтесь",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    //color: Colors.white,
  );
}

TextField reusableTextField({
  required String text,
  required IconData icon,
  required bool isPasswordType,
  required TextEditingController controller,
}) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton({
  required BuildContext context,
  required bool isLogin,
  required Function onTap,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
      child: Text(
        isLogin ? 'Войти' : 'Зарегистрироваться',
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}
