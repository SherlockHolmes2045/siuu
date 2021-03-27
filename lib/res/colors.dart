import 'package:flutter/cupertino.dart';

const int greyishColor = 0xffF0F6F0;
const int purpleColor = 0xff4D0CBB;
const int pinkColor = 0xffFD0767;

Gradient linearGradient = LinearGradient(
  // List: [
  //   Color(purpleColor),
  //   Color(pinkColor),
  // ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  // stops: [0.5, 0.5],
  colors: [
    Color(purpleColor),
    Color(pinkColor),
  ],
);

Gradient greyGradient = LinearGradient(
  begin:  Alignment.topLeft,
  end: Alignment.bottomRight,

  colors: [
    Color(0xffaaa5a5),
    Color(0xffaaa5a5)
  ]
);
