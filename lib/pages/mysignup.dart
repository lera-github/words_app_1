import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/helpers/other_hlp.dart';
import 'package:myapp/main.dart';
import 'package:myapp/pages/mysignin.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
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
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
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
                      text: "Введите адрес электронной почты",
                      icon: Icons.person_outline,
                      isPasswordType: false,
                      controller: _emailTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(
                      text: "Введите пароль",
                      icon: Icons.lock_outlined,
                      isPasswordType: true,
                      controller: _passwordTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    signInSignUpButton(
                      context: context,
                      isLogin: false,
                      onTap: () async {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailTextController.text.trim(),
                          password: _passwordTextController.text.trim(),
                        )
                            .then((value) async {
                          var idx='';
                          //запись в базу нового пользователя
                          await FirebaseFirestore.instance
                              .collection('users')
                              .add({
                            'username': _userNameTextController.text.trim()
                          }).then((value) {
                            idx = value.id;
                          });
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(idx)
                              .update({
                            'userid': idx,
                            'useremail': _emailTextController.text.trim()
                          });

                          if (!mounted) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                collectionPath: 'modules',
                                //'users/${idx as String}/modules',
                                userid: idx,
                              ),
                            ),
                          );
                        }).onError((error, stackTrace) {
                          showAlert(
                              context: context,
                              mytext: 'Error ${error.toString()}',);
                          //print("Error ${error.toString()}");
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: const [
                          Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white70,
                          ),
                          Text(
                            " назад",
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
