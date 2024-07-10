//
//  ActivityType.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/18 11:07.
//  Copyright © 2024/1/18 shang. All rights reserved.
//

enum ActivityType {
  unknown(-1, '未知'),

  running(1, '跑步'),

  climbing(2, '攀登'),

  hiking(5, '徒步旅行'),

  cycling(7, '骑行'),

  skiing(10, '滑雪');

  const ActivityType(
    this.value,
    this.desc,
  );

  /// 当前枚举值对应的 int 值(非 index)
  final int value;

  /// 当前枚举对应的 描述文字
  final String desc;

  @override
  String toString() {
    return '$desc is $value';
  }
}

enum ActivityTypeNew {
  unknown,
  running,
  climbing,
  hiking,
  cycling,
  skiing,
}

extension ActivityTypeNewExt on ActivityTypeNew {
  static const map = {
    ActivityTypeNew.unknown: "未知",
    ActivityTypeNew.running: "跑步",
    ActivityTypeNew.climbing: "攀登",
    ActivityTypeNew.hiking: "徒步旅行",
    ActivityTypeNew.cycling: "骑行",
    ActivityTypeNew.skiing: "滑雪",
  };

  String? get desc {
    return map[this];
  }
}
