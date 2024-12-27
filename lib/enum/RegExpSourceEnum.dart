//
//  RegExpSourceEnum.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/18 11:07.
//  Copyright © 2024/1/18 shang. All rights reserved.
//

/// 常用正则
enum RegExpSourceEnum {
  /// 手机
  cellphone(r"^1[1-9]\d{9}$", "手机"),

  /// 密码
  pwd(r"^(?![\d]+$)(?![a-zA-Z]+$)(?![@_.,]+$)[\da-zA-Z@_.,]{6,18}$", "密码"),

  /// 字母
  email(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$", "字母"),

  /// 链接
  url(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+", "链接"),

  /// 身份证
  idCard(r"\d{17}[\d|x]|\d{15}", "身份证"),

  /// 汉字
  hanzi(r"[\u4e00-\u9fa5]", "汉字"),

  /// 子母
  letter(r"^[ZA-ZZa-z_]+$", "子母"),

  /// 座机
  telephone(r"^(\d{3,4}-)?\d{7,8}$", "座机"),

  /// 特殊字符
  specialCharacter(
      r'[`~!@#$%^&*()_+=|, ""),:(){}'
          ',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？-]',
      "特殊字符"),

  /// 数字字母汉字
  letterNumeralHanzi(r'^[A-Za-z0-9\u4e00-\u9fa5]+$', "数字字母汉字"),

  /// 纯数字
  numeral(r"^[0-9_]+$", "纯数字"),

  /// 百分比
  percent(r'^\d+(\.)?[0-9]{0,2}', "百分比"),

  emoji(r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])', "emoji");

  const RegExpSourceEnum(this.name, this.desc);

  /// 当前枚举值对应的 int 值(非 index)
  final String name;

  /// 当前枚举对应的 描述文字
  final String desc;

  @override
  String toString() {
    return '$desc is $name';
  }
}
