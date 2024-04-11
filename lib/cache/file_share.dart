

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/vendor/easy_toast.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_templet_project/cache/asset_cache_service.dart';


class FileShare{

  Future<void> onShare({required String url, required String fileName,}) async {
    var tempDir = await AssetCacheService().getDir();
    var tmpPath = '${tempDir.path}/${fileName}';

    final percentVN = ValueNotifier(0.0);

    EasyToast.showLoading(
        "文件下载中",
        indicator: ValueListenableBuilder<double>(
            valueListenable: percentVN,
            builder: (context,  value, child){

              return CircularProgressIndicator(
                value: value,
              );
            }
        )
    );

    final response = await Dio().download(url, tmpPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final percent = (received / total);
            final percentStr = "${(percent * 100).toStringAsFixed(0)}%";
            percentVN.value = percent;
            debugPrint("percentStr: $percentStr");
          }
        }
    );
    // debugPrint("response: ${response.data}");
    debugPrint("tmpPath: ${tmpPath}");
    EasyToast.hideLoading();

    Share.shareXFiles([XFile(tmpPath)]);
  }
}