import 'package:flutter/material.dart';

TextStyle titleStyle = TextStyle(
      color: Colors.blue.shade700,
      //Color(0xff3da4ab).withOpacity(0.5),
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontFamily: 'Georgia',
      shadows: const <Shadow>[
        Shadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 1.0,
          color: Colors.black,
        ),
        /* Shadow(
          offset: Offset(2.0, 2.0),
          blurRadius: 3.0,
          color: Colors.indigo,
        ), */
      ],
    );
    TextStyle textStyle = TextStyle(
      color: Colors.blue.shade800,
      //Color(0xff3da4ab).withOpacity(0.5),
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
      fontFamily: 'Georgia',
      shadows: const <Shadow>[
        Shadow(
          offset: Offset(1.0, 1.0),
          blurRadius: 1.0,
          color: Colors.grey,
        ),
      ],
    );