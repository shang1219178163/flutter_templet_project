import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

extension ItemPositionsListenerExt on ItemPositionsListener {
  // 获取当前可见的第一个 item 的索引
  int get currentIndex {
    final positions = itemPositions.value;
    final filters = positions.where((item) => item.itemLeadingEdge >= 0).toList();
    if (filters.isEmpty) {
      filters.add(positions.last);
    }

    final result = filters.reduce((min, item) => item.itemLeadingEdge < min.itemLeadingEdge ? item : min).index;
    return result;
  }

  /// 获取当前可见的第一个 item 的索引
  int? get firstVisibleIndex {
    final positions = itemPositions.value;
    final visibleIndex = positions.where((e) => e.itemLeadingEdge >= 0).map((e) => e.index).firstOrNull;
    return visibleIndex;
  }
}
