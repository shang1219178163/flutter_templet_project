import 'package:flutter/cupertino.dart';
import 'package:flutter_templet_project/generated/assets.dart';

enum GoodsCategoryEnum {
  gift(
    value: 1,
    code: 'gift',
    desc: '直播礼物',
    color: Color(0x1AFFFFFF),
    logo: AssetImage(Assets.shopIcLiveGift),
    colorLight: Color(0xFFFDEFEF),
    logoLight: AssetImage(Assets.shopIcLiveGiftLight),
    itemHeight: 82,
    rowCount: 4,
    ownedDesc: "可在直播间直接赠送该礼物",
    equippedTips: "",
  ),
  bubble(
    value: 2,
    code: 'bubble',
    desc: '聊天气泡',
    color: Color(0x1AFFFFFF),
    logo: AssetImage(Assets.shopIcLiveChat),
    colorLight: Color(0xFFFFF4EC),
    logoLight: AssetImage(Assets.shopIcLiveChatLight),
    itemHeight: 90,
    rowCount: 4,
    ownedDesc: "立即装扮",
    equippedTips: "装扮成功，发条消息试试吧",
  ),
  enter_effect(
    value: 3,
    code: 'enter_effect',
    desc: '入场特效',
    color: Color(0x1AFFFFFF),
    logo: AssetImage(Assets.shopIcLiveSpecialEffects),
    colorLight: Color(0xFFFEF7E5),
    logoLight: AssetImage(Assets.shopIcLiveSpecialEffectsLight),
    itemHeight: 104,
    rowCount: 1,
    ownedDesc: "立即装扮",
    equippedTips: "装扮成功，去直播间试试吧",
  ),
  ;

  const GoodsCategoryEnum({
    required this.value,
    required this.code,
    required this.desc,
    required this.color,
    required this.logo,
    required this.colorLight,
    required this.logoLight,
    required this.itemHeight,
    required this.rowCount,
    required this.ownedDesc,
    required this.equippedTips,
  });

  /// 当前枚举值对应的 int 值(非 index)
  final int value;

  /// 当前枚举对应的 描述文字
  final String code;

  /// 当前枚举对应的 描述文字
  final String desc;

  final Color color;
  final AssetImage logo;

  final Color colorLight;
  final AssetImage logoLight;

  final int itemHeight;
  final int rowCount;

  /// owned提示语
  final String ownedDesc;

  /// 装扮成功提示语
  final String equippedTips;

  @override
  String toString() {
    return '$desc is $value';
  }
}
