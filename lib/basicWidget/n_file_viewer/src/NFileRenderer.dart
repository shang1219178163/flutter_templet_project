// file: core/file_renderer.dart
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

/// 通用渲染接口
abstract class NFileRenderer<T> {
  bool canRender(Object content);
  Widget build(BuildContext context, T content);
}

/// 文本渲染
class TextRenderer implements NFileRenderer<String> {
  @override
  bool canRender(Object content) => content is String;

  @override
  Widget build(BuildContext context, String content) {
    return SelectableText(
      content,
      style: const TextStyle(fontFamily: 'monospace'),
    );
  }
}

/// 图片渲染
class ImageRenderer implements NFileRenderer<Uint8List> {
  @override
  bool canRender(Object content) => content is Uint8List;

  @override
  Widget build(BuildContext context, Uint8List content) {
    return PhotoView(
      imageProvider: MemoryImage(content),
      backgroundDecoration: const BoxDecoration(color: Colors.green),
    );
  }
}

/// Markdown 渲染
class MarkdownRenderer implements NFileRenderer<String> {
  @override
  bool canRender(Object content) => content is String && content.trim().startsWith(RegExp(r'[#\-*]'));

  @override
  Widget build(BuildContext context, String content) {
    return Markdown(
      data: content,
      padding: const EdgeInsets.all(12),
    );
  }
}

/// PDF 渲染（从 bytes 生成临时文件）
class PdfRenderer implements NFileRenderer<Uint8List> {
  @override
  bool canRender(Object content) => content is Uint8List;

  @override
  Widget build(BuildContext context, Uint8List content) {
    return FutureBuilder<String>(
      future: _writeTempFile(content),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return PDFView(filePath: snapshot.data!);
      },
    );
  }

  Future<String> _writeTempFile(Uint8List data) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(data);
    return file.path;
  }
}
