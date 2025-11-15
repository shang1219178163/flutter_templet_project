import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_line.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:get/get.dart';

const kUpdateContent = """
1、支持立体声蓝牙耳机，同时改善配对性能;
2、提供屏幕虚拟键盘;
3、更简洁更流畅，使用起来更快;
4、修复一些软件在使用时自动退出bug;
5、新增加了分类查看功能;
""";

class SnackBarDemo extends StatefulWidget {
  const SnackBarDemo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SnackBarDemoState();
}

class SnackBarDemoState extends State<SnackBarDemo> {
  GlobalKey globalKey = GlobalKey();

  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  var behavior = SnackBarBehavior.floating;

  SnackbarController? snackbarController;

  late final footerItems = [
    (title: "one", action: onOne),
    (title: "two", action: onToggle),
  ];

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
        // await Future.delayed(new Duration(seconds: 1));
        // scaffoldMessenger.removeCurrentMaterialBanner();

        await Future.delayed(Duration(milliseconds: 100), () async {
          clearSnackBars();
        });
        debugPrint("WillPopScope");
        return true;
      },
      child: Scaffold(
        persistentFooterButtons: footerItems.map((e) => TextButton(onPressed: e.action, child: Text(e.title))).toList(),
        bottomSheet: Container(
          color: Colors.green,
          height: 100,
        ),
        appBar: AppBar(
          title: Text('SnackBar'),
          actions: [
            IconButton(
              onPressed: () {
                behavior = behavior == SnackBarBehavior.floating ? SnackBarBehavior.fixed : SnackBarBehavior.floating;
                setState(() {});
              },
              icon: Icon(Icons.all_inclusive),
            ),
            IconButton(
              onPressed: () {
                showMaterialBannerNew();
              },
              icon: Icon(Icons.change_circle),
            ),
          ],
        ),
        body: buildBody(),
      ),
    );
  }

  void onOne() {
    snackbarController = Get.snackbar(
      "Get.snackbar", 100.generateChars(),
      // overlayColor: Colors.white,
      // overlayBlur: 0,
      backgroundColor: Colors.white,
      duration: Duration(milliseconds: 1),
      onTap: (snack) {
        DLog.d("isSnackbarOpen: ${Get.isSnackbarOpen}");
        snackbarController?.close();
      },
    );
  }

  void onToggle() {
    DLog.d("isSnackbarOpen: ${Get.isSnackbarOpen}");
    if (Get.isSnackbarOpen) {
      snackbarController?.close();
    } else {
      snackbarController?.show();
    }
  }

  buildBody() {
    return Builder(builder: (BuildContext context) {
      return RepaintBoundary(
        key: globalKey,
        child: Container(
          alignment: Alignment.center,
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
                },
              ),
              NDashLine(
                color: Colors.red,
              ),
              _buildItem(
                text: '显示SnackBar, 覆盖 isCenter',
                onPressed: () {
                  showSnackBar(
                    buildSnackBar(behavior: behavior, isCenter: true),
                  );
                },
              ),
              _buildItem(
                text: '显示SnackBar, 覆盖',
                onPressed: () {
                  showSnackBar(
                    buildSnackBar(behavior: behavior),
                  );
                },
              ),
              _buildItem(
                text: '显示断网SnackBar, 覆盖',
                onPressed: () {
                  showSnackBar(
                    buildSnackBar2(),
                  );
                },
              ),
              Spacer(),
            ],
          ),
        ),
      );
    });
  }

  _buildItem({required String text, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(text),
    );
  }

  // SnackBar buildFlushbar(BuildContext context) {
  //   return Flushbar(
  //     flushbarPosition: FlushbarPosition.TOP,
  //     message:
  //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  //     duration: Duration(seconds: 3),
  //   )..show(context);
  // }

  SnackBar buildSnackBar({
    bool isCenter = false,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
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

  /// 顶部 MaterialBanner
  showMaterialBannerNew() {
    final nowStr = "${DateTime.now()}".split(".").first;

    final banner = MaterialBanner(
      // padding: EdgeInsets.zero,
      // leadingPadding: EdgeInsets.zero,
      content: InkWell(
        onTap: () {
          hideMaterialBanner(isClear: false);
        },
        child: Text('Hello, I am a Material Banner $nowStr' * 3),
      ),
      leading: const Icon(Icons.info),
      backgroundColor: Colors.yellow,
      // actions: [ SizedBox() ],
      actions: [
        TextButton(
          // onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          onPressed: () => hideMaterialBanner(isClear: false),
          child: const Text('Dismiss'),
        ),
        // TextButton(
        //   child: const Text('Dismiss1'),
        //   onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
        //   // onPressed: () => context.hideMaterialBanner(isClear: false),
        // ),
      ],
    );
    // ScaffoldMessenger.of(context).showMaterialBanner(banner);
    showMaterialBanner(
      banner,
      isClear: false,
    );
  }
}
