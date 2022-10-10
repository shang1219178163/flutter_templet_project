

extension MapExt on Map<String, dynamic>{
  // 拼接键值成字符串
  String join({String char = '&'}) {
    if (this.keys.length == 0) {
      return '';
    }
    String paramStr = '';
    this.forEach((key, value) {
      paramStr += '${key}=${value}${char}';
    });
    String result = paramStr.substring(0, paramStr.length - 1);
    return result;
  }
}
