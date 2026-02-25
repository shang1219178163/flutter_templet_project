class RedPacketModel {
  const RedPacketModel({
    required this.x,
    required this.size,
    required this.duration,
    required this.startY,
  });

  final double x; // 0~1 的相对横向位置
  final double size;
  final Duration duration;

  /// 新增：出生点（屏幕外）
  final double startY;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'x': x,
      'size': size,
      'duration': duration,
      'startY': startY,
    };
  }
}
