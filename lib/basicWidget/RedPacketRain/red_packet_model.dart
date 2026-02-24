class RedPacketModel {
  const RedPacketModel({
    required this.x,
    required this.size,
    required this.duration,
  });

  final double x; // 0~1 的相对横向位置
  final double size;
  final Duration duration;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'x': x,
      'size': size,
      'duration': duration,
    };
  }
}
