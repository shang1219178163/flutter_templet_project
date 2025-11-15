//
//  AppSandboxFileDirectory.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/8 09:25.
//  Copyright © 2025/1/8 shang. All rights reserved.
//

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/basicWidget/n_button.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/basicWidget/upload/video_service.dart';
import 'package:flutter_templet_project/cache/asset_cache_service.dart';
import 'package:flutter_templet_project/cache/cache_controller.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/cache/file_browser_page.dart';
import 'package:flutter_templet_project/enum/path_provider_enum.dart';

import 'package:flutter_templet_project/mixin/asset_picker_mixin.dart';
import 'package:flutter_templet_project/mixin/debug_bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// 沙盒文件目录
class AppSandboxFileDirectory extends StatefulWidget {
  const AppSandboxFileDirectory({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AppSandboxFileDirectory> createState() => _AppSandboxFileDirectoryState();
}

class _AppSandboxFileDirectoryState extends State<AppSandboxFileDirectory>
    with DebugBottomSheetMixin, AssetPickerMixin {
  var directorys = <PathProviderDirectory>[];

  final cacheUserMapVN = ValueNotifier(<String, dynamic>{});

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      directorys = await PathProviderDirectory.initail();
      directorys = directorys.where((e) => e.custom?["dir"] != null).toList();
      DLog.d("directorys: ${directorys.length}");
      setState(() {});
      cacheUserMapVN.value = await getCacheUserMap();
    });
  }

  @override
  void didUpdateWidget(covariant AppSandboxFileDirectory oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: onDebugSheet,
          child: Text("$widget"),
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...[
            Row(
              children: [
                NButton(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  title: "写入图像",
                  onPressed: () async {
                    await onAssetPicker(
                      needCompress: true,
                      onItemCompressed: (e) async {
                        await AssetCacheService().saveFile(file: e.file!);
                      },
                    );
                  },
                ),
                NButton(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  title: "图像缓存",
                  onPressed: () async {
                    final directory = await AssetCacheService().getDir();
                    Get.to(() => FileBrowserPage(directory: directory, contentBuilder: fileContent));
                  },
                ),
                NButton(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  title: "网络图像缓存",
                  onPressed: () async {
                    final file = await AssetCacheService().saveNetworkImage(url: AppRes.image.urls.randomOne!);
                    final bytes = await file.readAsBytes();

                    // 使用 image 库加载图片
                    var image = img.decodeImage(Uint8List.fromList(bytes));
                    if (image == null) {
                      return;
                    }
                    DLog.d("image: $image");
                  },
                ),
              ]
                  .map(
                    (e) => Padding(padding: EdgeInsets.only(right: 8), child: e),
                  )
                  .toList(),
            ),
            NButton(
              constraints: BoxConstraints(maxHeight: 35),
              title: "DocumentsDirectory",
              onPressed: () async {
                final directory = await getApplicationDocumentsDirectory();
                Get.to(() => FileBrowserPage(directory: directory, contentBuilder: fileContent));
              },
            ),
            buildChooseDir(),
            NFooterButtonBar(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              cancelTitle: "清除当天分组",
              onCancel: () async {
                if (cacheUserMapVN.value.isEmpty) {
                  return;
                }
                await cacheUserClear(section: getSection(0), isLog: true);
                cacheUserMapVN.value = await getCacheUserMap();
              },
              confirmTitle: "新增",
              onConfirm: () async {
                await onAdd(section: getSection(-1));
                await onAdd(section: getSection(0));
              },
              trailing: GestureDetector(
                onTap: onDebugSheet,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.notification_important_outlined,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ),
          ].map(
            (e) => Padding(padding: EdgeInsets.only(bottom: 8), child: e),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: cacheUserMapVN,
              builder: (context, map, child) {
                final keys = map.keys.toList().sorted((a, b) => b.compareTo(a));

                return Scrollbar(
                  child: ListView.separated(
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: NText(
                            "${map.keys.length}个分组",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }

                      final index = i - 1;
                      final key = keys[index];

                      final list = <Map<String, dynamic>>[];
                      if (map[key] != null) {
                        final value = List<Map<String, dynamic>>.from(map[key]);
                        list.addAll(value);
                      }

                      var models = list.map((e) => UserModel.fromJson(e)).toList();
                      models = models.sorted((a, b) => (a.id ?? "0").compareTo((b.id ?? "0")));
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                NText(
                                  "分组${index + 1} $key (数量: ${models.length})",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    DLog.d("key: $key");
                                    onAdd(section: key);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(
                                      Icons.add_circle_outline,
                                      color: context.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ...models.map((model) {
                            final desc = [model.id, model.name, model.age].join("_");

                            onItemDelete() async {
                              onDelete(section: key, model: model);
                            }

                            return Dismissible(
                              key: ObjectKey(model),
                              direction: DismissDirection.endToStart,
                              background: Container(color: Colors.blue),
                              secondaryBackground: Container(color: Colors.red),
                              onDismissed: (direction) {
                                onItemDelete();
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    title: Text(desc),
                                    trailing: InkWell(
                                      onTap: onItemDelete,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.red),
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                        ),
                                        child: Text(
                                          "删除",
                                          style: TextStyle(color: Colors.red, fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(height: 1, indent: 16),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    },
                    separatorBuilder: (_, i) {
                      return Divider(height: 1);
                    },
                    itemCount: keys.length + 1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 目录下拉菜单
  Widget buildChooseDir() {
    return NMenuAnchor<PathProviderDirectory>(
      dropItemPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      values: directorys,
      initialItem: PathProviderDirectory.applicationDocumentsDirectory,
      onChanged: (val) {
        DLog.d("NMenuAnchor: $val");
        final directory = val.custom?["dir"];
        final exception = val.custom?["exception"] as String?;
        if (exception?.isNotEmpty == true) {
          ToastUtil.show(exception ?? "");
          return;
        }
        Get.to(() => FileBrowserPage(directory: directory, contentBuilder: fileContent));
      },
      equal: (a, b) => a.name == b?.name,
      cbName: (e) => e?.name ?? "-",
    );
  }

  /// 显示沙盒文件缓存内容
  onDebugSheet() {
    final mapNew = cacheUserMapVN.value
        .map((k, v) => MapEntry(k, (v as List<Map>).map((e) => [e["id"], e["name"]].join("_")).toList()));
    final mapNewJsonStr = mapNew.formatedString();

    onDebugBottomSheet(
      title: _cacheFileName,
      content: Text(mapNewJsonStr),
    );
  }

  final cacheController = CacheController();

  /// 文件名称
  String get _cacheFileName {
    return "CACHE_User_Model";
  }

  /// 新增
  ///
  /// section - 分组
  onAdd({required String section}) async {
    final model = UserModel(
      id: 6.generateChars(chars: "0123456789"),
      name: 3.generateChars(chars: "天行健,君子自强不息"),
      age: 2.generateChars(chars: "0123456789").toInt(),
    );
    final isSuccess = await cacheUser(model: model, section: section);
    if (isSuccess) {
      cacheUserMapVN.value = await getCacheUserMap();
    } else {
      ToastUtil.show("操作失败");
    }
  }

  /// 删除
  onDelete({
    required UserModel model,
    required String section,
    bool isLog = false,
  }) async {
    await cacheUserDelete(section: section, model: model, isLog: isLog);
    final result = await getCacheUserMap();
    cacheUserMapVN.value = {...result};
  }

  ///获取分组key
  String getSection(int day) {
    final date = DateTime.now().add(Duration(days: day));
    final dateStr = DateTimeExt.stringFromDate(date: date, format: DateFormatEnum.yyyyMMdd.name);
    return dateStr ?? "other";
  }

  /// 缓存
  FutureOr<bool> cacheUser({
    required UserModel model,
    required String section,
    bool isLog = false,
  }) async {
    if (model.id?.isNotEmpty != true) {
      DLog.d("❌$runtimeType cachePatientCollect model?.id 不能为空");
      return false;
    }

    final cacheKey = _cacheFileName;
    final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
    cacheMap[section] ??= [];
    final index = (cacheMap[section] as List<Map>).indexWhere((e) => e["id"] == model.id);
    if (index == -1) {
      (cacheMap[section] as List).insert(0, model.toJson());
    } else {
      (cacheMap[section] as List)[index] = model.toJson();
    }

    try {
      final mapNew = await CacheService().updateMap(
        key: cacheKey,
        onUpdate: (map) {
          map.addAll(cacheMap);
          return map;
        },
      );
      cacheMap.addAll(mapNew);
      await cacheController.saveToDisk(cacheKey: cacheKey, map: cacheMap);
      if (isLog) {
        final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
        DLog.d("$runtimeType cacheUser cacheMap ${jsonEncode(cacheMap)}");
      }
      return true;
    } catch (e) {
      DLog.d("❌$runtimeType cacheUser $e");
    }
    return false;
  }

  /// 删除缓存
  FutureOr<bool> cacheUserDelete({
    required UserModel model,
    required String section,
    bool isLog = false,
  }) async {
    if (model.id?.isNotEmpty != true) {
      DLog.d("❌$runtimeType cacheUserDelete model?.id 不能为空");
      return false;
    }

    final cacheKey = _cacheFileName;
    final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
    cacheMap[section] ??= [];
    final index = (cacheMap[section] as List<Map>).indexWhere((e) => e["id"] == model.id);
    if (index == -1) {
      return false;
    } else {
      if (isLog) {
        DLog.d("$runtimeType cacheUserDelete List ${(cacheMap[section] as List).length}");
      }
      (cacheMap[section] as List).removeAt(index);
      if (isLog) {
        DLog.d("$runtimeType cacheUserDeleteAfter List ${(cacheMap[section] as List).length}");
      }
    }

    try {
      final mapNew = await CacheService().updateMap(
          key: cacheKey,
          onUpdate: (map) {
            map.addAll(cacheMap);
            return map;
          });
      cacheMap.addAll(mapNew);
      await cacheController.saveToDisk(cacheKey: cacheKey, map: cacheMap);
      if (isLog) {
        final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
        DLog.d("$runtimeType cacheUserDelete cacheMap ${cacheMap.map((k, v) => MapEntry(k, (v as List).length))}");
      }
      return true;
    } catch (e) {
      DLog.d("❌$runtimeType cacheUserDelete $e");
    }
    return false;
  }

  /// 删除缓存
  FutureOr<bool> cacheUserClear({
    required String section,
    bool isLog = false,
  }) async {
    final cacheKey = _cacheFileName;
    final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
    cacheMap[section] = [];

    try {
      final mapNew = await CacheService().updateMap(
          key: cacheKey,
          onUpdate: (map) {
            return {};
          });
      cacheMap.addAll(mapNew);
      await cacheController.saveToDisk(cacheKey: cacheKey, map: cacheMap);
      if (isLog) {
        final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
        DLog.d("$runtimeType cacheUserDelete cacheMap ${cacheMap.map((k, v) => MapEntry(k, (v as List).length))}");
      }
      return true;
    } catch (e) {
      DLog.d("$runtimeType cacheUserClear $e");
    }
    return false;
  }

  /// 获取缓存文件内容
  Future<Map<String, dynamic>> getCacheUserMap() async {
    final cacheKey = _cacheFileName;
    final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
    // DLog.d("$runtimeType getCacheUserMap ${mapNew.map((k, v) => MapEntry(k, (v as List).length))}");
    return cacheMap;
  }

  /// 获取当前选择用户的缓存列表
  Future<List<UserModel>> getCacheUsers({
    required String section,
  }) async {
    final map = await getCacheUserMap();
    final list = (map[section] as List?) ?? [];
    final items = list.map((json) => UserModel.fromJson(json)).toList();
    return items;
  }

  ///
  /// 文件内容读取
  Future<Widget> fileContent(File file) async {
    if (!file.existsSync()) {
      return Text("文件不存在: ${file.path}");
    }

    final filePath = file.path;
    final fileName = file.absolute.path.split('/').last;
    final fileType = file.path.fileType;

    Widget result = Text("未知类型");
    switch (fileType) {
      case NFileType.image:
        {
          result = Image.file(file);
        }
      case NFileType.video:
        {
          var content = '';
          try {
            final mediaInfo = await VideoService.getMediaInfo(filePath);
            final obj = mediaInfo.toJson();
            content = obj.formatedString();
          } catch (e) {
            debugPrint("$this $e");
            content = "文件读取失败: $e";
          }
          result = Text(content);
        }
        break;
      default:
        {
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
          result = Text(content);
        }
        break;
    }

    return result;
  }
}
