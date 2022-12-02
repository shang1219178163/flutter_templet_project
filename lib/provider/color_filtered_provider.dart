import 'package:flutter/material.dart';


class ColorFilteredProvider with ChangeNotifier {

  Color color = Colors.transparent;//默认透明

  ///设置过滤后的颜色
  setColor(Color value) {
    color = value;
    notifyListeners();
  }
}