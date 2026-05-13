/// 交易类型
enum CustomerBalanceBizTypeEnum {
  ALL(-1, "全部"),
  LUCKY_BAG(1, "福袋"),
  RED_PACKET(2, "红包"),
  GIFT(3, "送礼"),
  ACTIVITY_REWARD(4, "活动奖励"),
  OTHER(5, "其他");

  const CustomerBalanceBizTypeEnum(this.value, this.desc);
  final int value;
  final String desc;

  @override
  String toString() {
    return "$runtimeType $desc: $value";
  }
}

/// 交易类型子类
enum CustomerBalanceBizSubTypeEnum {
  // ===== 福袋 =====
  LUCKY_BAG_OPEN_INCOME(1, "收入-开福袋"),
  LUCKY_BAG_REFUND(2, "收入-福袋退回"),
  LUCKY_BAG_SEND_EXPENSE(3, "支出-发福袋"),

  // ===== 红包 =====
  RED_PACKET_OPEN_EXPERT(10, "收入-开红包(专家)"),
  RED_PACKET_OPEN_OFFICIAL(11, "收入-开红包(官方)"),
  RED_PACKET_SEND_EXPENSE(12, "支出-发红包"),

  // ===== 送礼 =====
  GIFT_INCOME(20, "收入-送礼"),
  GIFT_SEND_EXPENSE(21, "支出-给专家送礼"),
  GIFT_GIVE_HEART_EXPENSE(22, "支出-给专家赠送小心心"),

  // ===== 活动奖励 =====
  ACTIVITY_SIGN_IN_INCOME(30, "收入-签到奖励"),
  ACTIVITY_TASK_ACTIVE_INCOME(31, "收入-活跃任务奖励"),
  ACTIVITY_TASK_DURATION_INCOME(32, "收入-时长任务奖励"),
  ACTIVITY_LIVE_SESSION_INCOME(33, "收入-直播场次奖励"),

  // ===== 其他 =====
  OTHER_INCOME(40, "收入-其他"),
  OTHER_REDEEM_ENTRY_EFFECT_EXPENSE(41, "支出-兑换礼品-入场特效"),
  OTHER_REDEEM_AVATAR_FRAME_EXPENSE(42, "支出-兑换礼品-头像框"),
  OTHER_REDEEM_BUBBLE_EXPENSE(43, "支出-兑换礼品-气泡框"),

  //===== 其他 =====
  PLATFORM_REWARD(50, "收入-平台奖励"),
  LIVE_REWARD(51, "收入-直播奖励"),
  ;

  const CustomerBalanceBizSubTypeEnum(this.value, this.desc);
  final int value;
  final String desc;

  @override
  String toString() {
    return "$runtimeType $desc: $value";
  }
}
