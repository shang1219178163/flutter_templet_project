import 'package:flutter_templet_project/Model/app_update_model.dart';

/// 好友列表模拟数据
const List<AppUpdateItemModel> kUpdateAppList = [
  AppUpdateItemModel(
      appIcon: "assets/icon_light_unselected.png",
      appSize: "53.2M",
      appName: "QQ音乐 - 让生活充满音乐",
      appDate: "13:50",
      appDescription: """【全新设计 纯净享受】
    -重塑全新视觉，轻盈/纯净/无扰/为Mac系统量身设计，从内而外纯净享受；
    -全新结构设计，整体交互优化/人性化和易用性大提升，操作体验豪华升级"；
  """,
      appVersion: "版本 7.6.0",
      isShowAll: false),
  AppUpdateItemModel(
    appIcon: "assets/icon_light_unselected.png",
    appSize: "66.2M",
    appName: "喜马拉雅「听书社区」电台有声小说相声评书",
    appDate: "13:50",
    appDescription: "广播电台支持收藏\n- 支持添加随开机启动，畅听不等待；\n- 修复了上个版本部分用户播放卡顿问题；",
    //   appDescription: """
    //   广播电台支持收藏
    //   - 支持添加随开机启动，畅听不等待
    //   - 修复了上个版本部分用户播放卡顿问题
    // """,
    appVersion: "版本 1.8.0",
  ),
];

class TestModel {

  const TestModel({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.time,
  });
  /// 用户昵称
  final String title;

  /// 用户头像
  final String imageUrl;

  /// 消息内容
  final String content;

  /// 消息收到时间
  final String time;
}
