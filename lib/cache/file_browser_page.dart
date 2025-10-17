//
//  FileBrowserPage.dart
//  projects
//
//  Created by shang on 2025/1/6 17:48.
//  Copyright © 2025/1/6 shang. All rights reserved.
//

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/file_ext.dart';
import 'package:flutter_templet_project/extension/object_ext.dart';
import 'package:flutter_templet_project/mixin/debug_bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// 查看本地缓存文件
class FileBrowserPage extends StatefulWidget {
  const FileBrowserPage({
    super.key,
    required this.directory,
    this.contentBuilder,
  });

  /// 文件目录
  final Directory? directory;

  /// 文件内容回调
  final Future<Widget> Function(File file)? contentBuilder;

  @override
  State<FileBrowserPage> createState() => _FileBrowserPageState();
}

class _FileBrowserPageState extends State<FileBrowserPage> with DebugBottomSheetMixin {
  final _scrollController = ScrollController();

  Directory? currentDirectory;
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    _loadInitialDirectory();
  }

  Future<void> _loadInitialDirectory() async {
    var directory = widget.directory ?? await getApplicationDocumentsDirectory();
    currentDirectory = directory;
    files = currentDirectory!.listSync();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant FileBrowserPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.directory != widget.directory) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: Column(
        children: [
          Text(
            currentDirectory?.path ?? "",
            style: const TextStyle(fontSize: 14),
          ),
          Expanded(child: buildBody()),
        ],
      ),
    );
  }

  Widget buildBody() {
    final dirExsit = currentDirectory?.existsSync() == true;
    if (!dirExsit) {
      return const Center(
        child: Text(
          "目录不存在",
          style: TextStyle(fontSize: 14),
        ),
      );
    }

    return Scrollbar(
      child: ListView.separated(
        itemCount: files.length,
        itemBuilder: (context, index) {
          var entity = files[index];
          final isDir = entity is Directory;

          final statSync = entity.statSync();
          final modifiedStr = statSync.modified.toString().substring(0, 19);

          return ListTile(
            dense: true,
            leading: Icon(
              isDir ? Icons.folder : Icons.insert_drive_file,
              color: isDir ? AppColor.primary : null,
            ),
            title: Text(entity.path.split('/').last),
            subtitle: Row(
              children: [
                Expanded(child: Text(modifiedStr)),
                Text(statSync.size.fileSizeDesc),
              ],
            ),
            onTap: () {
              if (isDir) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FileBrowserPage(directory: entity),
                  ),
                );
              } else if (entity is File) {
                _openFile(entity);
              }
            },
          );
        },
        separatorBuilder: (_, index) {
          return const Divider(height: 1, color: AppColor.lineColor);
        },
      ),
    );
  }

  void _openFile(File file) {
    // 这里可以加入打开文件的逻辑，比如用第三方包打开 pdf、图片等。
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('打开文件：${file.path}')),
    // );

    final path = file.path;
    final title = path.split('/').last;
    var content = '';
    try {
      content = file.readAsStringSync();
      final obj = jsonDecode(content);
      if (obj is Object) {
        content = obj.formatedString();
      }
    } catch (e) {
      debugPrint("$this $e");
      content = "文件读取失败: $e";
    }

    Widget contentWidget = Text(content);
    if (widget.contentBuilder != null) {
      // contentWidget = widget.fileContent?.call(file) ?? SizedBox();
      contentWidget = FutureBuilder<Widget>(
        future: widget.contentBuilder?.call(file),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CupertinoActivityIndicator();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return snapshot.data!;
        },
      );
    }

    onDebugBottomSheet(
      title: title,
      confirmTitle: Platform.isIOS ? "分享" : "下载",
      onConfirm: () {
        Share.shareXFiles([XFile(path)]);
      },
      content: contentWidget,
    );
  }
}
