import 'package:color_converter/color_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/mixin/pair_color_mixin.dart';

/// 颜色元祖
typedef ColorTuple = ({String label, Color color});

// ================= 父枚举类 =================
abstract class BaseColor {
  String get label;
  Color get color;
}

// ================= 完整单色枚举（包含所有对比色所需的依赖） =================
enum ClassicColor implements BaseColor {
  // ================= 红色 / 粉红系 (Hue 0° - 15° / 330° - 360°) =================
  yingHuaFen('樱花粉', Color(0xFFF78A88)), // H≈0° (浅红)
  tiXiangHong('提香红', Color(0xFFD44848)), // H≈0°
  zhuSha('朱砂', Color(0xFFD30121)), // H≈0°
  zhuShaHong('朱砂红', Color(0xFFB22712)), // H≈5°
  boGengDiHong('勃艮第红', Color(0xFF470024)), // H≈340° (深红)
  taoYao('桃夭', Color(0xFFEE337C)), // H≈330° (粉红)
  meiGuiFen('玫瑰粉', Color(0xFFF9D2E4)), // H≈330° (浅粉)
  baBiFen('芭比粉', Color(0xFFF1BBC9)), // H≈350° (浅粉)

  // ================= 橙色 / 棕色系 (Hue 15° - 45°) =================
  zhuanHeZong('砖褐棕', Color(0xFF8D4726)), // H≈20°
  fanDaiKeZong('范戴克棕', Color(0xFF492D22)), // H≈20° (深棕)
  huPoHuang2('琥珀黄_2', Color(0xFFF9B800)), // H≈43° (橙黄)
  huPoHuang('琥珀黄', Color(0xFFFFB90F)), // H≈43°
  shenBuLunHuang('申布伦黄', Color(0xFFFBD26A)), // H≈45° (浅橙黄)

  // ================= 黄色 / 黄绿系 (Hue 45° - 70°) =================
  xiYeHuang('细叶黄', Color(0xFFE6DF44)), // H≈58° (黄绿)
  ningMengHuang2('柠檬黄_2', Color(0xFFFFFF00)), // H≈60°
  ningMengHuang('柠檬黄', Color(0xFFF0FF0A)), // H≈63° (偏绿黄)

  // ================= 绿色 / 青绿系 (Hue 70° - 180°) =================
  taiLv('苔绿', Color(0xFF4D613C)), // H≈92° (深灰绿)
  zuMuLv('祖母绿', Color(0xFF00755A)), // H≈160° (宝石绿)
  liuliLv('琉璃绿', Color(0xFF01795D)), // H≈165°
  maErSiLv('马尔斯绿', Color(0xFF01847F)), // H≈172° (青绿)
  diFuNiLan('蒂芙尼蓝', Color(0xFF0ABAB5)), // H≈178° (青)
  kongQueLan('孔雀蓝', Color(0xFF0DAFC6)), // H≈186° (青蓝)
  boHeQing('薄荷青', Color(0xFFBBF0EA)), // H≈180° (极浅青)
  qingQueTouDai('青雀头黛', Color(0xFF153C46)), // H≈190° (深灰青)

  // ================= 蓝色系 (Hue 200° - 250°) =================
  tianQing('天青', Color(0xFFBFDEFF)), // H≈210° (极浅蓝)
  bangDiLan('邦迪蓝', Color(0xFF0095B6)),
  haiLan('海蓝', Color(0xFF1E9BFF)), // H≈210° (明蓝)
  facebookLan('Facebook蓝', Color(0xFF1877F2)), // H≈220°
  qingShanLan('晴山蓝', Color(0xFF15336E)), // H≈220° (深蓝)
  puLuShiLan('普鲁士蓝', Color(0xFF003153)), // H≈225° (深靛蓝)
  niuJinLan('牛津蓝', Color(0xFF002147)), // H≈225° (深蓝)
  huangJiaLan('皇家蓝', Color(0xFF4169E1)), // H≈225°
  qunQing('群青', Color(0xFF4169E1)), // H≈225° (与皇家蓝同色值)
  keLaiYinLan('克莱因蓝', Color(0xFF002FA7)), // H≈230° (亮深蓝)
  yuanweiLan('鸢尾蓝', Color(0xFF0F3AEB)), // H≈240° (蓝紫)
  qingShuiLan('清水蓝', Color(0xFF3F389F)), // H≈245° (偏紫蓝)
  jingDianLan('经典蓝', Color(0xFF483D8B)), // H≈245° (暗蓝紫)

