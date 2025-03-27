
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:share_plus/share_plus.dart';

class FileShare {
  /// 文件分享
  Future<void> onShare({
    required String url,
    required String fileName,
  }) async {
    final percentVN = ValueNotifier(0.0);
    ToastUtil.loading(
      "文件下载中",
      indicator: ValueListenableBuilder<double>(
        valueListenable: percentVN,
        builder: (context, value, child) {
          return CircularProgressIndicator(
            value: value,
          );
        },
      ),
    );

    final file = await FileManager().downloadFile(
      url: url,
      fileName: fileName,
      onProgress: (v) {
        percentVN.value = v;
      },
    );
    ToastUtil.hideLoading();
    if (file == null) {
      return;
    }
    Share.shareXFiles([XFile(file.path)]);
  }
}
