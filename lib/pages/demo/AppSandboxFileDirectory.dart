//
//  AppSandboxFileDirectory.dart
//  flutter_templet_project
//
//  Created by shang on 2025/1/8 09:25.
//  Copyright © 2025/1/8 shang. All rights reserved.
//

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_templet_project/basicWidget/n_button.dart';
import 'package:flutter_templet_project/basicWidget/n_footer_button_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_menu_anchor.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/cache/cache_controller.dart';
import 'package:flutter_templet_project/cache/cache_service.dart';
import 'package:flutter_templet_project/cache/file_browser_page.dart';
import 'package:flutter_templet_project/enum/path_provider_enum.dart';
import 'package:flutter_templet_project/extension/date_time_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/num_ext.dart';
import 'package:flutter_templet_project/extension/object_ext.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:flutter_templet_project/mixin/debug_bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/model/user_model.dart';
import 'package:flutter_templet_project/pages/demo/DataTableDemo.dart';
import 'package:flutter_templet_project/util/color_util.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_order.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';
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

class _AppSandboxFileDirectoryState extends State<AppSandboxFileDirectory> with DebugBottomSheetMixin {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final _scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  var dirEnums = <PathProviderDirectory>[];

  final cacheUserMapVN = ValueNotifier(<String, dynamic>{});

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dirEnums = await PathProviderDirectory.initail();
      dirEnums = dirEnums.where((e) => e.custom?["dir"] != null).toList();
      DLog.d("dirEnums: ${dirEnums.length}");
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
      appBar: hideApp
          ? null
          : AppBar(
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
            NButton(
              constraints: BoxConstraints(maxHeight: 35),
              title: "DocumentsDirectory",
              onPressed: () async {
                final directory = await getApplicationDocumentsDirectory();
                Get.to(() => FileBrowserPage(directory: directory));
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
                final key = secondCacheKey ?? "";
                await cacheUserClear(k: key);
                cacheUserMapVN.value = await getCacheUserMap();
              },
              confirmTitle: "新增",
              onConfirm: () async {
                final model = UserModel(
                  id: 6.generateChars(chars: "0123456789"),
                  name: 3.generateChars(chars: "天行健,君子自强不息"),
                  age: 2.generateChars(chars: "0123456789").toInt(),
                );
                final isSuccess = await cacheUser(model: model);
                if (isSuccess) {
                  cacheUserMapVN.value = await getCacheUserMap();
                } else {
                  ToastUtil.show("操作失败");
                }
              },
              trailing: GestureDetector(
                onTap: onDebugSheet,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.notification_important_outlined,
                    color: primary,
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
                final keys = map.keys.toList();

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
                      // models = models.sortedByValue(cb: (e) => e.id);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: NText(
                              "分组${index} $key (数量: ${models.length})",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ...models.map((model) {
                            final desc = [model.id, model.name, model.age].join("_");

                            onDelete() async {
                              await cacheUserDelete(model: model, isLog: true);
                              final result = await getCacheUserMap();
                              cacheUserMapVN.value = {...result};
                            }

                            return Dismissible(
                              key: ValueKey(model.id),
                              direction: DismissDirection.endToStart,
                              background: Container(color: Colors.blue),
                              secondaryBackground: Container(color: Colors.red),
                              onDismissed: (direction) {
                                onDelete();
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    key: ValueKey(model.id),
                                    dense: true,
                                    title: Text(desc),
                                    trailing: InkWell(
                                      onTap: onDelete,
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

  onDelete({
    required UserModel model,
  }) async {
    await cacheUserDelete(model: model, isLog: true);
    final result = await getCacheUserMap();
    cacheUserMapVN.value = {...result};
  }

  buildChooseDir() {
    return NMenuAnchor<PathProviderDirectory>(
      dropItemPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      values: dirEnums,
      initialItem: PathProviderDirectory.applicationDocumentsDirectory,
      onChanged: (val) {
        DLog.d("NMenuAnchor: $val");
        final directory = val.custom?["dir"];
        final exception = val.custom?["exception"] as String?;
        if (exception?.isNotEmpty == true) {
          ToastUtil.show(exception ?? "");
          return;
        }
        Get.to(() => FileBrowserPage(directory: directory));
      },
      equal: (a, b) => a.name == b?.name,
      cbName: (e) => e?.name ?? "-",
    );
  }

  onDebugSheet() {
    final mapNew = cacheUserMapVN.value
        .map((k, v) => MapEntry(k, (v as List).map((e) => [e["id"], e["name"]].join("_")).toList()));
    final mapNewJsonStr = mapNew.formatedString();

    onDebugBottomSheet(
      title: _cacheFileName,
      content: Text(mapNewJsonStr),
    );
  }

  final cacheController = CacheController();

  /// 采样文件名称
  String get _cacheFileName {
    return "CACHE_User_Model";
  }

  /// 采样患者采集列表缓存key
  String? get secondCacheKey {
    final date = DateTime.now();
    final dateStr = DateTimeExt.stringFromDate(date: date, format: DateFormatEnum.yyyyMMdd.name);
    return dateStr;
  }

  /// 缓存采样
  FutureOr<bool> cacheUser({
    required UserModel model,
    bool isLog = false,
  }) async {
    if (model.id?.isNotEmpty != true) {
      DLog.d("❌$runtimeType cachePatientCollect model?.id 不能为空");
      return false;
    }

    final cacheKey = _cacheFileName;

    final k = secondCacheKey;
    if (k == null || k.isNotEmpty != true) {
      DLog.d("❌$runtimeType cachePatientCollect 患者 k 不能为空");
      return false;
    }

    final _cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
    _cacheMap[k] ??= [];
    final index = (_cacheMap[k] as List).indexWhere((e) => e["id"] == model.id);
    if (index == -1) {
      (_cacheMap[k] as List).insert(0, model.toJson());
    } else {
      (_cacheMap[k] as List)[index] = model.toJson();
    }

    try {
      final mapNew = await CacheService().updateMap(
        key: cacheKey,
        onUpdate: (map) {
          map.addAll(_cacheMap);
          return map;
        },
      );
      _cacheMap.addAll(mapNew);
      await cacheController.saveToDisk(cacheKey: cacheKey, map: _cacheMap);
      if (isLog) {
        final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
        DLog.d("$runtimeType cacheUser cacheMap ${jsonEncode(cacheMap)}");
      }

      return true;
    } catch (e) {
      DLog.d("$runtimeType $e");
    }
    return false;
  }

  /// 删除采样缓存
  FutureOr<bool> cacheUserDelete({
    required UserModel model,
    bool isLog = false,
  }) async {
    if (model.id?.isNotEmpty != true) {
      DLog.d("❌$runtimeType cacheUserDelete model?.id 不能为空");
      return false;
    }

    final cacheKey = _cacheFileName;

    final k = secondCacheKey;
    if (k == null || k.isNotEmpty != true) {
      DLog.d("❌$runtimeType cacheUserDelete 患者 k 不能为空");
      return false;
    }

    final _cacheUserMap = await cacheController.readFromDisk(cacheKey: cacheKey);
    _cacheUserMap[k] ??= [];
    // final index = (_cacheUserMap[k] as List).indexWhere((e) => e["id"] == model.id);
    final index = (_cacheUserMap[k] as List).indexWhere((e) {
      final result = e["id"] == model.id;
      // if (result) {
      //   DLog.d("$runtimeType cacheUserDelete indexWhere ${[model.id, e["id"], result].join(",")}");
      // }
      return result;
    });

    if (index == -1) {
      return false;
    } else {
      DLog.d("$runtimeType cacheUserDelete List ${(_cacheUserMap[k] as List).length}");
      (_cacheUserMap[k] as List).removeAt(index);
      DLog.d("$runtimeType cacheUserDeleteAfter List ${(_cacheUserMap[k] as List).length}");
    }

    try {
      final mapNew = await CacheService().updateMap(
          key: cacheKey,
          onUpdate: (map) {
            map.addAll(_cacheUserMap);
            return map;
          });
      _cacheUserMap.addAll(mapNew);
      await cacheController.saveToDisk(cacheKey: cacheKey, map: _cacheUserMap);
      if (isLog) {
        final cacheMap = await cacheController.readFromDisk(cacheKey: cacheKey);
        DLog.d("$runtimeType cacheUserDelete cacheMap ${cacheMap.map((k, v) => MapEntry(k, (v as List).length))}");
      }
      return true;
    } catch (e) {
      DLog.d("$runtimeType $e");
    }
    return false;
  }

  /// 删除缓存
  FutureOr<bool> cacheUserClear({
    required String k,
    bool isLog = false,
  }) async {
    final cacheKey = _cacheFileName;

    if (k.isNotEmpty != true) {
      DLog.d("❌$runtimeType cacheUserDelete 患者 k 不能为空");
      return false;
    }

    final _cacheUserMap = await cacheController.readFromDisk(cacheKey: cacheKey);
    _cacheUserMap[k] = [];

    try {
      final mapNew = await CacheService().updateMap(
          key: cacheKey,
          onUpdate: (map) {
            return {};
          });
      _cacheUserMap.addAll(mapNew);
      await cacheController.saveToDisk(cacheKey: cacheKey, map: {});
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

  /// 获取所有的样本采集
  Future<Map<String, dynamic>> getCacheUserMap() async {
    final cacheKey = _cacheFileName;

    final k = secondCacheKey;
    if (k == null || k.isNotEmpty != true) {
      DLog.d("❌$runtimeType getCachePatientCollect 患者 k 不能为空");
      return {};
    }

    final mapNew = await cacheController.readFromDisk(cacheKey: cacheKey);

    // if (_cacheUserMap.isEmpty || !_cacheUserMap.keys.contains(k)) {
    //   final mapNew = await cacheController.readFromDisk(cacheKey: cacheKey);
    //   _cacheUserMap.addAll(mapNew ?? {});
    // }
    //
    // DLog.d("$runtimeType getCacheUserMap ${_cacheUserMap.map((k, v) => MapEntry(k, (v as List).length))}");
    return mapNew;
  }

  /// 获取当前选择用户的缓存列表
  Future<List<UserModel>> getCacheUsers() async {
    final map = await getCacheUserMap();

    final k = secondCacheKey;
    if (k == null || k.isNotEmpty != true) {
      DLog.d("❌$runtimeType getCachePatientCollectsByPatient 患者 k 不能为空");
      return [];
    }

    final list = (map[k] as List?) ?? [];
    final items = list.map((json) => UserModel.fromJson(json)).toList();
    return items;
  }

  /// 获取当前选择用户的缓存列表中和日程模型匹配的缓存
  Future<UserModel?> getCachePatientCollect({
    required List<UserModel> list,
    required UserModel model,
  }) async {
    // final list = await getCachePatientCollects();
    final result = list.firstWhereOrNull((e) {
      final result = e.id == model.id;
      return result;
    });
    return result;
  }
}
