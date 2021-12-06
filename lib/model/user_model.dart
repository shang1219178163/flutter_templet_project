//
//  UserModel.dart
//  flutter_templet_project
//
//  Created by shang on 5/19/21 6:32 PM.
//  Copyright © 5/19/21 shang. All rights reserved.
//



import 'package:json_annotation/json_annotation.dart';

class UserModel {
  /// 用户昵称
  final String title;

  /// 用户头像
  final String imageUrl;

  /// 消息内容
  final String content;

  /// 消息收到时间
  final String time;

  const UserModel({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.time,
  });
}