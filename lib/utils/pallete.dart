import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff5D56FA, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff544DE1), //10%
      100: Color(0xff4A45C8), //20%
      200: Color(0xff413CAF), //30%
      300: Color(0xff383496), //40%
      400: Color(0xff2F2B7D), //50%
      500: Color(0xff252264), //60%
      600: Color(0xff1C1A4B), //70%
      700: Color(0xff131132), //80%
      800: Color(0xff090919), //90%
      900: Color(0xff000000), //100%
    },
  );
}
