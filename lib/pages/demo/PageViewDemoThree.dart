import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templet_project/basicWidget/n_collection_view.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:tuple/tuple.dart';

class PageViewDemoThree extends StatefulWidget {
  PageViewDemoThree({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _PageViewDemoThreeState createState() => _PageViewDemoThreeState();
}

class _PageViewDemoThreeState extends State<PageViewDemoThree> with SingleTickerProviderStateMixin {
  late final scrollController = ScrollController();

  List<Tuple3<String, String, VoidCallback>> get items {
    return [
      Tuple3("照片", "img_placeholder.png".toPath(), onTap),
      Tuple3("常用语", "img_placeholder.png".toPath(), onTap),
      Tuple3("随访问卷", "img_placeholder.png".toPath(), onTap),
      Tuple3("自测筛查", "img_placeholder.png".toPath(), onTap),
      Tuple3("满意度调查", "img_placeholder.png".toPath(), onTap),
      Tuple3("健康宣教", "img_placeholder.png".toPath(), onTap),
      // Tuple3("语音通话", "img_placeholder.png".toPath(), onTap),
      // Tuple3("视频通话", "img_placeholder.png".toPath(), onTap),
      Tuple3("患者建档", "img_placeholder.png".toPath(), onTap),

      Tuple3("患者建档", "img_placeholder.png".toPath(), onTap),
      Tuple3("患者建档", "img_placeholder.png".toPath(), onTap),
      Tuple3("患者建档", "img_placeholder.png".toPath(), onTap),
      Tuple3("患者建档", "img_placeholder.png".toPath(), onTap),
      Tuple3("患者建档", "img_placeholder.png".toPath(), onTap),
      Tuple3("患者建档", "img_placeholder.png".toPath(), onTap),
    ];
  }

  final indexVN = ValueNotifier(0);

  late final pageController = PageController(initialPage: indexVN.value, keepPage: true);

  ///每页行数
  int rowNum = 2;

  ///每页列数
  int numPerRow = 4;

  ///每页数
  int get numPerPage => rowNum * numPerRow;

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("${DateTime.now()} $widget initState");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => debugPrint(e),
                  ))
              .toList(),
        ),
        body: buildBody());
  }

  buildBody() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 238,
            child: NCollectionView(
              items: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlaceholder() {
    return NPlaceholder(
      imageAndTextSpacing: 10.h,
      onTap: () async {
        debugPrint("NPlaceholder");
      },
    );
  }

  jumpToPage(int page) {
    if (!pageController.hasClients) {
      return;
    }
    pageController.jumpToPage(page);
  }

  onTap() {
    debugPrint("onTap");
  }
}
