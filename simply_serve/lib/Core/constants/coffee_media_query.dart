import 'package:flutter/material.dart';

class MQ {
  static late double h;
  static late double w;

  static init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    h = size.height;
    w = size.width;
  }
}
