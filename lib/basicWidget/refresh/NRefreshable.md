# NRefreshable

`lib/basicWidget/refresh` 基于 `easy_refresh`。列表走分页 mixin，详情走单模型 mixin。`NRefreshMixin` 已删除，列表改用 `NListRefreshMixin`。

## 文件

| 文件 | 职责 |
|------|------|
| `n_easy_refresh_mixin.dart` | `NRefreshable`、列表/详情 mixin、Controller |
| `n_refresh_list_view.dart` | `NRefreshListView`，带刷新的 `ListView` |
| `n_custom_scrollView.dart` | `NCustomScrollView`，带刷新的 `CustomScrollView` 列表 |
| `n_refresh_view.dart` | `NRefreshView`，单模型详情 |
| `n_custom_scrollView_for_model.dart` | `NCustomScrollViewForModel`，详情 + sliver 头尾 |
| `n_traceless_load_mixin.dart` | 接近底部自动加载，无 footer |

## 类型

```
NRefreshable
├── NListRefreshable<T>     分页列表
│     NListRefreshMixin     EasyRefresh 分页实现
│     NListRefreshStateMixin  StatefulWidget：setState + 空列表首刷
│     NListRefreshController  外部 onRefresh / updateItems
└── NModelRefreshable<T>    单模型
      NModelRefreshMixin
      NModelRefreshStateMixin
      NModelRefreshController
```

```dart
typedef ValueIndexedWidgetBuilder<T> = Widget Function(BuildContext context, int index, T data);

typedef RequestListCallback<T> = Future<List<T>> Function(
  bool isRefresh,
  int page,
  int pageSize,
  List<T> pres,
);

typedef RequestModelCallback<T> = Future<T?> Function();
```

列表请求约定：`isRefresh == true` 为下拉刷新；`pres` 为上一页尾部片段（`onLoad` 里 `items` 末尾最多 `pageSize` 条）。返回长度 `< pageSize` 视为没有更多（`IndicatorResult.noMore`）。

## 列表字段

| 字段 | 默认 | 说明 |
|------|------|------|
| `page` | 1 | 当前页 |
| `pageInitial` | 1 | 下拉刷新重置到的页码 |
| `pageSize` | 20 | 每页条数 |
| `firstPageItems` | `[]` | 非空时首刷直接用它，不再请求 |
| `items` | `[]` | 数据源 |
| `indicator` | `success` | EasyRefresh 结果 |
| `isLoading` / `isFirstLoad` | | 请求中 / 是否首次 |
| `hasMore` | | `indicator != IndicatorResult.noMore` |

`onRequest` 用 **赋值**，不要再 `override get onRequest`。未赋值时 `late` 未初始化会抛错。`updateUI` 在列表/详情 mixin 里未实现，Provider 要 `notifyListeners`，State 页用对应 `*StateMixin`（内部 `setState`）。

分页组件用 `configurePaging` 同步 `page` / `pageSize` / `pageInitial` / `firstPageItems`；这些参数变化时 `pagingChanged` 为 true 会重新 `onRefresh()`。

详情首次请求由 `NModelRefreshStateMixin` 在首帧后触发，`onRefresh` 的 `finally` 会把 `isFirstLoad` 置 false（骨架屏据此切换）。

## 组件

### NRefreshListView

对标 `NCustomScrollView` 的 ListView 版。空列表显示 `placeholder`，点击重试。`itemCount = items.length + 2`（头、尾占位）。

```dart
NRefreshListView<UserModel>(
  controller: refreshViewController,
  page: 1,
  pageSize: 20,
  onRequest: (isRefresh, page, pageSize, last) async {
    return requestList(isRefresh: isRefresh, pageNo: page, pageSize: pageSize);
  },
  itemBuilder: (context, index, e) => ListTile(title: Text(e.name ?? '')),
  separatorBuilder: (context, i) => const Divider(),
  headerBuilder: (count) => Text('共 $count 条'),
)
```

常用参数：`controller`、`scrollController`、`physics`、`notRefresh` / `notLoad`、`placeholder`、`needRemovePadding`、`title`（`PageStorageKey`）、`headerBuilder` / `footerBuilder`。

