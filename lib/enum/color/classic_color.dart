import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

// ================= 父枚举类 =================
abstract class BaseColor {
  String get label;
  Color get color;
}

// ================= 完整单色枚举（按色相整体排序） =================
enum ClassicColor implements BaseColor {
  // ================= 红色 / 粉红系 =================
  boGengDiHong('勃艮第红', Color(0xFF470024)), // H≈330°
  taoYao('桃夭', Color(0xFFEE337C)), // H≈337°
  zhuSha('朱砂', Color(0xFFD30121)), // H≈351°
  zhuShaHong('朱砂红', Color(0xFFB22712)), // H≈8°
  tiXiangHong('提香红', Color(0xFFD44848)), // H≈0°
  yingHuaFen('樱花粉', Color(0xFFF78A88)), // H≈1°

  // ================= 橙色 / 棕色系 =================
  fanDaiKeZong('范戴克棕', Color(0xFF492D22)), // H≈17°
  zhuanHeZong('砖褐棕', Color(0xFF8D4726)), // H≈19°
  huPoHuang('琥珀黄', Color(0xFFFFB90F)), // H≈42°
  shenBuLunHuang('申布伦黄', Color(0xFFFBD26A)), // H≈43°
  huPoHuang2('琥珀黄_2', Color(0xFFF9B800)), // H≈44°
  // ================= 黄色 / 黄绿系 =================
  xiYeHuang('细叶黄', Color(0xFFE6DF44)), // H≈57°
  // ================= 绿色 / 青绿系 =================
  taiLv('苔绿', Color(0xFF4D613C)), // H≈92°
  liuliLv('琉璃绿', Color(0xFF01795D)), // H≈166°
  zuMuLv('祖母绿', Color(0xFF00755A)), // H≈166°
  maErSiLv('马尔斯绿', Color(0xFF01847F)), // H≈178°
  diFuNiLan('蒂芙尼蓝', Color(0xFF0ABAB5)), // H≈178°
  kongQueLan('孔雀蓝', Color(0xFF0DAFC6)), // H≈187°
  // ================= 蓝色系 =================
  bangDiLan('邦迪蓝', Color(0xFF0095B6)), // H≈191°
  lianHeGuoLan('联合国蓝', Color(0xFF009EDB)), // H≈197°
  haiLan('海蓝', Color(0xFF1E9BFF)), // H≈207°
  tianQing('天青', Color(0xFF007FFF)), // H≈210°
  facebookLan('Facebook蓝', Color(0xFF1877F2)), // H≈214°
  huangJiaLan('皇家蓝', Color(0xFF4169E1)), // H≈225°
  yuanweiLan('鸢尾蓝', Color(0xFF0F3AEB)), // H≈228°
  keLaiYinLan('克莱因蓝', Color(0xFF002FA7)), // H≈223°
  qingShanLan('晴山蓝', Color(0xFF15336E)), // H≈220°

  qingQueTouDai('青雀头黛', Color(0xFF153C46)), // H≈192°
  puLuShiLan('普鲁士蓝', Color(0xFF003153)), // H≈205°
  niuJinLan('牛津蓝', Color(0xFF002147)), // H≈212°
  // ================= 紫色系 =================
  ningYeZi('凝夜紫', Color(0xFF47176D)), // H≈273°
  diWangZi('帝王紫', Color(0xFF6A0DAD)); // H≈275°

  const ClassicColor(this.label, this.color);

  @override
  final String label;
  @override
  final Color color;

  String get hex => color.hex;

  /// 色值详情行：`#HEX  RGB(...)  CMYK(...)`
  String get detailLine => '$hex  RGB${color.rgbText}  CMYK${color.cmykText}';
}
