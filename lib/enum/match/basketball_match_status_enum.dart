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
  going(name: 'going', statusId: [2, 3, 4, 5, 6, 7, 8, 9], desc: '进行中'),
  noStart(name: 'no_start', statusId: [1, 13, 15], desc: '赛程'),
  finish(name: 'finish', statusId: [10], desc: '赛果'),
  other(name: 'other', statusId: [11, 12], desc: '其他'),
  ;

  const BasketballMatchStatusEnum({
    required this.name,
    required this.statusId,
    required this.desc,
  });

  @override
  final String name;

  @override
  final List<int> statusId;

  @override
  final String desc;
}

/// Ncaa 篮球比赛状态
enum BasketballNcaaMatchStatusEnum implements MatchStatusEnumInterface {
  going(name: 'going', statusId: [2, 3, 4], desc: '进行中'),
  noStart(name: 'no_start', statusId: [1, 13, 15], desc: '赛程'),
  finish(name: 'finish', statusId: [10], desc: '赛果'),
  other(name: 'other', statusId: [11, 12], desc: '其他'),
  ;

  const BasketballNcaaMatchStatusEnum({
    required this.name,
    required this.statusId,
    required this.desc,
  });

  @override
  final String name;

  @override
  final List<int> statusId;

  @override
  final String desc;
}
