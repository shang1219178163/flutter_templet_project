


import 'package:flutter/services.dart';

extension ClipboardExt on Clipboard{


  /// 复制内容
  static copy(String? text){
    Clipboard.setData(ClipboardData(text: text ?? ''));
  }

  /// 获取内容
  static Future<String> paste() async{
    var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData?.text ?? '';
  }

}