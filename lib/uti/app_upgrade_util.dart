

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_templet_project/model/appstore_app_detail_root_model.dart';
import 'package:flutter_templet_project/uti/Debounce.dart';

class AppUpgradeUtil {
  static String appStoreId = "6447605232";

  /// 是否强制更新
  static bool isForceUpdate = false;

  static final _debounce = Debounce(delay: Duration(milliseconds: 500));
  
  /// 查询版本信息
  static getVersionInfoByIOS() {

    _debounce(() async {
        var url = "https://itunes.apple.com/cn/lookup?id=$appStoreId";
        final response = await Dio().get(url,);
        final map = jsonDecode(response.data);
        // debugPrint("map: $map");
        final rootModel = AppstoreAppDetailRootModel.fromJson(map);
        final version = rootModel.results?[0].version;
        final releaseNotes = rootModel.results?[0].releaseNotes;

        // final currentVersion = CacheService().appVersion;
        // debugPrint("version: $version");
        // debugPrint("appVersion: ${CacheService().appVersion}");
        // // 更新版本大于当前版本 - 强制提示更新
        // // if (version != null && currentVersion != null && (version.compareTo(currentVersion) == 1)) {
        // showDialogStrongUpdate(
        //   version: version ?? "",
        //   versionContent: releaseNotes ?? "",
        // ); // 这里是强制更新类型
        // }
      });
    }

}
