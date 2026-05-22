//
//  FootballMatchStatusEnum.dart
//  projects
//
//  Created by shang on 2026/3/25 17:42.
//  Copyright © 2026/3/25 shang. All rights reserved.
//

import 'package:flutter_templet_project/enum/match/match_status_enum_interface.dart';

/// 足球比赛状态
enum FootballMatchStatusEnum implements MatchStatusEnumInterface {
  going(name: 'going', statusId: [2, 3, 4, 5, 6, 7], desc: '进行中'),
  noStart(name: 'no_start', statusId: [1], desc: '赛程'),
  finish(name: 'finish', statusId: [8], desc: '赛果'),
  other(name: 'other', statusId: [9, 10, 11, 12, 13], desc: '其他'),
  ;

  const FootballMatchStatusEnum({
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
