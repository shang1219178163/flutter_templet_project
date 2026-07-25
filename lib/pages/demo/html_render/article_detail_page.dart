import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_templet_project/basicWidget/scroll/scroll_physics/end_bounce_scroll_physics.dart';
import 'package:flutter_templet_project/generated/assets.dart';
import 'package:flutter_templet_project/pages/demo/html_render/model/article_detail_model.dart';
import 'package:flutter_templet_project/util/theme/theme_provider.dart';
import 'package:flutter_templet_project/vendor/azlistview/common/index.dart';
import 'package:provider/provider.dart';

/// html 网络文章现实
class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage>
    with TickerProviderStateMixin, WidgetsBindingObserver, RouteAware {
  late final themeProvider = context.read<ThemeProvider>();

  ArticleDetailModel? detail;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initData().then((v) {
      setState(() {});
    });
  }

  Future<void> _initData() async {
    final str = await rootBundle.loadString("assets/data/article_json.json");
    final map = jsonDecode(str) as Map<String, dynamic>;
    final data = map["data"] as Map<String, dynamic>? ?? <String, dynamic>{};
    detail = ArticleDetailModel.fromJson(data);

    final html = detail?.context ?? "";
    final match = RegExp(r"source: '([^']+)'").firstMatch(html);
    if (match != null) {
      final videoUrl = match.group(1)!;
      // provider.preloadVideo(videoUrl);
      debugPrint("videoSourceInit=$videoUrl");
    }
  }

  @override
  void didPushNext() {
    // final provider = context.read<ArticleDetailProvider>();
    // provider.pauseVideo(); // 暂停播放
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // final provider = context.read<ArticleDetailProvider>();
    // if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
    //   provider.pauseVideo();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeProvider.color242434OrWhite,
      appBar: AppBar(
        backgroundColor: themeProvider.color242434OrWhite,
        iconTheme: IconThemeData(color: themeProvider.titleColor),
        title: Text(
          "资讯",
          style: TextStyle(fontSize: 16, color: themeProvider.titleColor),
        ),
        actions: [
          if (kDebugMode)
            IconButton(
              onPressed: _initData,
              icon: Icon(Icons.print, color: themeProvider.titleColor),
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const EndBounceScrollPhysics(),
        child: SafeArea(
          top: false,
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: buildTitleContent(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: buildHtmlContent(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: buildTagsWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail?.title ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: themeProvider.titleColor, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                detail?.createTime ?? "",
                style: TextStyle(color: themeProvider.subtitleColor, fontSize: 12),
              ),
              Text(
                "阅读 ${detail?.visitTimes ?? 0}",
                style: TextStyle(color: themeProvider.subtitleColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildHtmlContent() {
    return Html(
      data: detail?.context ?? "",
      style: {
        "body": Style(
          color: themeProvider.titleColor,
          lineHeight: LineHeight.number(1.3),
          fontSize: FontSize(16.5, Unit.px),
          display: Display.block, // 变成块级
          textAlign: TextAlign.left,
          alignment: Alignment.center,
          // border: Border.all(color: Colors.red), //add test by bin
        ),
        "p img": Style(
          // textAlign: TextAlign.center, // 保证内部 <img> 居中
          display: Display.block,
          margin: Margins(
            left: Margin.auto(),
            right: Margin.auto(),
          ),
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"img"},
          builder: (exContext) {
            final element = exContext.element;
            if (element == null) {
              return const SizedBox.shrink();
            }
            final url = element.attributes['src'] ?? '';
            final styleSize = resolveImageStyleSize(element.attributes['style']);
            final aspectRatio = resolveImageAspectRatio(element.attributes['data-href']);
            return buildHtmlImage(
              url: url,
              width: styleSize.$1,
              height: styleSize.$2,
              aspectRatio: aspectRatio,
            );
          },
        ),
        TagExtension(
          tagsToExtend: {"blockquote"},
          builder: (exContext) {
            final element = exContext.element;
            if (element == null) {
              return const SizedBox();
            }
            final text = exContext.element!.text;
            return buildTitleBar(text: text);
          },
        ),
      ],
    );
  }

  /// 从 style（如 width: 20px;height: 20px;）解析展示宽高
  (double?, double?) resolveImageStyleSize(String? style) {
    if (style == null || style.isEmpty) {
      return (null, null);
    }
    final widthMatch = RegExp(r'width\s*:\s*([\d.]+)px', caseSensitive: false).firstMatch(style);
    final heightMatch = RegExp(r'height\s*:\s*([\d.]+)px', caseSensitive: false).firstMatch(style);
    final width = widthMatch == null ? null : double.tryParse(widthMatch.group(1)!);
    final height = heightMatch == null ? null : double.tryParse(heightMatch.group(1)!);
    return (width, height);
  }

  /// 从 data-href 解析宽高比；无有效宽高、或带 share（元数据常不准）则返回 null
  double? resolveImageAspectRatio(String? dataHref) {
    if (dataHref == null || dataHref.isEmpty) {
      return null;
    }
    final parts = dataHref.split('|');
    if (parts.length < 2) {
      return null;
    }
    // 例：1500|1688|image/png||share —— share 图真实尺寸常与标注不符
    if (parts.any((e) => e.trim().toLowerCase() == 'share')) {
      return null;
    }
    final width = double.tryParse(parts[0]) ?? 0;
    final height = double.tryParse(parts[1]) ?? 0;
    if (width <= 0 || height <= 0) {
      return null;
    }
    return width / height;
  }

  Widget buildImagePlaceholder({
    double? width,
    double? height,
  }) {
    return Image.asset(
      Assets.imagesIconNewsDetailPlaceholder,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  /// 优先 style 固定宽高；否则用可信的 data-href 宽高比占位；都没有则按图片真实高度加载
  Widget buildHtmlImage({
    required String url,
    double? width,
    double? height,
    double? aspectRatio,
  }) {
    final hasFixedSize = width != null && height != null && width > 0 && height > 0;
    if (hasFixedSize) {
      final placeholder = buildImagePlaceholder(width: width, height: height);
      return ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: SizedBox(
          width: width,
          height: height,
          child: url.isEmpty
              ? placeholder
              : CachedNetworkImage(
                  imageUrl: url,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => placeholder,
                  errorWidget: (_, __, ___) => placeholder,
                ),
        ),
      );
    }
    if (aspectRatio != null) {
      return SizedBox(
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            if (!maxWidth.isFinite || maxWidth <= 0) {
              return buildNetworkFitWidthImage(url: url);
            }
            final boxHeight = maxWidth / aspectRatio;
            final placeholder = buildImagePlaceholder(width: maxWidth, height: boxHeight);
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: maxWidth,
                height: boxHeight,
                child: url.isEmpty
                    ? placeholder
                    : CachedNetworkImage(
                        imageUrl: url,
                        width: maxWidth,
                        height: boxHeight,
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                        placeholder: (_, __) => placeholder,
                        errorWidget: (_, __, ___) => placeholder,
                      ),
              ),
            );
          },
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: buildNetworkFitWidthImage(url: url),
    );
  }

  Widget buildNetworkFitWidthImage({required String url}) {
    if (url.isEmpty) {
      return buildImagePlaceholder(width: double.infinity);
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
  }

  Widget buildTagsWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...(detail?.relevantMatch ?? []).map(
            (e) {
              final teamLeft = e.sportId == 1 ? e.homeTeam : e.awayTeam;
              final teamRight = e.sportId == 1 ? e.awayTeam : e.homeTeam;

              return InkWell(
                onTap: () => e.jumpRelevantMatchDetail(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: themeProvider.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: CachedNetworkImage(
                              imageUrl: teamLeft?.logo ?? "",
                              width: 15,
                              height: 15,
                              errorWidget: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                          Text(
                            teamLeft?.names ?? "",
                            style: TextStyle(
                              fontSize: 13,
                              color: themeProvider.titleColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: Text("vs"),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            teamRight?.names ?? "",
                            style: TextStyle(
                              fontSize: 13,
                              color: themeProvider.titleColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: CachedNetworkImage(
                              imageUrl: teamRight?.logo ?? "",
                              width: 15,
                              height: 15,
                              errorWidget: (_, __, ___) => const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          ...(detail?.sportItems ?? []).map(
            (e) {
              return InkWell(
                onTap: () => e.jumpSportItemDetail(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: themeProvider.isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.05),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: CachedNetworkImage(
                          imageUrl: e.logo ?? "",
                          width: 15,
                          height: 15,
                          errorWidget: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                      Text(
                        e.names ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          color: themeProvider.titleColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTitleBar({
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 22,
          width: 3,
          margin: EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(3),
              bottomRight: Radius.circular(3),
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
