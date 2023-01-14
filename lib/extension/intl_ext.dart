//
//  IntlExtension.dart
//  flutter_templet_project
//
//  Created by shang on 11/8/22 11:00 AM.
//  Copyright © 11/8/22 shang. All rights reserved.
//


import 'package:intl/intl.dart';

extension IntExt<T,E> on int {

  /// 数字格式化
  String numFormat([String? newPattern = '0,000', String? locale]) {
    final fmt = NumberFormat(newPattern, locale);
    return fmt.format(this);
  }
}


