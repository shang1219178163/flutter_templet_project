//
//  DateFormatEnum.dart
//  flutter_templet_project
//
//  Created by shang on 2024/7/9 17:28.
//  Copyright © 2024/7/9 shang. All rights reserved.
//

enum DateFormatEnum {
  /// yyyy-MM-dd HH:mm:ss
  normal("yyyyMMddHHmmss", 'yyyy-MM-dd HH:mm:ss'),

  /// yyyy-MM-dd
  yyyyMMdd("yyyyMMdd", 'yyyy-MM-dd'),

  /// yyyy-MM-dd 00:00:00
  yyyyMMdd000000("yyyyMMdd000000", 'yyyy-MM-dd 00:00:00'),

  /// yyyy-MM-dd 23:59:59
  yyyyMMdd235959("yyyyMMdd235959", 'yyyy-MM-dd 23:59:59'),

  /// MM-dd
  MMdd("MMdd", 'MM-dd'),

  /// HH:mm:
  HHmm("HHmm", 'HH:mm'),

  /// HH:mm:ss
  HHmmss("HHmmss", 'HH:mm:ss');

  const DateFormatEnum(this.name, this.value);

  final String name;
  final String value;
}
