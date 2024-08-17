import 'package:flutter/material.dart';

///资源整合
class R {
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
  ImageProvider placeholder({String? package}) =>
      AssetImage("assets/images/img_placeholder.png", package: package);

  /// 网图数组
  final List<String> urls = [
    "https://cdn.pixabay.com/photo/2016/09/04/08/13/harbour-crane-1643476_1280.jpg",
    "https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg",
    "https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg",
    'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
    'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
    'https://seopic.699pic.com/photo/50053/2696.jpg_wh1200.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1207/balls_3d-Abstract_design_wallpaper_1366x768.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1803/Colorful_fibre_optics_abstract_spotlight_1366x768.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1807/Blue_particle_tech_abstract_art_background_1366x768.jpg',
  ];
}
