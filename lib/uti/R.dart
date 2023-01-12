
import 'package:flutter/material.dart';

///资源整合
class R {
  static final _R_String string = _R_String._OB;
  static final _R_Color color = _R_Color._OB;
  static final _R_Event event = _R_Event._OB;
  static final _R_Image image = _R_Image._OB;

}

class _R_String {
  static final _R_String _OB = _R_String();

  final share = "分享";

}

class _R_Color {
  static final _R_Color _OB = _R_Color();

  final theme = Colors.blue;

}

class _R_Event {
  static final _R_Event _OB = _R_Event();

  final eventID = 6000;

}

class _R_Image {
  static final _R_Image _OB = _R_Image();
  /// 占位图
  ImageProvider placeholder({String? package}) => AssetImage("images/img_placeholder.png", package: package);

  /// 网图数组
  final List<String> imgUrls = [
    "https://cdn.pixabay.com/photo/2016/09/04/08/13/harbour-crane-1643476_1280.jpg",
    "https://cdn.pixabay.com/photo/2022/09/01/09/31/sunset-glow-7425170_1280.jpg",
    "https://cdn.pixabay.com/photo/2018/02/01/21/00/tree-3124103_1280.jpg",
    'https://pic.616pic.com/bg_w1180/00/04/08/G5Bftx5ZDI.jpg!/fw/1120',
    'https://pic.616pic.com/bg_w1180/00/07/20/2gfqq0N3qX.jpg!/fw/1120',
    'https://desk-fd.zol-img.com.cn/t_s1920x1200c5/g5/M00/07/0E/ChMkJleEtCSIQ75fABQbWWxR5AcAATc2gJndzsAFBtx072.jpg',
    'https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg',
    'https://seopic.699pic.com/photo/50053/2696.jpg_wh1200.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1207/balls_3d-Abstract_design_wallpaper_1366x768.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1803/Colorful_fibre_optics_abstract_spotlight_1366x768.jpg',
    'https://www.10wallpaper.com/wallpaper/1366x768/1807/Blue_particle_tech_abstract_art_background_1366x768.jpg',

  ];

}