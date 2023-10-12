//
//  RegexpExt.dart
//  flutter_templet_project
//
//  Created by shang on 2023/9/7 16:56.
//  Copyright © 2023/9/7 shang. All rights reserved.
//


/// emoji 正则
final RegExp emojiReg = RegExp(RegExpSource.emoji);


extension RegExpExt on RegExp{

  /// 匹配
  List<String> allMatchesOfString(String input, [int start = 0]) {
    final list = allMatches(input, start)
        .map((e) => e.group(0))
        .where((e) => e != null)
        .whereType<String>()
        .toList();
    return list;
  }

}


class RegExpSource{
  /// 手机
  static const cellphone = r"^1[1-9]\d{9}$";
  /// 密码
  static const pwd = r"^(?![\d]+$)(?![a-zA-Z]+$)(?![@_.,]+$)[\da-zA-Z@_.,]{6,18}$";
  /// 字母
  static const email = r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$";
  /// 链接
  static const url = r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+";
  /// 身份证
  static const idCard = r"\d{17}[\d|x]|\d{15}";
  /// 汉字
  static const hanzi = r"[\u4e00-\u9fa5]";
  /// 子母
  static const letter = r"^[ZA-ZZa-z_]+$";
  /// 座机
  static const telephone = r"^(\d{3,4}-)?\d{7,8}$";
  /// 特殊字符
  static const specialCharacter = r'[`~!@#$%^&*()_+=|;:(){}'
      ',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？-]';
  /// 数字字母汉字
  static const letterNumeralHanzi = r'^[A-Za-z0-9\u4e00-\u9fa5]+$';
  /// 纯数字
  static const numeral = r"^[0-9_]+$";
  /// 百分比
  static const percent = r'^\d+(\.)?[0-9]{0,2}';

  static const emoji = r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';

}