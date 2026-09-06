//
//  SportTypeEnum.dart
//  flutter_templet_project
//
//  Created by shang on 2026/9/6 09:35.
//  Copyright © 2026/9/6 shang. All rights reserved.
//

/// 直播业务类型：FOOTBALL、BASKETBALL、GENERAL。
enum SportTypeEnum {
  /// 足球赛事直播
  football(
    value: 'football',
    desc: '足球',
  ),

  /// 篮球赛事直播
  basketball(
    value: 'basketball',
    desc: '篮球',
  ),
  ;

  const SportTypeEnum({
    required this.value,
    required this.desc,
  });

  /// 接口业务编码
  final String value;

  /// 描述
  final String desc;

  /// 按业务编码 [value] 匹配；空或无法识别时返回 null。
  static SportTypeEnum? valueOf(String? v) {
    final result = values.where((e) => e.value.toLowerCase() == v?.toLowerCase()).firstOrNull;
    return result;
  }
}
