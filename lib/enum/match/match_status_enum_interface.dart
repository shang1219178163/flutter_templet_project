//
//  MatchStatusInterface.dart
//  flutter_templet_project
//
//  Created by shang on 2026/5/21 12:14.
//  Copyright © 2026/5/21 shang. All rights reserved.
//

/// 比赛状态枚举公共部分
abstract interface class MatchStatusEnumInterface {
  /// 枚举名称
  String get name;

  /// 状态集合
  List<int> get statusId;

  /// 描述
  String get desc;
}
