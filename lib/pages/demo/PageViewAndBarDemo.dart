import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class PageViewAndBarDemo extends StatefulWidget {
  PageViewAndBarDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _PageViewAndBarDemoState createState() => _PageViewAndBarDemoState();
}

class _PageViewAndBarDemoState extends State<PageViewAndBarDemo> {
  late final _pageController = PageController(); //pageController初始设置已经满足了需求
  int _currentIndex = 0;

  late final tabBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      label: '首页',
      icon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: "消息",
      icon: Icon(Icons.message),
    ),
    BottomNavigationBarItem(
      label: '我的',
      icon: Icon(Icons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: PageView(
        physics: ClampingScrollPhysics(),
        // 也可以选择BouncingScrollPhysics，如果你希望到达边界还能滚动回弹的话
        controller: _pageController,
        children: buildPages(),
        onPageChanged: (index) {
          _currentIndex = index;
          setState(() {});
        },
      ),
      bottomNavigationBar: buildTabBar(),
    );
  }

  List<Widget> buildPages() {
    return List.generate(
        tabBarItems.length,
        (i) => Container(
              color: ColorExt.random,
              alignment: Alignment.center,
              child: Text("第 $i 页"),
            )).toList();
  }

  Widget buildTabBar() {
    return BottomNavigationBar(
      items: tabBarItems,
      onTap: (index) {
        _pageController.jumpToPage(index);
        // _pageController.animateToPage(index,
        //     duration: Duration(milliseconds: 400),
        //     curve: Curves.easeInOutQuart
        // );
        _currentIndex = index;
        setState(() {});
      },
      currentIndex: _currentIndex,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    );
  }
}
