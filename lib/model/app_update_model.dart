//
//  app_update_model.dart
//  fluttertemplet
//
//  Created by shang on 5/19/21 5:34 PM.
//  Copyright © 5/19/21 shang. All rights reserved.
//


///升级模型
class AppUpdateItemModel {
  final String appIcon;//App图标
  final String appName;//App名称
  final String appSize;//App大小
  final String appDate;//App更新日期
  final String appDescription;//App更新文案
  final String appVersion;//App版本
  final bool isShowAll;//App更新文案


  const AppUpdateItemModel({
    this.appIcon = "-",
    this.appSize = "-",
    this.appName = "-",
    this.appDate = "-",
    this.appDescription = "-",
    this.appVersion = "-",
    this.isShowAll = false,
  });
}