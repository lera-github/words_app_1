import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Email Id",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () async {
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailTextController.text.trim(),
                    password: _passwordTextController.text.trim(),
                  )
                      .then((value) async {
                    var idx;
//запись в базу нового пользователя
                    await FirebaseFirestore.instance.collection('users').add({
                      'username': _userNameTextController.text.trim()
                    }).then((value) {
                      idx = value.id;
                    });
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(idx as String)
                        .update({
                      'userid': idx,
                      'useremail': _emailTextController.text.trim()
                    });
                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ),
                    );
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignInScreen()),
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back_rounded),
                      Text(
                        " назад",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
