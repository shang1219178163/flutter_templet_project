# NRefreshable & NRefreshMixin

# NRefreshMixin 使用示例

## Provider
```dart
/// 资讯
class NewsProvider extends ChangeNotifier with SafeChangeNotifierMixin, NRefreshMixin<NewsDetailModel> {
  static NewsProvider? _instance;

  static NewsProvider get instance => _instance ??= NewsProvider();

  /// 资讯目录
  final newsCatalogModel = NewsCatalogModel(id: 35, names: "世界杯", mine: 1);

  Future<List<NewsDetailModel>> onRequestNews(
      bool isRefresh, int page, int pageSize, List<NewsDetailModel> pres) async {
    int? articleId;
    if (!isRefresh) {
      final minId =
          pres.where((e) => e.top != 1).toList().sorted((a, b) => (a.id ?? 0).compareTo(b.id ?? 0)).firstOrNull?.id;
      articleId = minId;
    }

    final list = await NewsHomeProvider.instance.requestCatalogArticles(
      pageNum: page,
      pageSize: pageSize,
      // catalogId: model.id,
      catalogId: newsCatalogModel.id,
      articleId: articleId,
    );
    return list;
  }

  bool get hasMoreNew => indicator != IndicatorResult.noMore;

  bool get isLoadingNew => isLoading;

  @override
  RequestListCallback<NewsDetailModel> get onRequest => onRequestNews;

  @override
  void updateUI() => notifyListeners();
}
```

## 页面
```
/// 主页面组件
class MainView extends StatefulWidget {
  const MainView({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {

  final scrollController = ScrollController();

  late var newsProvider = context.read<NewsProvider>();

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onRefresh();
    });
  }

  Future<void> onRefresh() async {
    await Future.wait([
      newsProvider.onRefresh(),
    ]);
  }

  Future<void> onLoad() async {
    await newsProvider.onLoad();
  }

  void _onScroll() {
    final bottom200 = scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200;
    final canLoad = bottom200 && !newsProvider.isLoadingNew && newsProvider.hasMoreNew;
    if (canLoad) {
      DLog.d([bottom200, newsProvider.page, canLoad]);
    }
    if (canLoad) {
      onLoad();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      builder: (context, child) {
    
        return Container(
          child: EasyRefresh.builder(
            controller: newsProvider.refreshController,
            onRefresh: onRefresh,
            // onLoad: hasLoad ? onLoad : null,
            childBuilder: (context, physics) {
              return CustomScrollView(
                physics: physics,
                cacheExtent: 500,
                controller: scrollController,
                slivers: [
                  Selector<NewsProvider, List<NewsDetailModel>>(
                    selector: (_, p) => p.items,
                    builder: (context, items, Widget? child) {
                      return SliverList.separated(
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final e = items[i];
                          return NewsListItem(
                            model: e,
                          );
                        },
                        separatorBuilder: (_, i) {
                          return Divider();
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
```