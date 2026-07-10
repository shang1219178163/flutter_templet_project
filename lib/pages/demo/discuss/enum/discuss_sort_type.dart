//
//  NewsDiscussSortType.dart
//  projects
//
//  Created by shang on 2026/7/7 10:07.
//  Copyright © 2026/7/7 shang. All rights reserved.
//

/// 排序方式
enum DiscussSortType {
  /// 最新
  newest(
    value: 'newest',
    desc: '最新',
  ),

  /// 最热
  hottest(
    value: 'hottest',
    desc: '最热',
  ),

  /// 精选
  featured(
    value: 'featured',
    desc: '精选',
  ),

  /// 最早
  earliest(
    value: 'earliest',
    desc: '最早',
  );

  const DiscussSortType({
    required this.value,
    required this.desc,
  });

  /// 接口参数
  final String value;

  /// 描述
  final String desc;

  /// 默认值
  static const DiscussSortType defaultValue = DiscussSortType.newest;

  /// 根据接口值解析
  static DiscussSortType fromValue(String? value) {
    return DiscussSortType.values.firstWhere((e) => e.value == value, orElse: () => defaultValue);
  }
}
