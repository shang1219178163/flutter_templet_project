// file: core/file_reader.dart
import 'dart:io';
import 'dart:typed_data';

/// 通用文件读取器接口
abstract class NFileReader<T> {
  /// 判断是否能处理某种扩展名
  bool canRead(String extension);

  /// 异步读取文件内容，返回类型由实现定义
  Future<T> readContent({required String path});
}

/// 二进制文件读取器
class BinaryFileReader implements NFileReader<Uint8List> {
  static const _exts = ['png', 'jpg', 'jpeg', 'gif', 'pdf', 'webp'];

  @override
  bool canRead(String extension) => _exts.contains(extension.toLowerCase());

  @override
  Future<Uint8List> readContent({required String path}) async {
    final f = File(path);
    if (!f.existsSync()) {
      throw Exception('文件不存在: $path');
    }
    return f.readAsBytes();
  }
}

/// 文本文件读取器
class TextFileReader implements NFileReader<String> {
  static const _exts = ['txt', 'log', 'json', 'xml', 'yaml', 'md'];

  @override
  bool canRead(String extension) => _exts.contains(extension.toLowerCase());

  @override
  Future<String> readContent({required String path}) async {
    final f = File(path);
    if (!f.existsSync()) {
      throw Exception('文件不存在: $path');
    }
    return f.readAsString();
  }
}
