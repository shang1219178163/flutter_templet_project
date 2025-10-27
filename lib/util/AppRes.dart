import 'package:flutter/material.dart';

///资源整合
class AppRes {
  static final _RString string = _RString._instance;
  static final _RColor color = _RColor._instance;
  static final _REvent event = _REvent._instance;
  static final _RImage image = _RImage._instance;
}

class _RString {
  static final _RString _instance = _RString();

  final share = "分享";
}

class _RColor {
  static final _RColor _instance = _RColor();

  final theme = Colors.blue;
}

class _REvent {
  static final _REvent _instance = _REvent();

  final eventID = 6000;
}

class _RImage {
  static final _RImage _instance = _RImage();

  /// 占位图
  ImageProvider placeholder({String? package}) => AssetImage("assets/images/img_placeholder.png", package: package);

  /// 网图数组
  final List<String> urls = [
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737078692/im/msg/rec/651722246582308864.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737078705/im/msg/rec/651722301611577344.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337130/im/msg/rec/652806214488559616.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337130/im/msg/rec/652806216854147072.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337130/im/msg/rec/652806216086589440.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337130/im/msg/rec/652806217546207232.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337131/im/msg/rec/652806218489925632.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337131/im/msg/rec/652806219450421248.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337131/im/msg/rec/652806220805181440.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337132/im/msg/rec/652806222130581504.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737337132/im/msg/rec/652806224420671488.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737343844/im/msg/rec/652834375670566912.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737343889/im/msg/rec/652834566318460928.jpg',
    'https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/test/message/document/1737343924/im/msg/rec/652834709679771648.png',
    "https://cdn.pixabay.com/photo/2016/09/04/08/13/harbour-crane-1643476_1280.jpg",
    "https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg",
    "https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg",
    'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
    'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
    'https://seopic.699pic.com/photo/50053/2696.jpg_wh1200.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1207/balls_3d-Abstract_design_wallpaper_1366x768.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1803/Colorful_fibre_optics_abstract_spotlight_1366x768.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1807/Blue_particle_tech_abstract_art_background_1366x768.jpg',
    "https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/Health_APP/20231219/e0a448a8201c47ed8bd46cf1ec6fe1af.jpg",
    "https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/Health_APP/20231219/56415da814454ddcb8ed83608f471619.jpg",
    "https://yl-prescription-share.oss-cn-beijing.aliyuncs.com/beta/Health_APP/20231219/3dc1b7f4e3b94a99bc5de47f3836ec96.jpg",
  ];

  /// 原理图
  final List<String> schematics = [
    'https://cos.ap-shanghai.myqcloud.com/1380-shanghai-030-sharedv4-03-1303031839/d4a3-1400349613/dd7d-%40J%401B_493001807509893120/ccc4871922cd287069d91a06cd7469fc.jpg?imageMogr2/',
    'https://cos.ap-shanghai.myqcloud.com/1380-shanghai-030-sharedv4-03-1303031839/d4a3-1400349613/dd7d-%40J%401B_493001807509893120/a66cbed49516803e2f78001a92973cf9.jpg?imageMogr2/',
    'https://cos.ap-shanghai.myqcloud.com/1380-shanghai-030-sharedv4-03-1303031839/d4a3-1400349613/dd7d-%40J%401B_493001807509893120/642684a7203f2c7d2cb67a2f35888716.jpg?imageMogr2/',
    'https://cos.ap-shanghai.myqcloud.com/1380-shanghai-030-sharedv4-03-1303031839/d4a3-1400349613/dd7d-%40J%401B_493001807509893120/c372e2821a05d58c87cc6722b712b8d0.jpg?imageMogr2/',
    'https://cos.ap-shanghai.myqcloud.com/1380-shanghai-030-sharedv4-03-1303031839/d4a3-1400349613/dd7d-%40J%401B_493001807509893120/779ff580eb4b9c4a7f72384bfbee832d.jpg?imageMogr2/',
    'https://cos.ap-shanghai.myqcloud.com/1380-shanghai-030-sharedv4-03-1303031839/d4a3-1400349613/dd7d-%40J%401B_493001807509893120/af9ecca786dabcd5f8ff1fc2d34c070f.jpg?imageMogr2/',
    'https://cos.ap-shanghai.myqcloud.com/1380-shanghai-030-sharedv4-03-1303031839/d4a3-1400349613/dd7d-%40J%401B_493001807509893120/5d092dc074a6a22c14d911d85c7e0cd7.jpg?imageMogr2/',
  ];
}
