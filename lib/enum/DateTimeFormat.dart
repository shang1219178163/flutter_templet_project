//
//  DateTimeFormat.dart
//  flutter_templet_project
//
//  Created by shang on 2024/3/24 15:12.
//  Copyright © 2024/3/24 shang. All rights reserved.
//

/// 日期格式枚举
enum DateTimeFormat {
  yyyyMMddHHmmss("yyyy-MM-dd HH:mm:ss", "年月日时分秒"),
  yyyyMMdd("yyyy-MM-dd", "年月日"),
  yyyyMMdd000000("yyyy-MM-dd 00:00:00", "年月日 00:00:00"),
  yyyyMMdd235959("yyyy-MM-dd 23:59:59", "年月日 23:59:59"),
  HHmmss("HH:mm:ss", "时分秒"),
  HHmm("HH:mm", "时分");

  const DateTimeFormat(this.value, this.desc);

  final String value;
  final String desc;
}
