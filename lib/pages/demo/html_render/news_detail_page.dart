import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_templet_project/basicWidget/scroll/EndBounceScrollPhysics.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/pages/demo/html_render/model/NewsDetailModel.dart';
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

  NewsDetailModel? detail;

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
    detail = NewsDetailModel.fromJson(data);

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
    // final provider = context.read<NewsDetailProvider>();
    // provider.pauseVideo(); // 暂停播放
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // final provider = context.read<NewsDetailProvider>();
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
        leadingWidth: 44,
        title: const Text(
          "资讯",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        actions: [
          if (kDebugMode)
            IconButton(
              onPressed: _initData,
              icon: Icon(Icons.print),
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
        "p.img": Style(
          textAlign: TextAlign.center, // 保证内部 <img> 居中
        ),
      },
      extensions: [
        // TagExtension(
        //   tagsToExtend: {"div"},
        //   builder: (exContext) {
        //     final element = exContext.element!;
        //     final children = element.children;
        //     // 如果 div 内有 img 标签
        //     for (final child in children) {
        //       if (child.localName == 'img') {
        //         final url = child.attributes['src'] ?? "";
        //         return ClipRRect(
        //           borderRadius: BorderRadius.circular(4),
        //           child: CachedNetworkImage(
        //             width: double.infinity,
        //             imageUrl: url,
        //             fit: BoxFit.fitWidth,
        //             placeholder: (_, __) => Image.asset(
        //               Assets.imagesIconNewsDetailPlaceholder,
        //               width: double.infinity,
        //               fit: BoxFit.fitWidth,
        //             ),
        //             errorWidget: (_, __, ___) => Image.asset(
        //               Assets.imagesIconNewsDetailPlaceholder,
        //               width: double.infinity,
        //               fit: BoxFit.fitWidth,
        //             ),
        //           ),
        //         );
        //       }
        //     }
        //
        //     // 如果 div 是视频封面类型
        //     final style = element.attributes['style'] ?? "";
        //     if (style.contains('background-image')) {
        //       final bgImage = style.split('url(')[1].split(')')[0].trim().replaceAll('"', '');
        //       // final inner = element.innerHtml;
        //       // final videoSource = inner.contains("source: '") ? inner.split("source: '")[1].split("'")[0] : "";
        //
        //       if (provider.playController?.videoPlayerController.value.aspectRatio == null) {
        //         return AspectRatio(
        //           aspectRatio: 16 / 9,
        //           child: Center(
        //             child: CircularProgressIndicator(
        //               color: themeProvider.titleColor,
        //             ),
        //           ),
        //         );
        //       }
        //
        //       // 可以加视频播放按钮等
        //       return LayoutBuilder(
        //         builder: (context, constraints) {
        //           final screenWidth = constraints.maxWidth;
        //           final aspectRatio = provider.playController!.videoPlayerController.value.aspectRatio;
        //           final height = screenWidth / aspectRatio;
        //
        //           if (provider.playController == null) return const SizedBox.shrink();
        //           return SizedBox(
        //             width: screenWidth,
        //             height: height,
        //             child: Chewie(controller: provider.playController!),
        //           );
        //         },
        //       );
        //     }
        //     return const SizedBox.shrink();
        //   },
        // ),
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
                    color: themeProvider.isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
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
                    color: themeProvider.isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
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
