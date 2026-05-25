//
//  BasketballMatchStatusEnum.dart
//  projects
//
//  Created by shang on 2026/3/25 17:42.
//  Copyright © 2026/3/25 shang. All rights reserved.
//

import 'package:flutter_templet_project/enum/match/match_status_enum_interface.dart';

/// 篮球比赛状态
enum BasketballMatchStatusEnum implements MatchStatusEnumInterface {
  going(name: 'going', statusId: [2, 3, 4, 5, 6, 7, 8, 9], desc: '进行中', statusDesc: ""),
  noStart(name: 'no_start', statusId: [1, 13, 15], desc: '赛程', statusDesc: "未"),
  finish(name: 'finish', statusId: [10], desc: '赛果', statusDesc: "完"),
  other(name: 'other', statusId: [11, 12], desc: '其他', statusDesc: ""),
  ;

  const BasketballMatchStatusEnum({
    required this.name,
    required this.statusId,
    required this.desc,
    required this.statusDesc,
  });

  @override
  final String name;

  @override
  final List<int> statusId;

  @override
  final String desc;

  @override
  final String statusDesc;
}

/// Ncaa 篮球比赛状态
enum BasketballNcaaMatchStatusEnum implements MatchStatusEnumInterface {
  going(name: 'going', statusId: [2, 3, 4], desc: '进行中', statusDesc: ""),
  noStart(name: 'no_start', statusId: [1, 13, 15], desc: '赛程', statusDesc: "未"),
  finish(name: 'finish', statusId: [10], desc: '赛果', statusDesc: "完"),
  other(name: 'other', statusId: [11, 12], desc: '其他', statusDesc: ""),
  ;

  const BasketballNcaaMatchStatusEnum({
    required this.name,
    required this.statusId,
    required this.desc,
    required this.statusDesc,
  });

  @override
  final String name;

  @override
  final List<int> statusId;

  @override
  final String desc;

  @override
  final String statusDesc;
}
