// file: core/file_registry.dart

import 'package:flutter_templet_project/basicWidget/n_file_viewer/src/NFileReader.dart';
import 'package:flutter_templet_project/basicWidget/n_file_viewer/src/NFileRenderer.dart';

class NFileRegistry {
  static final NFileRegistry _instance = NFileRegistry._();
  NFileRegistry._();
  factory NFileRegistry() => _instance;
  static NFileRegistry get instance => _instance;

  final List<NFileReader> _readers = [];
  final List<NFileRenderer> _renderers = [];

  void registerReader(NFileReader reader) => _readers.add(reader);
  void registerRenderer(NFileRenderer renderer) => _renderers.add(renderer);

  NFileReader? findReader(String path) {
    final ext = path.split('.').last.toLowerCase();
    for (final r in _readers) {
      if (r.canRead(ext)) {
        return r;
      }
    }
    return null;
  }

  NFileRenderer? findRenderer(Object content) {
    for (final r in _renderers) {
      if (r.canRender(content)) {
        return r;
      }
    }
    return null;
  }

  /// 初始化默认 Reader & Renderer
  static void registerDefaults() {
    final reg = NFileRegistry.instance;
    reg.registerReader(TextFileReader());
    reg.registerReader(BinaryFileReader());

    reg.registerRenderer(TextRenderer());
    reg.registerRenderer(ImageRenderer());
    reg.registerRenderer(MarkdownRenderer());
    reg.registerRenderer(PdfRenderer());
  }
}
