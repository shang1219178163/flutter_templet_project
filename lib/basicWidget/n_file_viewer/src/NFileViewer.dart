// file: widgets/file_viewer.dart
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_file_viewer/n_file_viewer.dart';

class NFileViewer extends StatefulWidget {
  final String path;
  const NFileViewer({super.key, required this.path});

  @override
  State<NFileViewer> createState() => _NFileViewerState();
}

class _NFileViewerState extends State<NFileViewer> {
  late Future<Widget> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadAndRender(widget.path);
  }

  Future<Widget> _loadAndRender(String path) async {
    final registry = NFileRegistry();
    final reader = registry.findReader(path);
    if (reader == null) {
      return Text('找不到可用的 Reader: $path');
    }

    final content = await reader.readContent(path: path);
    final renderer = registry.findRenderer(content);
    if (renderer == null) {
      return Text('找不到可用的 Renderer: $path');
    }

    return renderer.build(context, content);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          final items = [widget.path, '加载失败：${snapshot.error}'];
          return Text(items.join("\n"));
        }
        return snapshot.data!;
      },
    );
  }
}
