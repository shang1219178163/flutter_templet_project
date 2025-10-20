import 'package:flutter/cupertino.dart';

class CounterChangeNotifier extends ChangeNotifier {
  CounterChangeNotifier();
  int value = 0;

  void increment() {
    value++;
    notifyListeners();
  }

  void decrement() {
    value--;
    notifyListeners();
  }
}
