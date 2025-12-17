extension UriExt on Uri? {
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

  /// pathSegments last
  String? lastSegment({bool decode = true}) {
    final uri = this!;
    if (uri.pathSegments.isEmpty) {
      return null;
    }
    final result = uri.pathSegments.last;
    if (!decode) {
      return result;
    }
    final last = Uri.decodeComponent(result);
    return last;
  }
}
