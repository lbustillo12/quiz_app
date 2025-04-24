import 'package:flutter/material.dart';

Widget normalText({
  required String text,
  Color? color,
  double? size,
  TextAlign align = TextAlign.center, // 🟢 Valor por defecto: centrado
}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(fontFamily: "quick_semi", fontSize: size, color: color),
  );
}

Widget headingText({
  required String text,
  Color? color,
  double? size,
  TextAlign align = TextAlign.center, // 🟢 Valor por defecto: centrado
}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(fontFamily: "quick_bold", fontSize: size, color: color),
  );
}
