import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_line.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';

import 'package:tuple/tuple.dart';

const kUpdateContent = """
1、支持立体声蓝牙耳机，同时改善配对性能;
2、提供屏幕虚拟键盘;
3、更简洁更流畅，使用起来更快;
4、修复一些软件在使用时自动退出bug;
5、新增加了分类查看功能;
""";

class SnackBarDemoOne extends StatefulWidget {
  const SnackBarDemoOne({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SnackBarDemoOneState();
}

class SnackBarDemoOneState extends State<SnackBarDemoOne>
    with ScaffoldMessengerMixin {
  GlobalKey globalKey = GlobalKey();

  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  var behavior = SnackBarBehavior.floating;

  @override
  void dispose() {
    // TODO: implement dispose
    debugPrint("dispose");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isShowingMaterial) {
          showSnackBar(buildSnackBarTip());
        }
        // await Future.delayed(Duration(milliseconds: 1300), () async {
        //   clearMaterialBanners();
        // });
        debugPrint("WillPopScope");
        return !isShowingMaterial;
      },
      child: Scaffold(
        persistentFooterButtons: ["one", "two"]
            .map((e) => TextButton(
                onPressed: () {
                  debugPrint(e);
                },
                child: Text(e)))
            .toList(),
        bottomSheet: Container(
          color: Colors.green,
          height: 100,
        ),
        appBar: AppBar(
          title: Text('SnackBar'),
          actions: [
            IconButton(
              onPressed: () {
                behavior = behavior == SnackBarBehavior.floating
                    ? SnackBarBehavior.fixed
                    : SnackBarBehavior.floating;
                setState(() {});
              },
              icon: Icon(Icons.all_inclusive),
            ),
            IconButton(
              onPressed: () {
                showMyMaterialBanner();
              },
              icon: Icon(Icons.change_circle),
            ),
          ],
        ),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return Builder(builder: (BuildContext context) {
      return RepaintBoundary(
        key: globalKey,
        child: Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              _buildItem(
                  text: '显示SnackBar, 不覆盖',
                  onPressed: () {
                    // final snackBar = buildSnackBar();
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    showSnackBar(buildSnackBar(behavior: behavior));
                  }),
              NDashLine(
                color: Colors.red,
              ),
              SizedBox(
                height: 10,
              ),
              _buildItem(
                  text: '显示SnackBar, 覆盖 isCenter',
                  onPressed: () {
                    showSnackBar(
                      buildSnackBar(behavior: behavior, isCenter: true),
                    );
                  }),
              _buildItem(
                  text: '显示SnackBar, 覆盖',
                  onPressed: () {
                    showSnackBar(
                      buildSnackBar(behavior: behavior),
                    );
                  }),
              _buildItem(
                  text: '显示断网SnackBar, 覆盖',
                  onPressed: () {
                    showSnackBar(
                      buildSnackBar2(),
                    );
                  }),
              Spacer(),
            ],
          ),
        )),
      );
    });
  }

  _buildItem({required String text, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(text),
    );
  }

  SnackBar buildSnackBar(
      {bool isCenter = false,
      SnackBarBehavior behavior = SnackBarBehavior.floating}) {
    Widget child = Container(
      // color: Colors.white,
      // decoration: BoxDecoration(color: Colors.red,
      //     border: Border.all(width: 2.0, color: Colors.black),
      //     borderRadius: BorderRadius.circular(20)),
      // width: 300,
      // height: 300,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(10),
      child: Text(kUpdateContent),
    );

    if (isCenter) {
      child = Center(
        child: child,
      );
    }

    return SnackBar(
      content: child,
      padding: EdgeInsets.only(left: 13, right: 13),
      // backgroundColor: Colors.green,
      elevation: 1000,
      behavior: behavior,
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(50))
      // ),
    );
  }

  SnackBar buildSnackBar2() {
    return SnackBar(
      onVisible: () {
        debugPrint("显示SnackBar");
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.orange,
      content: Text('断网了？'),
      action: SnackBarAction(
        ///配置action的字体颜色为绿色
        textColor: Colors.green,
        label: '点击重试',
        onPressed: () {
          //执行相关逻辑
          debugPrint('点击重试');
        },
      ),
      // margin: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).size.height - 100,
      //     right: 20,
      //     left: 20),
    );
  }

  SnackBar buildSnackBarTip() {
    return SnackBar(
      onVisible: () {
        debugPrint("显示SnackBar");
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.orange,
      content: Text('您有弹窗尚未关闭, 请退出后再退出页面'),
    );
  }

  /// 顶部 MaterialBanner
  showMyMaterialBanner() {
    final nowStr = "${DateTime.now()}".split(".").first;

    final banner = MaterialBanner(
      // padding: EdgeInsets.zero,
      // leadingPadding: EdgeInsets.zero,
      content: InkWell(
          onTap: () {
            clearMaterialBanners();
            debugPrint("isShowingMaterial:$isShowingMaterial");
          },
          child: Text('Hello, I am a Material Banner $nowStr' * 3)),
      leading: const Icon(Icons.info),
      backgroundColor: Colors.yellow,
      // actions: [ SizedBox() ],
      actions: [
        TextButton(
          // onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          onPressed: () {
            clearMaterialBanners();
            debugPrint("isShowingMaterial:$isShowingMaterial");
          },
          child: const Text('Dismiss'),
        ),
      ],
    );

    showMaterialBanner(
      banner,
      isClear: false,
    );
    debugPrint("isShowingMaterial:$isShowingMaterial");
  }
}

mixin ScaffoldMessengerMixin<T extends StatefulWidget> on State<T> {
  bool _isShowing = false;

  /// ScaffoldMessengerMixin: 是否有 SnackBar 正在展示
  bool get isShowing => _isShowing;

  bool _isShowingMaterial = false;

  /// ScaffoldMessengerMixin: 是否有 MaterialBanner 正在展示
  bool get isShowingMaterial => _isShowingMaterial;

  /// ScaffoldMessengerMixin: 展示 SnackBar
  showSnackBar(SnackBar snackBar, {bool isClear = true}) {
    if (isClear) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _isShowing = true;
  }

  /// ScaffoldMessengerMixin: 清除 SnackBar
  clearSnackBars() {
    ScaffoldMessenger.of(context).clearSnackBars();
    _isShowing = false;
  }

  /// ScaffoldMessengerMixin: 展示 MaterialBanner
  showMaterialBanner(MaterialBanner snackBar, {bool isClear = true}) {
    if (isClear) {
      ScaffoldMessenger.of(context).clearMaterialBanners();
    }
    ScaffoldMessenger.of(context).showMaterialBanner(snackBar);
    _isShowingMaterial = true;
  }

  /// ScaffoldMessengerMixin: 清除 MaterialBanner
  clearMaterialBanners() {
    ScaffoldMessenger.of(context).clearMaterialBanners();
    _isShowingMaterial = false;
  }
}
