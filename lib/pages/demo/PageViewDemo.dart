
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/pages/FirstPage.dart';
import 'package:flutter_templet_project/pages/SecondPage.dart';
import 'package:flutter_templet_project/pages/ThirdPage.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';

import 'package:flutter_templet_project/mixin/bottom_sheet_mixin.dart';
import 'package:flutter_templet_project/extension/widget_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';



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
    // TODO: implement initState

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
        actions: rightTitles.map((e) => TextButton(
          onPressed: (){
            _actionTap(value: e);
          },
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
        )).toList(),
      ),
      body: _buildBody(),
    );
  }

  _buildBody({
    margin = const EdgeInsets.all(15),
    padding = const EdgeInsets.all(15),
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
              child: pageIndicator(
                pageViewWidth: pageViewWidth,
                pageCount: 3
              ),
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
      onPageChanged: (index){
        debugPrint('当前为第$index页');
      },
      children: List.generate(3, (index) => Container(
        decoration: BoxDecoration(
          color: ColorExt.random,
        ),
        child: Center(child: Text('第$index页')),
      )).toList(),
    );
  }

  Widget pageIndicator({
    required int pageCount,
    required double pageViewWidth,
    double factor = 0.3
  }) {
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
    switch(value){
      case "自定义":
        {

        }
        break;
      default:
        {
          CupertinoActionSheet(
            title: Text(title),
            message: Text(message),
            actions: titles.map((e) => CupertinoActionSheetAction(
              onPressed: () {
                ddlog(e);
                Navigator.pop(context);
                Get.toNamed(APPRouter.pageViewTabBarWidget);
              },
              child: Text(e),
            ),).toList(),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
          )
              .toShowCupertinoModalPopup(context: context)
          ;
        }
        break;
    }
  }

}

/*--------------------------------------------------------------------------------------------------*/

class PageViewTabBarWidget extends StatefulWidget {
  const PageViewTabBarWidget({Key? key, this.title, }) : super(key: key);

  final String? title;

  @override
  _PageViewTabBarWidgetState createState() => _PageViewTabBarWidgetState();
}

class _PageViewTabBarWidgetState extends State<PageViewTabBarWidget> {
  final PageController _pageController = PageController();

  final List<Tuple2<BottomNavigationBarItem, Widget>> items = [
    Tuple2(
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首页',
        ),
        FirstPage()
    ),
    Tuple2(
        BottomNavigationBarItem(
          icon: Icon(Icons.mail),
          label: '邮件',
        ),
        SecondPage()
    ),
    Tuple2(
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: '我的',
        ),
        ThirdPage()
    ),
  ];

  var index = 0;
  var title = "PageViewTabBarWidget";
  var isAnimateToPage = false;
  // PageViewTabBarWidget({this.title, this.barItems, required this.pageWidgetList, this.index, this.isAnimateToPage});


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} ?? $this"),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
      body: buildPageView(context),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: items.map((e) => e.item1).toList(),
      type: BottomNavigationBarType.fixed,
      currentIndex: index,
      selectedFontSize: 14,
      selectedItemColor: Theme.of(context).primaryColor,
      selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor, size: 28),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedFontSize: 12,
      unselectedItemColor: Colors.black,
      unselectedIconTheme: IconThemeData(color: Colors.black, size: 24),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      elevation: 10,
      onTap: (index) {
        ddlog('onTap: $index');
        index = index;
        setState(() {
          if (isAnimateToPage) {
            _pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          } else {
            _pageController.jumpToPage(index);
          }
        });
      },
    );
  }

  PageView buildPageView(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      onPageChanged: (index) {
        ddlog('onPageChanged: $index');
        index = index;
        setState(() {});
      },
      pageSnapping: true,
      physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
      children: items.map((e) => e.item2).toList(),
    );
  }
}

