import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/CustomeTabBar.dart';
import 'package:flutter_templet_project/uti/R.dart';

class TabBarCustomDemo extends StatefulWidget {

  TabBarCustomDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _TabBarCustomDemoState createState() => _TabBarCustomDemoState();
}

class _TabBarCustomDemoState extends State<TabBarCustomDemo> {

  // /// 初始索引
  // int initialIndex = 1;
  /// 当前索引
  int currentIndex = 0;

  List<String> titles = List.generate(9, (index) => 'item_$index').toList();

  GlobalKey<CustomeTabBarState> _globalKey = GlobalKey(debugLabel: "CustomeTabBar");

  ValueNotifier<int> indexVN = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: ['reset',].map((e) => TextButton(
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onDone,
          )).toList(),
          bottom: CustomeTabBar(
            key: _globalKey,
            initialIndex: 1,
            tabCount: titles.length,
            itemBuilder: (ctx, index, isSelect) {
              final e = titles[index];
              return buildItem(e: e, index: index, isSelect: isSelect);
            },
            onClick: (BuildContext context, int index) {
              print(index);
              indexVN.value = index;
            },
          ),
        ),
        body: Center(
          child: ValueListenableBuilder<int>(
            valueListenable: indexVN,
            builder: (BuildContext context, int value, Widget? child) {
              return Text('$value');
            },
          ),
        )
    );
  }

  Widget buildItem({required String e, required int index, required bool isSelect}) {
    if (index != 1){
      return Tab(text: e);
    }
    final url = isSelect ? R.image.imgUrls[1] : R.image.imgUrls[0];
    return Tab(
      child: FadeInImage(
        image: NetworkImage(url),
        placeholder: AssetImage("images/flutter_logo.png"),
      ),
    );
  }

  onDone() {
    print("onDone");
    _globalKey.currentState?.reset();
  }
}