  // ================= 紫色系 (Hue 250° - 330°) =================
  diWangZi('帝王紫', Color(0xFF6A0DAD)), // H≈275°
  ningYeZi('凝夜紫', Color(0xFF47176D)); // H≈280°

  const ClassicColor(this.label, this.color);

  @override
  final String label;
  @override
  final Color color;

  String get hex => color.toHex();

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
    final cmyk = RGB(r: r, g: g, b: b).toCmyk();
    return '(${cmyk.c},${cmyk.m},${cmyk.y},${cmyk.k})';
  }

  /// 色值详情行：#HEX  RGB(...)  CMYK(...)
  String get detailLine => '$hex  RGB$rgbText  CMYK$cmykText';
}

// ================= 撞色枚举（按第一个颜色 a 的色相整体排序） =================
enum ContrastColor with PairColorMixin {
  // ================= 红色 / 粉红系 =================
  yangHong_jiDiLan(
      (label: '洋红', decoration: Color(0xFFDB275C)), (label: '极地蓝', decoration: Color(0xFF41C1D2))), // A·H≈342°
  shiLiuQun_guiHuang(
      (label: '石榴裙', decoration: Color(0xFFD80835)), (label: '桂黄', decoration: Color(0xFFEDA01F))), // A·H≈347°
  xiGuaHong_fenBai(
      (label: '西瓜红', decoration: Color(0xFFCC4358)), (label: '粉白', decoration: Color(0xFFFFF6F6))), // A·H≈351°
  queYuHong_yueGuangJin(
      (label: '雀羽红', decoration: Color(0xFFB01E29)), (label: '月光金', decoration: Color(0xFFEFD5B0))), // A·H≈355°
  kaDiYaHong_ruiSheJin(
      (label: '卡地亚红', decoration: Color(0xFFA42227)), (label: '睿奢金', decoration: Color(0xFFD2D2BA))), // A·H≈358°
  zhongGuoHong_tanHei(
      (label: '中国红', decoration: Color(0xFFD92121)), (label: '炭黑', decoration: Color(0xFF242424))), // A·H≈0°
  ningZhi_zhongGuoHong(
      (label: '凝脂', decoration: Color(0xFFF5EBEB)), (label: '中国红', decoration: Color(0xFFD92121))), // A·H≈0°
  taiKongBai_bangDiLan(
      (label: '太空白', decoration: Color(0xFFF4F4F4)), (label: '邦迪蓝', decoration: Color(0xFF00A5C6))), // A·H≈0°
  nuanGuangZong_luoYingFen(
      (label: '暖光棕', decoration: Color(0xFF7C3A2D)), (label: '落英粉', decoration: Color(0xFFF9E7B0))), // A·H≈10°
  // ================= 橙色 / 棕色系 =================
  zhuYanTuo_miTangJiao(
      (label: '朱颜酡', decoration: Color(0xFFF29A76)), (label: '米汤娇', decoration: Color(0xFFF8E9D9))), // A·H≈17°
  lingXiao_qingLv(
      (label: '凌霄', decoration: Color(0xFFED723F)), (label: '青绿', decoration: Color(0xFF215A59))), // A·H≈18°
  huLuoboCheng_naiYouHuang(
      (label: '胡萝卜橙', decoration: Color(0xFFE9672D)), (label: '奶油黄', decoration: Color(0xFFF4E3BB))), // A·H≈19°
  qianZong_miBai((label: '浅棕', decoration: Color(0xFF6A594F)), (label: '米白', decoration: Color(0xFFF4F0ED))), // A·H≈22°
  huoLiCheng_shenHaiLan(
      (label: '活力橙', decoration: Color(0xFFF97316)), (label: '深海蓝', decoration: Color(0xFF1E3A8A))), // A·H≈25°
  baiShaCai_shiBanLv(
      (label: '白沙彩', decoration: Color(0xFFECE8E5)), (label: '石板绿', decoration: Color(0xFF4A595B))), // A·H≈26°
  miBai_qianZong((label: '米白', decoration: Color(0xFFF4F0ED)), (label: '浅棕', decoration: Color(0xFF6A594F))), // A·H≈26°
  juZiHai_beiKeBai(
      (label: '橘子海', decoration: Color(0xFFD0822F)), (label: '贝壳白', decoration: Color(0xFFFDE8E7))), // A·H≈31°
  guiHuang_shiLiuQun(
      (label: '桂黄', decoration: Color(0xFFEDA01F)), (label: '石榴裙', decoration: Color(0xFFD80835))), // A·H≈38°
  miSe_qunQing((label: '米色', decoration: Color(0xFFF9E9CD)), (label: '群青', decoration: Color(0xFF3859A7))), // A·H≈38°
  fanDaiKeZong_naiShuangBai(
      (label: '凡戴克棕', decoration: Color(0xFF6A593A)), (label: '奶霜白', decoration: Color(0xFFF2F1E8))), // A·H≈39°
  naiYouHuang_huLuoboCheng(
      (label: '奶油黄', decoration: Color(0xFFF4E3BB)), (label: '胡萝卜橙', decoration: Color(0xFFE9672D))), // A·H≈42°
  ningMengTangHuang_yangQiZi(
      (label: '柠檬糖黄', decoration: Color(0xFFF3BF0A)), (label: '氧气紫', decoration: Color(0xFF7027BB))), // A·H≈47°
  jinZhanHuang_yuanWeiZi(
      (label: '金盏黄', decoration: Color(0xFFFACC15)), (label: '鸢尾紫', decoration: Color(0xFF7C3AED))), // A·H≈48°
  nuanBai_moLv((label: '暖白', decoration: Color(0xFFF6F4E2)), (label: '墨绿', decoration: Color(0xFF004D40))), // A·H≈54°
  // ================= 黄色 / 金色系 =================
  yingGuangJinHuang_moHei(
      (label: '荧光金黄', decoration: Color(0xFFB9F501)), (label: '墨黑', decoration: Color(0xFF02000E))), // A·H≈75°
  qiuXiangHuang_ganLan(
      (label: '秋香黄', decoration: Color(0xFFD9F584)), (label: '绀蓝', decoration: Color(0xFF525AEF))), // A·H≈75°
  // ================= 绿色 / 青绿系 =================
  ganLanJunLv_qianNaiLv(
      (label: '橄榄军绿', decoration: Color(0xFF636B59)), (label: '浅奶绿', decoration: Color(0xFFE4E7CD))), // A·H≈87°
  chaTeJiuLv_naiYouSe(
      (label: '查特酒绿', decoration: Color(0xFF87C240)), (label: '奶油色', decoration: Color(0xFFF7F1E3))), // A·H≈87°
  shuWeiCaoLv_nuanNaiYouBai(
      (label: '鼠尾草绿', decoration: Color(0xFF9CAF88)), (label: '暖奶油白', decoration: Color(0xFFF8F5EC))), // A·H≈89°
  moZaoLv_yinHeHui(
      (label: '墨藻绿', decoration: Color(0xFF4E8B22)), (label: '银河灰', decoration: Color(0xFFE2E2E2))), // A·H≈95°
  xianChunCaoLv_haiJunLan(
      (label: '鲜春草绿', decoration: Color(0xFF66C260)), (label: '海军蓝', decoration: Color(0xFF2B3B70))), // A·H≈116°
  suanNingLiangLv_miHuang(
      (label: '酸柠亮绿', decoration: Color(0xFF32B850)), (label: '米黄', decoration: Color(0xFFF9F1C8))), // A·H≈133°
  yingLunSaiCheLv_miBai(
      (label: '英伦赛车绿', decoration: Color(0xFF004225)), (label: '米白', decoration: Color(0xFFF7F3E9))), // A·H≈154°
  kaSiDunLv_jiSe(
      (label: '卡斯顿绿', decoration: Color(0xFF005D3B)), (label: '肌色', decoration: Color(0xFFFCE2C4))), // A·H≈158°
  moLv_liuJin((label: '墨绿', decoration: Color(0xFF004D40)), (label: '鎏金', decoration: Color(0xFFD4AF37))), // A·H≈170°
  diFuNiLan_naiYouBai(
      (label: '蒂芙尼蓝', decoration: Color(0xFF09BBB5)), (label: '奶油白', decoration: Color(0xFFF3F9F0))), // A·H≈178°
  maErSiLv_liZhiBai(
      (label: '马尔斯绿', decoration: Color(0xFF008C8C)), (label: '荔枝白', decoration: Color(0xFFF2EAE0))), // A·H≈180°
  faCui_xiangYaBai(
      (label: '法翠', decoration: Color(0xFF108B96)), (label: '象牙白', decoration: Color(0xFFEEE3D8))), // A·H≈185°
  yueBai_dianQing(
      (label: '月白', decoration: Color(0xFFE5F8FA)), (label: '靛青', decoration: Color(0xFF723BBA))), // A·H≈186°
  shiBanLv_baiShaCai(
      (label: '石板绿', decoration: Color(0xFF4A595B)), (label: '白沙彩', decoration: Color(0xFFECE8E5))), // A·H≈187°
  lanTie_xueBaiHui(
      (label: '蓝铁', decoration: Color(0xFF39494C)), (label: '雪白灰', decoration: Color(0xFFE3E3E3))), // A·H≈189°
  // ================= 蓝色 / 深蓝色系 =================
  bangDiLan_taiKongBai(
      (label: '邦迪蓝', decoration: Color(0xFF00A5C6)), (label: '太空白', decoration: Color(0xFFF4F4F4))), // A·H≈190°
  shenBaoShiLan_xiangYaBai(
      (label: '深宝石蓝', decoration: Color(0xFF1F3847)), (label: '象牙白', decoration: Color(0xFFEEE3D8))), // A·H≈202°
  daiLan_ouHe((label: '黛蓝', decoration: Color(0xFF304758)), (label: '藕荷', decoration: Color(0xFFE4C6D0))), // A·H≈206°
  beiJiaErHuLan_zhuBeiBai(
      (label: '贝加尔湖蓝', decoration: Color(0xFF0055B9)), (label: '珠贝白', decoration: Color(0xFFF4FAF9))), // A·H≈212°
  aiFuDunLan_wuSongBai(
      (label: '埃弗顿蓝', decoration: Color(0xFF02388C)), (label: '雾松白', decoration: Color(0xFFEFFBFF))), // A·H≈217°
  keLaiYinLan_diFuNiLan(
      (label: '克莱因蓝', decoration: Color(0xFF002FA7)), (label: '蒂芙尼蓝', decoration: Color(0xFF81D8D0))), // A·H≈223°
  shenHaiLan_huoLiCheng(
      (label: '深海蓝', decoration: Color(0xFF1E3A8A)), (label: '活力橙', decoration: Color(0xFFF97316))), // A·H≈224°
  qingHuaCi_fenQingYou(
      (label: '青花瓷', decoration: Color(0xFF1F2B61)), (label: '粉青釉', decoration: Color(0xFFA1D2D9))), // A·H≈229°
  muShanZi_yangTuoBai(
      (label: '暮山紫', decoration: Color(0xFFA4ABD6)), (label: '羊驼白', decoration: Color(0xFFF5F4E8))), // A·H≈232°
  xuanQing_yangTuoBai(
      (label: '玄青', decoration: Color(0xFF45465E)), (label: '羊驼白', decoration: Color(0xFFF5F4E8))), // A·H≈238°
  yanWei_yaDianHui(
      (label: '延维', decoration: Color(0xFF4A4B9D)), (label: '雅典灰', decoration: Color(0xFFEEE9F5))), // A·H≈239°
  // ================= 紫色 / 紫红系 =================
  yuanWeiZi_jinZhanHuang(
      (label: '鸢尾紫', decoration: Color(0xFF7C3AED)), (label: '金盏黄', decoration: Color(0xFFFACC15))), // A·H≈262°
  yangQiZi_ningMengTangHuang(
      (label: '氧气紫', decoration: Color(0xFF7027BB)), (label: '柠檬糖黄', decoration: Color(0xFFF3BF0A))), // A·H≈270°
  wuHei_yueGuangJin(
      (label: '乌黑', decoration: Color(0xFF392D41)), (label: '月光金', decoration: Color(0xFFEFD5B0))), // A·H≈276°
  shenHeiMei_danMoZi(
      (label: '深黑莓', decoration: Color(0xFF493B52)), (label: '淡漠紫', decoration: Color(0xFFD9CFE8))); // A·H≈277°

  // 构造函数接收两个元组
  const ContrastColor(this.a, this.b);

  // 定义两个元组属性
  final ColorTuple a;
  final ColorTuple b;

  @override
  Color get color => a.decoration;
  @override
  Color get other => b.decoration;

  String get label => [a.label, b.label].join("·");

  String get hex => [color.hex, other.hex].join(" + ");
}

extension ColorExtension on Color {
  String get hex {
    final (r, g, b) = rgb;
    return '#${r.toRadixString(16).padLeft(2, '0')}'
            '${g.toRadixString(16).padLeft(2, '0')}'
            '${b.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  (int, int, int) get rgb {
    return ((r * 255).round(), (g * 255).round(), (b * 255).round());
  }

  String get rgbText {
    final (r, g, b) = rgb;
    return '($r,$g,$b)';
  }

  String get cmykText {
    final (r, g, b) = rgb;
    final cmyk = RGB(r: r, g: g, b: b).toCmyk();
    return '(${cmyk.c},${cmyk.m},${cmyk.y},${cmyk.k})';
  }

  /// 色值详情行：#HEX  RGB(...)  CMYK(...)
  String get detailLine => '$hex  RGB$rgbText  CMYK$cmykText';
}
