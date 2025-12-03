import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/cache/file_manager.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/demo/tag_sort/NewsCatalogModel.dart';

class NewsHomeProvider extends ChangeNotifier {
  NewsHomeProvider._() {
    // _init();
  }
  static final NewsHomeProvider _instance = NewsHomeProvider._();
  factory NewsHomeProvider() => _instance;
  static NewsHomeProvider get instance => _instance;

  /// 本地固定写死
  final _localCatalogs = [
    NewsCatalogModel(id: 0, name: "最新", mine: 1, tagEnable: false),
    NewsCatalogModel(id: 1, name: "热门", mine: 1, tagEnable: false),
  ];

  /// 分类
  List<NewsCatalogModel> get catalogs => _catalogs;
  var _catalogs = <NewsCatalogModel>[];

  /// 我的标签
  List<NewsCatalogModel> get mineCatalogs => catalogs.where((e) => e.mine == 1).toList();

  /// 其他标签
  List<NewsCatalogModel> get otherCatalogs => catalogs.where((e) => e.mine != 1).toList();

  /// 当前选择索引
  int currentIndex = 0;

  /// 当前选择类目
  NewsCatalogModel? get currentCatalog {
    try {
      return catalogs[currentIndex];
    } catch (e) {
      DLog.d("$this $e");
    }
    return null;
  }

  bool isExpanded = false;

  updateExpanded({bool? isExpand}) {
    isExpanded = isExpand ?? !isExpanded;
    notifyListeners();
  }

  /// 本地文件存储名称
  String get ioCatalogsName => "NewsCatalogs.txt";

  /// 保存 Catalogs 到本地
  Future<File> saveCatalogs() async {
    final list = [...catalogs];
    final result = await FileManager().saveJson(fileName: ioCatalogsName, obj: list);
    DLog.d(result.path);
    return result;
  }

  /// 获取本地 Catalogs
  Future<List<NewsCatalogModel>> readCatalogs() async {
    try {
      final list = await FileManager().readJson(fileName: ioCatalogsName) as List? ?? [];
      final result = list.map((e) => NewsCatalogModel.fromJson(e)).toList();
      return result;
    } catch (e) {
      debugPrint("$this $e");
    }
    return [];
  }

  /// 更新资讯分类
  updateCatalogs(List<NewsCatalogModel> list, {bool isSave = false}) {
    _catalogs = list;
    notifyListeners();
    if (isSave) {
      NewsHomeProvider.instance.saveCatalogs().then((file) {
        DLog.d(["updateCatalogs", file.path].join("\n"));
      });
    }
  }

  /// 请求资讯分类
  Future<List<NewsCatalogModel>> requestArticleCatalogs() async {
    // if (_catalogs.isEmpty) {
    final list = await NewsHomeProvider.instance.readCatalogs();
    updateCatalogs(list);
    return _catalogs;
    // }
    // final api = ArticleCatalogQueryApi();
    // final res = await api.fetchModels(
    //   onValue: (res) => List<Map<String, dynamic>>.from(res['data']),
    //   onModel: (e) => NewsCatalogModel.fromJson(e),
    // );
    // if (!res.isSuccess) {
    //   ToastUtil.show(res.message);
    //   return [];
    // }
    // _catalogs = [..._localCatalogs, ...res.result];
    // // 如果当前tabindex没数据,请求数据
    // // await updateCatalogArticles();
    // notifyListeners();
    // return res.result;
  }
}
