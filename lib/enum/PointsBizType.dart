//
//  PointsBizTypeEnum.dart
//  flutter_templet_project
//
//  Created by shang on 2026/6/22 12:26.
//  Copyright © 2026/6/22 shang. All rights reserved.
//

import 'package:flutter_templet_project/generated/assets.dart';

/// 积分来源枚举公共部分
abstract interface class PointsBizTypeEnumInterface {
  /// 枚举名称
  String get name;

  /// 描述
  String get desc;

  /// 本地 icon
  String get icon;
}

/// 积分来源
enum PointsBizTypeEnum implements PointsBizTypeEnumInterface {
  register(value: 10, name: "register", desc: "注册奖励", icon: Assets.pointsIcPointsRegistRewards),
  invite(value: 20, name: "invite", desc: "邀请奖励", icon: Assets.pointsIcPointsInviteReward),
  admin(value: 90, name: "admin", desc: "系统调整", icon: Assets.pointsIcPointsRegistRewards),
  ;

  const PointsBizTypeEnum({
    required this.value,
    required this.name,
    required this.desc,
    required this.icon,
  });

  /// 当前枚举值对应的 int 值(非 index)
  final int value;

  @override
  final String name;

  @override
  final String desc;

  @override
  final String icon;
}

enum PointsBizSubTypeEnum implements PointsBizTypeEnumInterface {
  //用户注册邀请行为
  registerIncome(name: "REGISTER_INCOME", desc: "注册奖励", icon: Assets.pointsIcPointsRegistRewards),
  inviteIncome(name: "INVITE_INCOME", desc: "邀请奖励", icon: Assets.pointsIcPointsInviteReward),

  //系统
  adminIncome(name: "ADMIN_INCOME", desc: "系统赠送", icon: Assets.pointsIcPointsAdminIncome),
  adminExpense(name: "ADMIN_EXPENSE", desc: "系统扣除", icon: Assets.pointsIcPointsAdminExpense);

  const PointsBizSubTypeEnum({
    required this.name,
    required this.desc,
    required this.icon,
  });

  @override
  final String name;

  @override
  final String desc;

  @override
  final String icon;
}
