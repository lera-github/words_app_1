import 'package:flutter/material.dart';

Color menuItemsColor = Colors.deepPurple;

ButtonStyle menuButtonStyle = ButtonStyle(
  textStyle: MaterialStateProperty.all(menuButtonTextStyle),
);
TextStyle menuButtonTextStyle = const TextStyle(
  color: Colors.deepPurple,
  //Color(0xff3da4ab).withOpacity(0.5),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
  //fontFamily: 'Georgia',
  shadows: <Shadow>[
    Shadow(
      offset: Offset(0.5, 0.5),
      blurRadius: 0.5,
      color: Colors.grey,
    ),
  ],
);

TextStyle titleStyle = TextStyle(
  color: Colors.blue.shade700,
  //Color(0xff3da4ab).withOpacity(0.5),
  fontSize: 26.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.italic,
  fontFamily: 'Georgia',
  shadows: const <Shadow>[
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 1.0,
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
  //fontFamily: 'Georgia',
  shadows: const <Shadow>[
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 1.0,
      color: Colors.grey,
    ),
  ],
);

TextStyle text14Style = TextStyle(
  color: Colors.blue.shade800,
  //Color(0xff3da4ab).withOpacity(0.5),
  fontSize: 14.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
  //fontFamily: 'Georgia',
  shadows: const <Shadow>[
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 1.0,
      color: Colors.grey,
    ),
  ],
);

TextStyle textGreenStyle = TextStyle(
  color: Colors.green.shade800,
  //Color(0xff3da4ab).withOpacity(0.5),
  fontSize: 18.0,
  fontWeight: FontWeight.normal,
  fontStyle: FontStyle.normal,
  //fontFamily: 'Georgia',
  shadows: const <Shadow>[
    Shadow(
      offset: Offset(1.0, 1.0),
      blurRadius: 1.0,
      color: Colors.grey,
    ),
  ],
);
