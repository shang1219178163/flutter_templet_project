import 'package:color_converter/color_converter.dart' as cc;
import 'package:flutter/material.dart';

//排序说明：
//色相（Hue）优先：按红、橙、黄、绿、青、蓝、紫的视觉过渡顺序排列。
//
//明度/饱和度微调：同一色系下，纯正鲜亮的颜色排前，暗沉/深色调排后（如朱砂红在酒红/勃艮第红之前，因为后者更暗）。
//
//炭黑作为无色系（饱和度极低）放在了最后面，因为它不会与任何特定的色相相邻。

// ================= 父枚举类 =================
abstract class BaseColor {
  String get label;
  Color get color;
  String get hex; // 字符串类型色值
}

// ================= 合并后的统一颜色枚举（按视觉相近度/色相环排序） =================
enum ClassicColor implements BaseColor {
  // --- 红/橙系 (Hue 0° - 45°) ---
  zhongGuoHong('中国红', Color(0xFFD92121), '#D92121'), // H≈0°
  zhushaHong('朱砂红', Color(0xFFB22712), '#B22712'), // H≈5°
  tixiangHong('提香红', Color(0xFFD44848), '#D44848'), // H≈8°
  shanHuCheng('珊瑚橙', Color(0xFFFF6F61), '#FF6F61'), // H≈10°
  huoLiCheng('活力橙', Color(0xFFF97316), '#F97316'), // H≈25°
  fanDaikeZong('范戴克棕', Color(0xFF492D22), '#492D22'), // H≈30° (深橙棕)
  boGengDiHong('勃艮第红', Color(0xFF470024), '#470024'), // H≈340° (深紫红)
  jiuHong('酒红', Color(0xFF800020), '#800020'), // H≈345° (深紫红)

  // --- 黄/金系 (Hue 45° - 70°) ---
  huPoHuang('琥珀黄', Color(0xFFFFB90F), '#FFB90F'), // H≈43°
  jieMoHuang('芥末黄', Color(0xFFD4A017), '#D4A017'), // H≈45°
  liuJin('鎏金', Color(0xFFD4AF37), '#D4AF37'), // H≈46°
  shenBuLunHuang('申布伦黄', Color(0xFFFBD26A), '#FBD26A'), // H≈48°
  jinZhanHuang('金盏黄', Color(0xFFFACC15), '#FACC15'), // H≈55°
  yangGuangHuang('阳光黄', Color(0xFFFFDE21), '#FFDE21'), // H≈55°
  xiYeHuang('细叶黄', Color(0xFFE6DF44), '#E6DF44'), // H≈60°

  // --- 绿/青系 (Hue 90° - 190°) ---
  senLinLv('森林绿', Color(0xFF228B22), '#228B22'), // H≈120°
  liuliLv('琉璃绿', Color(0xFF01795D), '#01795D'), // H≈165°
  zuMuLv('祖母绿', Color(0xFF00755A), '#00755A'), // H≈166°
  moLv('墨绿', Color(0xFF004D40), '#004D40'), // H≈170°
  maErSiLv('马尔斯绿', Color(0xFF01847F), '#01847F'), // H≈172°
  shuiYaQing('水鸭青', Color(0xFF008080), '#008080'), // H≈180°
  kongQueLan('孔雀蓝', Color(0xFF0DAFC6), '#0DAFC6'), // H≈186°

  // --- 蓝/紫系 (Hue 190° - 330°) ---
  qingKongLan('晴空蓝', Color(0xFF87CEEB), '#87CEEB'), // H≈200°
  shenHaiLan('深海蓝', Color(0xFF1E3A8A), '#1E3A8A'), // H≈220°
  qingShanLan('晴山蓝', Color(0xFF15336E), '#15336E'), // H≈220°
  puLuShiLan('普鲁士蓝', Color(0xFF003153), '#003153'), // H≈225°
  keLaiYinLan('克莱因蓝', Color(0xFF002FA7), '#002FA7'), // H≈230°
  yuanweiLan('鸢尾蓝', Color(0xFF0F3AEB), '#0F3AEB'), // H≈240°
  dianLan('靛蓝', Color(0xFF3F37C9), '#3F37C9'), // H≈250°
  yuanweiZi('鸢尾紫', Color(0xFF7C3AED), '#7C3AED'), // H≈260°
  ningYeZi('凝夜紫', Color(0xFF47176D), '#47176D'), // H≈280°
  taoYao('桃夭', Color(0xFFEE337C), '#EE337C'), // H≈330°

