import 'package:flutter/cupertino.dart';

abstract class AppTabBarController {
  /// tab bar item 单击回调
  void onBarTap(int index);

  /// tab bar item 双击回调
  void onBarDoubleTap(int index);
}

abstract class TabBarState<T extends StatefulWidget> extends State<T> {
  /// tab bar item 单击回调
  @mustCallSuper
  void onBarTap(int index);

  /// tab bar item 双击回调
  @protected
  void onBarDoubleTap(int index) {}
}