外部刷新：`refreshViewController.onRefresh()`；读数据：`refreshViewController.items`。

### NCustomScrollView

`EasyRefresh.builder` + `CustomScrollView`，可嵌 `NestedScrollView`。`headerBuilder` / `footerBuilder` 返回 `List<Widget>`（sliver）。`onlyHeader: true` 时列表为空仍显示 header。`builder` 可替换默认 `SliverList.separated`。

### NRefreshView / NCustomScrollViewForModel

`onRequest` 为 `Future<T?> Function()`。首次可显示 `skeletonScreen`；`item == null` 显示 `placeholder`。详情默认 `notLoad: true`（`onLoad` 未实现）。

```dart
NRefreshView<UserModel>(
  onRequest: () async => fetchUser(),
  placeholder: const NPlaceholder(),
  child: builder(context, controller.item!),
)
```

## Provider + 自定义滚动（原 NRefreshMixin 场景）

```dart
class NewsProvider extends ChangeNotifier with NListRefreshMixin<NewsDetailModel> {
  NewsProvider() {
    onRequest = onRequestNews;
  }

  Future<List<NewsDetailModel>> onRequestNews(
    bool isRefresh,
    int page,
    int pageSize,
    List<NewsDetailModel> pres,
  ) async {
    int? articleId;
    if (!isRefresh) {
      final minId = pres.where((e) => e.top != 1).sorted((a, b) => (a.id ?? 0).compareTo(b.id ?? 0)).firstOrNull?.id;
      articleId = minId;
    }
    return NewsHomeProvider.instance.requestCatalogArticles(
      pageNum: page,
      pageSize: pageSize,
      catalogId: newsCatalogModel.id,
      articleId: articleId,
    );
  }

  @override
  void updateUI() => notifyListeners();
}
```

页面把 `EasyRefresh` 接到 `newsProvider.refreshController`，`onRefresh` / `onLoad` 调 Provider。无痕加载可自己听滚动，或用下面 mixin；`hasMore` 代替原来的 `indicator != IndicatorResult.noMore`。

```dart
EasyRefresh.builder(
  controller: newsProvider.refreshController,
  onRefresh: () => newsProvider.onRefresh(),
  onLoad: newsProvider.hasMore ? () => newsProvider.onLoad() : null,
  childBuilder: (context, physics) {
    return CustomScrollView(
      physics: physics,
      controller: scrollController,
      slivers: [
        Selector<NewsProvider, List<NewsDetailModel>>(
          selector: (_, p) => p.items,
          builder: (context, items, child) {
            return SliverList.separated(
              itemCount: items.length,
              itemBuilder: (_, i) => NewsListItem(model: items[i]),
              separatorBuilder: (_, i) => const Divider(),
            );
          },
        ),
      ],
    );
  },
)
```

## 无痕加载

距底部 `triggerDistance`（默认 200）自动 `onLoad`，不挂 EasyRefresh footer。

- `NTracelessLoadMixin`：自己实现 `hasNextPage`、`onLoad`。
- `NTracelessEasyRefreshLoadMixin`：挂在 `NListRefreshStateMixin` 上，复用分页 `onLoad` / `isLoading` / `hasMore`。

`scrollController` 必须由外部 **setter 注入**，dispose 也由外部负责；mixin 只移除监听。

```dart
class _PageState extends State<Page>
    with
        NListRefreshMixin<String>,
        NListRefreshStateMixin<Page, String>,
        NTracelessEasyRefreshLoadMixin<Page, String> {
  late final _scrollController = ScrollController();

  @override
  void initState() {
    onRequest = _onRequest;
    scrollController = _scrollController;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: refreshController,
      onRefresh: onRefresh,
      onLoad: null, // 由 mixin 近底触发
      child: ListView.builder(
        controller: scrollController,
        itemCount: items.length,
        itemBuilder: (context, i) => ListTile(title: Text(items[i])),
      ),
    );
  }
}
```

完整示例见 `lib/pages/demo/TracelessLoadDemo.dart`、`NRefreshViewDemo.dart`。
