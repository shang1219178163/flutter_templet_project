import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageViewDemo extends StatefulWidget {
  const PageViewDemo({Key? key}) : super(key: key);

  @override
  _PageViewDemoState createState() => _PageViewDemoState();
}

class _PageViewDemoState extends State<PageViewDemo> {
  ValueNotifier<double> scrollerOffset = ValueNotifier(0.0);
  PageController? controller;

  var titles = ["PageViewTabBarWidget", "2", "3"];

  final title = "新版本 v${2.1}";
  final message = """
1、支持立体声蓝牙耳机，同时改善配对性能;
2、提供屏幕虚拟键盘;
3、更简洁更流畅，使用起来更快;
4、修复一些软件在使用时自动退出bug;
""";

  final rightTitles = ["默认", "done"];

  @override
  void initState() {
    controller = PageController();
    controller?.addListener(() {
      scrollerOffset.value = controller!.offset;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
        actions: rightTitles
            .map((e) => TextButton(
                  onPressed: () {
                    _actionTap(value: e);
                  },
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody({
    EdgeInsets margin = const EdgeInsets.all(15),
    EdgeInsets padding = const EdgeInsets.all(15),
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      final pageViewWidth = constraints.maxWidth - margin.left - margin.right - padding.left - padding.right;
      return Container(
        margin: margin,
        padding: padding,
        child: Column(
          children: [
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

  Widget buildPageView() {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      pageSnapping: true,
      onPageChanged: (index) {
        debugPrint('当前为第$index页');
      },
      children: List.generate(
          3,
          (index) => Container(
                decoration: BoxDecoration(
                  color: ColorExt.random,
                ),
                child: Center(child: Text('第$index页')),
              )).toList(),
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
                  ));
            }),
      ],
    );
  }

  void _actionTap({required String value}) {
    switch (value) {
      case "自定义":
        {}
        break;
      default:
        {
          CupertinoActionSheet(
            title: Text(title),
            message: Text(message),
            actions: titles
                .map(
                  (e) => CupertinoActionSheetAction(
                    onPressed: () {
                      DLog.d(e);
                      Navigator.pop(context);
                    },
                    child: Text(e),
                  ),
                )
                .toList(),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
          ).toShowCupertinoModalPopup(context: context);
        }
        break;
    }
  }
}