  // --- 中性色 (无色彩系) ---
  tanHei('炭黑', Color(0xFF242424), '#242424'); // H=0°, S=0%

  const ClassicColor(this.label, this.color, this.hex);

  @override
  final String label;
  @override
  final Color color;
  @override
  final String hex;

  (int, int, int) get rgb {
    return (
      (color.r * 255).round(),
      (color.g * 255).round(),
      (color.b * 255).round(),
    );
  }

  String get rgbText {
    final (r, g, b) = rgb;
    return '($r,$g,$b)';
  }

  String get cmykText {
    final (r, g, b) = rgb;
    final cmyk = cc.RGB(r: r, g: g, b: b).toCmyk();
    return '(${cmyk.c},${cmyk.m},${cmyk.y},${cmyk.k})';
  }

  /// 色值详情行：#HEX  RGB(...)  CMYK(...)
  String get detailLine => '$hex  RGB$rgbText  CMYK$cmykText';
}

// ================= 对比色（引用 ClassicColor 枚举值） =================
enum ContrastColor {
  moLvLiuJin(ClassicColor.moLv, ClassicColor.liuJin, '绿金华贵撞色'),
  shenHaiLanHuoLiCheng(ClassicColor.shenHaiLan, ClassicColor.huoLiCheng, '蓝橙活力撞色'),
  yuanweiZiJinZhanHuang(ClassicColor.yuanweiZi, ClassicColor.jinZhanHuang, '紫金典雅撞色'),
  shanHuChengShuiYaQing(ClassicColor.shanHuCheng, ClassicColor.shuiYaQing, '珊瑚水鸭撞色'),
  jiuHongSenLinLv(ClassicColor.jiuHong, ClassicColor.senLinLv, '酒红森绿撞色'),
  zhongGuoHongTanHei(ClassicColor.zhongGuoHong, ClassicColor.tanHei, '红黑经典撞色'),
  qingKongLanYangGuangHuang(ClassicColor.qingKongLan, ClassicColor.yangGuangHuang, '蓝黄晴空撞色'),
  jieMoHuangDianLan(ClassicColor.jieMoHuang, ClassicColor.dianLan, '芥末靛蓝撞色');

  const ContrastColor(this.colorA, this.colorB, this.style);

  final ClassicColor colorA;
  final ClassicColor colorB;

  /// 撞色风格名，如「绿金华贵撞色」
  final String style;

  String get label => '${colorA.label} + ${colorB.label}';

  String get tabLabel => '${colorA.label}·${colorB.label}';

  /// 按 Tab 动画进度 [t] 插值相邻撞色的 (背景色A, 前景色B)
  static (Color, Color) lerpColors(double t) {
    // 全部撞色枚举
    final values = ContrastColor.values;
    // 当前页下标（向下取整）
    final i = t.floor().clamp(0, values.length - 1);
    // 下一页下标（末页时与 i 相同）
    final j = (i + 1).clamp(0, values.length - 1);
    // 两页之间的插值比例 [0, 1]
    final frac = (t - i).clamp(0.0, 1.0);
    // 背景色：相邻两页 colorA 插值
    final bg = Color.lerp(values[i].colorA.color, values[j].colorA.color, frac)!;
    // 前景色：相邻两页 colorB 插值
    final fg = Color.lerp(values[i].colorB.color, values[j].colorB.color, frac)!;
    // 返回 (背景, 前景)
    return (bg, fg);
  }
}
