//
//  OperateType.dart
//  yl_health_app
//
//  Created by shang on 2023/11/9 15:41.
//  Copyright © 2023/11/9 shang. All rights reserved.
//


/// 基础操作
enum OperateType {
  /// 创建/新增
  CREATE('新增'),
  /// 编辑/更新
  UPDATE('编辑'),
  /// 读取
  READ('读取'),
  /// 删除
  DELETE('删除');

  const OperateType(this.desc,);
  /// 当前枚举对应的 描述文字
  final String desc;

}