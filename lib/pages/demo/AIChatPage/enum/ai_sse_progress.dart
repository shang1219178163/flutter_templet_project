/// SSE 流进度：区分「未出字就断」与「有字无 DONE」
enum AiSseProgress {
  idle('未出字'),
  hasDelta('已有正文'),
  done('已结束');

  const AiSseProgress(this.desc);

  /// 中文描述
  final String desc;
}
