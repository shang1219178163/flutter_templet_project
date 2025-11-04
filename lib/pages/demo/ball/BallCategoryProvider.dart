import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_templet_project/model/footbal_category_item.dart';

class BallCategoryProvider with ChangeNotifier {
  // 私有变量存储状态
  // final List<TopItem> _tops = [];
  List<CategoryItem> _categories = [];
  bool _isLoading = false;
  String? _error;

  // 公共的 getter，供外部访问
  // List<TopItem> get tops => _tops;

  List<CategoryItem> get categories => _categories;

  bool get isLoading => _isLoading;

  String? get error => _error;

  String currentSportType = "football";

  ///最近赛事
  // List<RecentCompetitionEntity> recentCompetitionList = [];
  //
  // ///最近访问
  // List<RecentVisitedEntity> recentVisitedList = [];
  //
  // ///最近访问-篮球
  // List<RecentVisitedEntity> basketBallRecentVisitedList = [];
  //
  // ///最近赛事-篮球
  // List<RecentCompetitionEntity> basketBallRecentCompetitionList = [];

  bool isExpanded = false;
  double topOffset = -1;

  updateExpanded(bool isExpanded, [double? offset]) {
    this.isExpanded = isExpanded;
    if (offset != null) {
      topOffset = offset;
    } else {
      topOffset = -1;
    }
    notifyListeners();
  }

  initData({required String sportType}) {
    currentSportType = sportType;
    fetchData(sportType: sportType);
  }

  // 异步方法，用于获取和解析数据
  Future<void> fetchData({required String sportType}) async {
    // _isLoading = true;
    // _error = null;
    // notifyListeners();

    try {
      final res = await rootBundle.loadString('assets/data/football.json');
      // 解析 JSON 数据
      final Map<String, dynamic> jsonData = jsonDecode(res);

      final data = jsonData["data"];
      final code = jsonData["code"];

      if (code != 0) {
        _error = "网络错误，请稍后再试";
        _isLoading = false;
        notifyListeners();
        return;
      }

      _categories.clear();
      final List<dynamic> categoriesList = data['categorys'];
      _categories = categoriesList.map((json) => CategoryItem.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class LinkedScrollUtils {
  /// 平顺推进的滚动逻辑：只有当选中项越过中线时，才触发滚动使其居中
  static void scrollToCenterIfNeeded({
    required ScrollController controller,
    required int index,
    required double itemHeight,
    required int lastCenteredIndex,
    required void Function(int newIndex) onCentered,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.hasClients) {
        return;
      }

      final targetPosition = index * itemHeight;
      final viewportHeight = controller.position.viewportDimension;
      final currentOffset = controller.offset;
      final maxScrollExtent = controller.position.maxScrollExtent;

      final itemCenter = targetPosition + itemHeight / 2;
      final viewportCenter = currentOffset + viewportHeight / 2;

      final offsetFromCenter = (itemCenter - viewportCenter).abs();

      // 只有当选中项偏离中线超过一半item高度，或首次选中时，才滚动
      if (offsetFromCenter > itemHeight / 2 || lastCenteredIndex == -1) {
        onCentered(index);

        // 滚动时触发震动
        HapticFeedback.lightImpact();

        double targetScroll = targetPosition - viewportHeight / 2 + itemHeight / 2;
        targetScroll = targetScroll.clamp(0.0, maxScrollExtent);

        controller.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
}
