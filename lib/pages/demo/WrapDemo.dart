import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/image/n_network_image.dart';
import 'package:flutter_templet_project/basicWidget/n_section_box.dart';
import 'package:flutter_templet_project/basicWidget/n_wrap_page_view.dart';
import 'package:flutter_templet_project/util/AppRes.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class WrapDemo extends StatefulWidget {

  const WrapDemo({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _WrapDemoState createState() => _WrapDemoState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _WrapDemoState extends State<WrapDemo> {
  /// 20 种颜色作为分页数据源（4 列 × 2 行 = 每页 8 项 → 共 3 页）
  final List<Color> items = [
    ...Colors.primaries,
    Colors.amberAccent,
  ];

  /// 仅取阿里云图，便于服务端缩略
  late final List<String> imageUrls = AppRes.image.urls.where((e) => e.contains('.aliyuncs.com')).take(16).toList();

  @override
  void initState() {
    super.initState();
    final cache = PaintingBinding.instance.imageCache;
    cache.maximumSize = 40;
    cache.maximumSizeBytes = 20 << 20; // 20MB
    testCache('WrapDemo.initState');
  }

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clear();
    testCache('WrapDemo.dispose');
    super.dispose();
  }

  void testCache(String tag) {
    final imageCache = PaintingBinding.instance.imageCache;
    DLog.d(
      '[$tag] imageCache size=${imageCache.currentSize} '
      'bytes=${(imageCache.currentSizeBytes / 1024 / 1024).toStringAsFixed(2)}MB '
      'maxBytes=${(imageCache.maximumSizeBytes / 1024 / 1024).toStringAsFixed(0)}MB',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          IconButton(
            tooltip: '打印 ImageCache',
            onPressed: () => testCache('manual'),
            icon: const Icon(Icons.memory),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NSectionBox(
              title: "NWrapPageView · 20 色 · 每页 8 项（4×2）",
              mainAxisSize: MainAxisSize.min,
              child: buildWrapPageView(),
            ),
            NSectionBox(
              title: "网图分页（OSS 缩略 · 每页 8 张）",
              mainAxisSize: MainAxisSize.min,
              child: Container(
                margin: const EdgeInsets.all(12),
                child: buildWrapBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWrapPageView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: NWrapPageView<Color>(
        height: 168,
        items: items,
        crossAxisCount: 4,
        rowCount: 2,
        spacing: 12,
        runSpacing: 12,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            decoration: BoxDecoration(
              color: item,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildWrapBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.blue),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: NWrapPageView<String>(
        height: 200,
        items: imageUrls,
        crossAxisCount: 4,
        rowCount: 2,
        spacing: 8,
        runSpacing: 8,
        onPageChanged: (_) => testCache('pageChanged'),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: NNetworkImage(
                  url: imageUrls[index],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  radius: 4,
                ),
              ),
              Text("选项_$index", style: const TextStyle(fontSize: 12)),
            ],
          );
        },
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Color>('items', items));
    properties.add(IterableProperty<String>('imageUrls', imageUrls));
  }
}
