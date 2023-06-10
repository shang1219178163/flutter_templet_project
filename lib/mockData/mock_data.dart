import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_templet_project/Model/app_update_model.dart';
import 'package:flutter_templet_project/model/user_model.dart';


/// 好友列表模拟数据
const List<TestModel> kAliPayList = [
  TestModel(
    title: '生活缴费',
    imageUrl: 'http://alipay.dl.django.t.taobao.com/rest/1.0/image?fileIds=uYFc1rftQnOzQ6UIysboFQAAACMAAQQD&zoom=original',
    content: '听说，这6个人的电费被承包了！听说，这6个人的电费被承包了！听说，这6个人的电费被承包了！听说，这6个人的电费被承包了！',
    time: '13:50',
  ),
  TestModel(
    title: '芝麻信用',
    imageUrl: 'http://alipay.dl.django.t.taobao.com/rest/1.0/image?fileIds=uYFc1rftQnOzQ6UIysboFQAAACMAAQQD&zoom=original',
    content: '本月你的芝麻分评估已完成',
    time: '07:17',
  ),
  TestModel(
    title: '网商银行',
    imageUrl: 'http://alipay.dl.django.t.taobao.com/rest/1.0/image?fileIds=eQgixqanQuOWoptE3Ut_kQAAACMAAQQD&zoom=original',
    content: '如何做到日流水460万',
    time: '昨天',
  ),
  TestModel(
    title: '支付宝转账',
    imageUrl: 'http://alipay.dl.django.t.taobao.com/rest/1.0/image?fileIds=eniYmF55SPGp4xhBsdDUpAAAACMAAQQD&zoom=original',
    content: '请查收你的转账周报',
    time: '昨天',
  ),
  TestModel(
    title: '蚂蚁森林',
    imageUrl: 'https://oalipay-dl-django.alicdn.com/rest/1.0/image?fileIds=A7j1NJRVSlW9v88b3LRrkgAAACMAAQED&zoom=original',
    content: '比花棒还好看的新树种来了！',
    time: '星期五',
  ),
  TestModel(
    title: '蚂蚁庄园',
    imageUrl: 'https://mdn.alipay.com/wsdk/img?fileid=A*7pQiRakjTPoAAAAAAAAAAABjAfYuAQ&bz=life_app&zoom=2048w_80q_1l',
    content: '你有一封未读来信',
    time: '星期四',
  ),
  TestModel(
    title: '支付宝车主服务',
    imageUrl: 'https://oalipay-dl-django.alicdn.com/rest/1.0/image?fileIds=AOFWswJjTumOAH5ttFi2gwAAACMAAQED&zoom=2048w_1l',
    content: '@所有车主，7月1日起可免费办理ETC啦！',
    time: '星期三',
  ),
  TestModel(
    title: '城市服务',
    imageUrl: 'https://oalipay-dl-django.alicdn.com/rest/1.0/image?fileIds=I-C2YMNfSESeqVw3CaQazQAAACMAAQED&zoom=2048w_80q_1l',
    content: '有了它，垃圾再也不怕分错类啦！',
    time: '星期二',
  ),
  TestModel(
    title: '交通出行',
    imageUrl: 'https://mdn.alipay.com/wsdk/img?fileid=A*6R5cQbchQKMAAAAAAAAAAABjAfYuAQ&bz=life_app&zoom=2048w_80q_1l',
    content: '领取你的每周出行签 | 送防晒伞',
    time: '07-01',
  ),
  TestModel(
    title: '花呗',
    imageUrl: 'https://oalipay-dl-django.alicdn.com/rest/1.0/image?fileIds=8JCRgxPlQvumNy9RDgtziQAAACMAAQED&zoom=2048w_80q_1l',
    content: '帮你还花呗，离欧洲杯更近一点',
    time: '06-29',
  ),
];


/// 好友列表模拟数据
const List<AppUpdateItemModel> kUpdateAppList = [
  AppUpdateItemModel(appIcon: "assets/icon_light_unselected.png",
    appSize: "53.2M",
    appName: "QQ音乐 - 让生活充满音乐",
    appDate: "13:50",
    appDescription: """【全新设计 纯净享受】
    -重塑全新视觉，轻盈/纯净/无扰/为Mac系统量身设计，从内而外纯净享受；
    -全新结构设计，整体交互优化/人性化和易用性大提升，操作体验豪华升级"；
  """,
    appVersion: "版本 7.6.0",
    isShowAll: false
  ),
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
  /// 用户昵称
  final String title;

  /// 用户头像
  final String imageUrl;

  /// 消息内容
  final String content;

  /// 消息收到时间
  final String time;

  const TestModel({
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.time,
  });
}
