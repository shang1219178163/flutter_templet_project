import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/refresh/easy_refresh_mixin.dart';

/// 列表
class NRefreshListView<T> extends StatefulWidget {
  const NRefreshListView({
    super.key,
    this.controller,
    this.physics,
    this.title,
    this.placeholder = const NPlaceholder(),
    this.needRemovePadding = false,
    required this.onRequest,
    required this.itemBuilder,
    this.separatorBuilder,
    this.headerBuilder,
    this.footerBuilder,
  });

  /// 控制器
  final NRefreshController<T>? controller;

  final ScrollPhysics? physics;

  final String? title;

  final Widget? placeholder;

  /// 使用使用 MediaQuery.removePadding
  final bool needRemovePadding;

  /// 请求方法
  final RequestListCallback<T> onRequest;

  /// ListView 的 itemBuilder
  final ValueIndexedWidgetBuilder<T> itemBuilder;

  final IndexedWidgetBuilder? separatorBuilder;

  /// 列表表头
  final Widget Function(int count)? headerBuilder;

  /// 列表表尾
  final Widget Function(int count)? footerBuilder;

  @override
  State<NRefreshListView<T>> createState() => NRefreshListViewState<T>();
}

class NRefreshListViewState<T> extends State<NRefreshListView<T>>
    with AutomaticKeepAliveClientMixin, NEasyRefreshMixin<NRefreshListView<T>, T> {
  @override
  bool get wantKeepAlive => true;

  final scrollController = ScrollController();

  @override
  late RequestListCallback<T> onRequest = widget.onRequest;

  @override
  List<T> items = <T>[];

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // DLog.d([widget.title, widget.key, hashCode]);
      if (items.isEmpty) {
        onRefresh();
      }
    });
  }

  @override
  void didUpdateWidget(covariant NRefreshListView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title != oldWidget.title ||
        widget.placeholder != oldWidget.placeholder ||
        widget.needRemovePadding != oldWidget.needRemovePadding ||
        widget.onRequest != oldWidget.onRequest ||
        widget.itemBuilder != oldWidget.itemBuilder ||
        widget.separatorBuilder != oldWidget.separatorBuilder) {
      if (widget.controller != null && oldWidget.controller != widget.controller) {
        oldWidget.controller?.detach(this);
        widget.controller?.attach(this);
      }
      onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (items.isEmpty) {
      return GestureDetector(onTap: onRefresh, child: Center(child: widget.placeholder));
    }

    final itemCount = items.length + 2;

    Widget child = EasyRefresh(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: indicator == IndicatorResult.noMore ? null : () => onLoad(),
      child: ListView.separated(
        key: PageStorageKey(widget.title ?? hashCode),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            return widget.headerBuilder?.call(items.length) ?? const SizedBox();
          }

          if (index == itemCount - 1) {
            return widget.footerBuilder?.call(items.length) ?? const SizedBox();
          }

          final i = index - 1;
          return widget.itemBuilder(context, i, items[i]);
        },
        separatorBuilder: (context, i) {
          return widget.separatorBuilder?.call(context, i) ?? const SizedBox();
        },
      ),
    );

    if (widget.needRemovePadding) {
      child = MediaQuery.removePadding(
        context: context,
        removeTop: true,
        removeBottom: true,
        child: child,
      );
    }
    return child;
  }

}

// class NRefreshListViewController<E> {
//   NRefreshListViewState<E>? _anchor;
//
//   void _attach(NRefreshListViewState<E> anchor) {
//     _anchor = anchor;
//   }
//
//   void _detach(NRefreshListViewState<E> anchor) {
//     if (_anchor == anchor) {
//       _anchor = null;
//     }
//   }
//
//   List<E> get items {
//     assert(_anchor != null);
//     return _anchor!.items;
//   }
//
//   void onRefresh() {
//     assert(_anchor != null);
//     _anchor!.onRefresh();
//   }
//
//   /// 页码减一
//   void turnPrePage() {
//     assert(_anchor != null);
//     _anchor!.page--;
//   }
//
//   /// 页码加一
//   void turnNextPage() {
//     assert(_anchor != null);
//     _anchor!.page++;
//   }
//
//   void changeItems(List<E> list) {
//     assert(_anchor != null);
//     _anchor!.changeItems(list);
//   }
//
//   void updateUI() {
//     assert(_anchor != null);
//     _anchor!.updateUI();
//   }
// }
