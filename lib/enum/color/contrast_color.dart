// ================= 撞色枚举（按第一个颜色 a 的色相整体排序） =================
import 'package:flutter/painting.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/mixin/pair_color_mixin.dart';

/// 颜色元祖
typedef ColorTuple = ({String label, Color color});

// 撞色类型
enum ContrastColor with PairColorMixin {
  // ================= 红色 / 粉红系 =================
  yangHong_jiDiLan((label: '洋红', color: Color(0xFFDB275C)), (label: '极地蓝', color: Color(0xFF41C1D2))), // A·H≈342°
  shiLiuQun_guiHuang((label: '石榴裙', color: Color(0xFFD80835)), (label: '桂黄', color: Color(0xFFEDA01F))), // A·H≈347°
  xiGuaHong_fenBai((label: '西瓜红', color: Color(0xFFCC4358)), (label: '粉白', color: Color(0xFFFFF6F6))), // A·H≈351°
  queYuHong_yueGuangJin((label: '雀羽红', color: Color(0xFFB01E29)), (label: '月光金', color: Color(0xFFEFD5B0))), // A·H≈355°
  kaDiYaHong_ruiSheJin((label: '卡地亚红', color: Color(0xFFA42227)), (label: '睿奢金', color: Color(0xFFD2D2BA))), // A·H≈358°
  zhongGuoHong_tanHei((label: '中国红', color: Color(0xFFD92121)), (label: '炭黑', color: Color(0xFF242424))), // A·H≈0°
  ningZhi_zhongGuoHong((label: '凝脂', color: Color(0xFFF5EBEB)), (label: '中国红', color: Color(0xFFD92121))), // A·H≈0°
  taiKongBai_bangDiLan((label: '太空白', color: Color(0xFFF4F4F4)), (label: '邦迪蓝', color: Color(0xFF00A5C6))), // A·H≈0°
  nuanGuangZong_luoYingFen(
      (label: '暖光棕', color: Color(0xFF7C3A2D)), (label: '落英粉', color: Color(0xFFF9E7B0))), // A·H≈10°
  // ================= 橙色 / 棕色系 =================
  zhuYanTuo_miTangJiao((label: '朱颜酡', color: Color(0xFFF29A76)), (label: '米汤娇', color: Color(0xFFF8E9D9))), // A·H≈17°
  lingXiao_qingLv((label: '凌霄', color: Color(0xFFED723F)), (label: '青绿', color: Color(0xFF215A59))), // A·H≈18°
  huLuoboCheng_naiYouHuang(
      (label: '胡萝卜橙', color: Color(0xFFE9672D)), (label: '奶油黄', color: Color(0xFFF4E3BB))), // A·H≈19°
  qianZong_miBai((label: '浅棕', color: Color(0xFF6A594F)), (label: '米白', color: Color(0xFFF4F0ED))), // A·H≈22°
  huoLiCheng_shenHaiLan((label: '活力橙', color: Color(0xFFF97316)), (label: '深海蓝', color: Color(0xFF1E3A8A))), // A·H≈25°
  baiShaCai_shiBanLv((label: '白沙彩', color: Color(0xFFECE8E5)), (label: '石板绿', color: Color(0xFF4A595B))), // A·H≈26°
  miBai_qianZong((label: '米白', color: Color(0xFFF4F0ED)), (label: '浅棕', color: Color(0xFF6A594F))), // A·H≈26°
  juZiHai_beiKeBai((label: '橘子海', color: Color(0xFFD0822F)), (label: '贝壳白', color: Color(0xFFFDE8E7))), // A·H≈31°
  guiHuang_shiLiuQun((label: '桂黄', color: Color(0xFFEDA01F)), (label: '石榴裙', color: Color(0xFFD80835))), // A·H≈38°
  miSe_qunQing((label: '米色', color: Color(0xFFF9E9CD)), (label: '群青', color: Color(0xFF3859A7))), // A·H≈38°
  fanDaiKeZong_naiShuangBai(
      (label: '凡戴克棕', color: Color(0xFF6A593A)), (label: '奶霜白', color: Color(0xFFF2F1E8))), // A·H≈39°
  naiYouHuang_huLuoboCheng(
      (label: '奶油黄', color: Color(0xFFF4E3BB)), (label: '胡萝卜橙', color: Color(0xFFE9672D))), // A·H≈42°
  ningMengTangHuang_yangQiZi(
      (label: '柠檬糖黄', color: Color(0xFFF3BF0A)), (label: '氧气紫', color: Color(0xFF7027BB))), // A·H≈47°
  jinZhanHuang_yuanWeiZi((label: '金盏黄', color: Color(0xFFFACC15)), (label: '鸢尾紫', color: Color(0xFF7C3AED))), // A·H≈48°
  miBai_xingGuangLan((label: '米白', color: Color(0xFFFCF9E8)), (label: '星光蓝', color: Color(0xFF41BBC8))), // A·H≈51°
  nuanBai_moLv((label: '暖白', color: Color(0xFFF6F4E2)), (label: '墨绿', color: Color(0xFF004D40))), // A·H≈54°
  // ================= 黄色 / 金色系 =================
  yingGuangJinHuang_moHei(
      (label: '荧光金黄', color: Color(0xFFB9F501)), (label: '墨黑', color: Color(0xFF02000E))), // A·H≈75°
  qiuXiangHuang_ganLan((label: '秋香黄', color: Color(0xFFD9F584)), (label: '绀蓝', color: Color(0xFF525AEF))), // A·H≈75°
  // ================= 绿色 / 青绿系 =================
  ganLanJunLv_qianNaiLv((label: '橄榄军绿', color: Color(0xFF636B59)), (label: '浅奶绿', color: Color(0xFFE4E7CD))), // A·H≈87°
  chaTeJiuLv_naiYouSe((label: '查特酒绿', color: Color(0xFF87C240)), (label: '奶油色', color: Color(0xFFF7F1E3))), // A·H≈87°
  shuWeiCaoLv_nuanNaiYouBai(
      (label: '鼠尾草绿', color: Color(0xFF9CAF88)), (label: '暖奶油白', color: Color(0xFFF8F5EC))), // A·H≈89°
  moZaoLv_yinHeHui((label: '墨藻绿', color: Color(0xFF4E8B22)), (label: '银河灰', color: Color(0xFFE2E2E2))), // A·H≈95°
  xianChunCaoLv_haiJunLan(
      (label: '鲜春草绿', color: Color(0xFF66C260)), (label: '海军蓝', color: Color(0xFF2B3B70))), // A·H≈116°
  suanNingLiangLv_miHuang(
      (label: '酸柠亮绿', color: Color(0xFF32B850)), (label: '米黄', color: Color(0xFFF9F1C8))), // A·H≈133°
  yingLunSaiCheLv_miBai(
      (label: '英伦赛车绿', color: Color(0xFF004225)), (label: '米白', color: Color(0xFFF7F3E9))), // A·H≈154°
  kaSiDunLv_jiSe((label: '卡斯顿绿', color: Color(0xFF005D3B)), (label: '肌色', color: Color(0xFFFCE2C4))), // A·H≈158°
  moLv_liuJin((label: '墨绿', color: Color(0xFF004D40)), (label: '鎏金', color: Color(0xFFD4AF37))), // A·H≈170°
  diFuNiLan_naiYouBai((label: '蒂芙尼蓝', color: Color(0xFF09BBB5)), (label: '奶油白', color: Color(0xFFF3F9F0))), // A·H≈178°
  maErSiLv_liZhiBai((label: '马尔斯绿', color: Color(0xFF008C8C)), (label: '荔枝白', color: Color(0xFFF2EAE0))), // A·H≈180°
  faCui_xiangYaBai((label: '法翠', color: Color(0xFF108B96)), (label: '象牙白', color: Color(0xFFEEE3D8))), // A·H≈185°
  yueBai_dianQing((label: '月白', color: Color(0xFFE5F8FA)), (label: '靛青', color: Color(0xFF723BBA))), // A·H≈186°
  shiBanLv_baiShaCai((label: '石板绿', color: Color(0xFF4A595B)), (label: '白沙彩', color: Color(0xFFECE8E5))), // A·H≈187°
  lanTie_xueBaiHui((label: '蓝铁', color: Color(0xFF39494C)), (label: '雪白灰', color: Color(0xFFE3E3E3))), // A·H≈189°
  // ================= 蓝色 / 深蓝色系 =================
  bangDiLan_taiKongBai((label: '邦迪蓝', color: Color(0xFF00A5C6)), (label: '太空白', color: Color(0xFFF4F4F4))), // A·H≈190°
  shenBaoShiLan_xiangYaBai(
      (label: '深宝石蓝', color: Color(0xFF1F3847)), (label: '象牙白', color: Color(0xFFEEE3D8))), // A·H≈202°
  daiLan_ouHe((label: '黛蓝', color: Color(0xFF304758)), (label: '藕荷', color: Color(0xFFE4C6D0))), // A·H≈206°
  beiJiaErHuLan_zhuBeiBai(
      (label: '贝加尔湖蓝', color: Color(0xFF0055B9)), (label: '珠贝白', color: Color(0xFFF4FAF9))), // A·H≈212°
  aiFuDunLan_wuSongBai((label: '埃弗顿蓝', color: Color(0xFF02388C)), (label: '雾松白', color: Color(0xFFEFFBFF))), // A·H≈217°
  keLaiYinLan_diFuNiLan(
      (label: '克莱因蓝', color: Color(0xFF002FA7)), (label: '蒂芙尼蓝', color: Color(0xFF81D8D0))), // A·H≈223°
  shenHaiLan_huoLiCheng((label: '深海蓝', color: Color(0xFF1E3A8A)), (label: '活力橙', color: Color(0xFFF97316))), // A·H≈224°
  qingHuaCi_fenQingYou((label: '青花瓷', color: Color(0xFF1F2B61)), (label: '粉青釉', color: Color(0xFFA1D2D9))), // A·H≈229°
  muShanZi_yangTuoBai((label: '暮山紫', color: Color(0xFFA4ABD6)), (label: '羊驼白', color: Color(0xFFF5F4E8))), // A·H≈232°
  xuanQing_yangTuoBai((label: '玄青', color: Color(0xFF45465E)), (label: '羊驼白', color: Color(0xFFF5F4E8))), // A·H≈238°
  yanWei_yaDianHui((label: '延维', color: Color(0xFF4A4B9D)), (label: '雅典灰', color: Color(0xFFEEE9F5))), // A·H≈239°
  // ================= 紫色 / 紫红系 =================
  yuanWeiZi_jinZhanHuang(
      (label: '鸢尾紫', color: Color(0xFF7C3AED)), (label: '金盏黄', color: Color(0xFFFACC15))), // A·H≈262°
  yangQiZi_ningMengTangHuang(
      (label: '氧气紫', color: Color(0xFF7027BB)), (label: '柠檬糖黄', color: Color(0xFFF3BF0A))), // A·H≈270°
  wuHei_yueGuangJin((label: '乌黑', color: Color(0xFF392D41)), (label: '月光金', color: Color(0xFFEFD5B0))), // A·H≈276°
  shenHeiMei_danMoZi((label: '深黑莓', color: Color(0xFF493B52)), (label: '淡漠紫', color: Color(0xFFD9CFE8))); // A·H≈277°

  // 构造函数接收两个元组
  const ContrastColor(this.a, this.b);

  // 定义两个元组属性
  final ColorTuple a;
  final ColorTuple b;

  @override
  Color get color => a.color;
  @override
  Color get other => b.color;

  String get label => [a.label, b.label].join("·");

  String get hex => [color.hex, other.hex].join(" + ");
}
