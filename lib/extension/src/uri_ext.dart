extension UriExt on Uri {
  /// 是网络视频
  bool get isVideo {
    final path = "$this";
    if (path.isNotEmpty != true) {
      return false;
    }
    final videoExt = ['.mp4', '.mov', '.avi', '.wmv', '.flv', '.mkv', '.webm'];
    final ext = path.toLowerCase();
    final result = videoExt.any((e) => ext.endsWith(e));
    return result;
  }
}
