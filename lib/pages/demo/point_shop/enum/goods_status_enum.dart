//
//  GoodsStatusEnum.dart
//  projects
//
//  Created by shang on 2026/4/21 11:44.
//  Copyright © 2026/4/21 shang. All rights reserved.
//

/// 交易类型
enum GoodsStatusEnum {
  not_owned("not_owned", "未兑换", "兑换"),
  owned("owned", "已兑换未装扮", "装扮"),
  equipped("equipped", "已装扮", "已装扮"),
  ;

  const GoodsStatusEnum(this.value, this.desc, this.descNext);
  final String value;
  final String desc;
  final String descNext;

  @override
  String toString() {
    return "$runtimeType $desc: $value";
  }
}
