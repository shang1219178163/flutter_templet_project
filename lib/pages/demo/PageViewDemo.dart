import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/basicWidget/n_swiper_view.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/mixin/assets_json_mixin.dart';

class PageViewDemo extends StatefulWidget {
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> with AssetsJsonMixin {
  ValueNotifier<double> scrollerOffset = ValueNotifier(0.0);
  PageController? controller;

  @override
  String get assetsLoadPath => "assets/data/motto.txt";

  @override
  void initState() {
    super.initState();
    controller = PageController();
    controller?.addListener(() {
      scrollerOffset.value = controller!.offset;
    });

    DLog.d(['scrollerOffset']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody({
    EdgeInsets margin = const EdgeInsets.all(15),
    EdgeInsets padding = const EdgeInsets.all(10),
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final pageViewWidth = constraints.maxWidth - margin.left - margin.right - padding.left - padding.right;
      return Container(
        margin: margin,
        padding: padding,
        child: Column(
          children: [
            buildSwiper(),
            SizedBox(height: 10),
            Expanded(child: buildPageView()),
            SizedBox(height: 10),
            Container(
              // height: 50,
              child: pageIndicator(pageViewWidth: pageViewWidth, pageCount: 3),
            )
          ],
        ),
      );
    });
  }

  Widget buildSwiper() {
    var items = assetsContent.split("\n").where((e) => e.isNotEmpty).toList();
    if (items.isEmpty) {
      return Container(
        height: 40,
        child: Placeholder(),
      );
    }
    return Container(
      height: 40,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.transparent,
        // border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: NSwiperView(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        duration: const Duration(seconds: 3),
        itemBuilder: (context, i) {
          DLog.d([i]);
          final e = "$i.${items[i]}";
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.pinkAccent,
            ),
            child: Row(
              children: [
                Icon(Icons.notifications_active_outlined, size: 20, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    e,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.1,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
              ],
            ),
          );
        },
        initIndex: 1,
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      pageSnapping: true,
      onPageChanged: (index) {
        debugPrint('当前为第$index页');
      },
      children: List.generate(3, (index) {
        return Container(
          decoration: BoxDecoration(
            color: ColorExt.random,
          ),
          child: Center(child: Text('第$index页')),
        );
      }).toList(),
    );
  }

  Widget pageIndicator({required int pageCount, required double pageViewWidth, double factor = 0.3}) {
    var width = pageViewWidth * factor;
    var itemWidth = width / pageCount;
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          child: Container(
            height: 4,
            width: width,
            color: Colors.black.withOpacity(0.05),
          ),
        ),
        ValueListenableBuilder<double>(
          valueListenable: scrollerOffset,
          builder: (context, value, child) {
            return Positioned(
              left: (value * factor / width) * itemWidth,
              child: Container(
                height: 4,
                width: itemWidth,
                decoration: BoxDecoration(
                  color: Color(0xFFBE965A),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
