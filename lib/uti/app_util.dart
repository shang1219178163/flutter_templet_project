

import 'package:flutter/cupertino.dart';

class AppUtil{
  // AppUtil._();
  //
  // static final AppUtil _instance = AppUtil._();
  //
  // factory AppUtil() => _instance;
  //
  // init() async {
  //   // debugPrint("init: $prefs");
  // }

  // 创建一个全局的GlobalKey
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  // 全局获取context
  static BuildContext getGlobalContext() {
    return navigatorKey.currentState!.overlay!.context;
  }

  // 移除输入框焦点
  static void removeInputFocus() {
    FocusManager.instance.primaryFocus?.unfocus();

    // // 延迟，保证获取到context
    // Future.delayed(Duration.zero, () {
    //   FocusScope.of(getGlobalContext()).requestFocus(FocusNode());
    // });
  }

}