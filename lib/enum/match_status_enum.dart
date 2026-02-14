//
//  MatchStatusEnum.dart
//  projects
//
//  Created by shang on 2026/2/12 10:05.
//  Copyright © 2026/2/12 shang. All rights reserved.
//

/// 球类比赛信息基础类
abstract class BallMatchStatusEnum {
  /// 类型描述
  String get desc;

  /// 类型值
  String get value;

  /// 类型集合
  List<int> get statusIds;
}

enum FootballMatchStatusEnum implements BallMatchStatusEnum {
  going("going", "进行中", [2, 3, 4, 5, 6, 7]),
  noStart("no_start", "赛程", [1]),
  finish("finish", "赛果", [8]),
  other("other", "其他", [9, 10, 11, 12, 13]),
  ;

  const FootballMatchStatusEnum(this.value, this.desc, this.statusIds);

  /// 描述
  @override
  final String value;

  /// 描述
  @override
  final String desc;

  /// 类型
  @override
  final List<int> statusIds;
}

enum BasketballMatchStatusEnum implements BallMatchStatusEnum {
  going("going", "进行中", [2, 3, 4, 5, 6, 7, 8, 9]),
  noStart("no_start", "赛程", [1]),
  finish("finish", "赛果", [10]),
  other("other", "其他", [11, 12, 13, 14, 15]),
  ;

  const BasketballMatchStatusEnum(this.value, this.desc, this.statusIds);

  /// 描述
  @override
  final String value;

  /// 描述
  @override
  final String desc;

  /// 类型
  @override
  final List<int> statusIds;
}
