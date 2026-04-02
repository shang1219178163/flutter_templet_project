//
//  FormValidator.dart
//  flutter_templet_project
//
//  Created by shang on 2026/3/30 11:49.
//  Copyright © 2026/3/30 shang. All rights reserved.
//

/// 表达数据验证
class FormValidator {
  /// 必传参数校验
  ///
  /// value 传值
  /// warning 警告语
  static String? isRequired(String? value, {required String warning}) {
    if (value == null || value.trim().isEmpty) {
      return warning;
    }
    return null;
  }

  /// 邮箱校验
  ///
  /// value 传值
  /// warning 警告语
  static String? isEmail(String? value, {required String warning}) {
    if (value == null || value.isEmpty) {
      return warning;
    }
    final regex = RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return warning;
    }
    return null;
  }
}
