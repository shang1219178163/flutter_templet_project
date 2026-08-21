import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_dash_line.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/util/snack_util.dart';
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

  /// 页面级 Messenger。
  /// State.context 在本节点之上，`ScaffoldMessenger.of(context)` 仍会命中 MaterialApp 全局，
  /// 展示 / 清除 Banner 必须走这个 key。
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  var behavior = SnackBarBehavior.floating;

  SnackbarController? snackbarController;

  bool _isLeaving = false;

  /// MaterialBanner 收起动画时长
  static const _bannerDismissDuration = Duration(milliseconds: 250);

  late final footerItems = [
    (title: "one", action: onOne),
    (title: "two", action: onToggle),
  ];

  ScaffoldMessengerState? get pageMessenger => _scaffoldMessengerKey.currentState;

  /// 先收起页面 Banner，再 pop 路由
  Future<void> popAfterDismissBanner([Object? result]) async {
    if (_isLeaving) {
      return;
    }
    _isLeaving = true;

    final messenger = pageMessenger;
    if (messenger != null) {
      messenger.hideCurrentMaterialBanner();
      await Future<void>.delayed(_bannerDismissDuration);
      if (!mounted) {
        return;
      }
      messenger.clearMaterialBanners();
      messenger.clearSnackBars();
    }
    SnackUtil.clear();

    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final primary = themeData.colorScheme.primary;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        popAfterDismissBanner(result);
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          persistentFooterButtons:
              footerItems.map((e) => FilledButton(onPressed: e.action, child: Text(e.title))).toList(),
          bottomSheet: Container(
            height: 100,
            color: primary,
            alignment: Alignment.center,
            child: Text("bottomSheet"),
          ),
          appBar: AppBar(
            title: Text('SnackBar'),
            leading: IconButton(
              icon: const BackButtonIcon(),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => popAfterDismissBanner(),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  DLog.d("Icons.all_inclusive");
                },
                icon: Icon(Icons.all_inclusive),
              ),
              IconButton(
                onPressed: () {
                  DLog.d("Icons.change_circle");
                },
                icon: Icon(Icons.change_circle),
              ),
            ],
          ),
          body: buildBody(),
        ),
      ),
    );
  }

  void onOne() {
    snackbarController = Get.snackbar(
      "Get.snackbar",
      100.generateChars(),
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

  Widget buildBody() {
    return Builder(builder: (context) {
      return RepaintBoundary(
        key: globalKey,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              ...SnackBarBehavior.values.map((e) {
                final name = e.name.split(".").last;
                return OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(behavior: behavior));
                  },
                  child: Text(name),
                );
              }),
              NDashLine(
                color: Colors.red,
              ),
              OutlinedButton(
                child: Text('显示断网SnackBar, 覆盖'),
                onPressed: () {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(buildSnackBarOffline());
                },
              ),
              OutlinedButton(
                child: Text('显示 MaterialBanner'),
                onPressed: () {
                  showMaterialBanner();
                },
              ),
              Spacer(),
            ],
          ),
        ),
      );
    });
  }

  SnackBar buildSnackBar({
    bool isCenter = false,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    Widget child = Container(
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
      elevation: 1000,
      behavior: behavior,
    );
  }

  SnackBar buildSnackBarOffline() {
    return SnackBar(
      onVisible: () {
        debugPrint("显示SnackBar");
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.orange,
      content: Text('断网了？'),
      action: SnackBarAction(
        textColor: Colors.green,
        label: '点击重试',
        onPressed: () {
          debugPrint('点击重试');
        },
      ),
    );
  }

  /// 顶部 MaterialBanner（必须走页面级 key）
  void showMaterialBanner() {
    final messenger = pageMessenger;
    if (messenger == null) {
      return;
    }
    final nowStr = "${DateTime.now()}".split(".").first;

    final banner = MaterialBanner(
      content: InkWell(
        onTap: () {
          messenger.hideCurrentMaterialBanner();
        },
        child: Text('Hello, I am a Material Banner $nowStr' * 3),
      ),
      leading: const Icon(Icons.info),
      backgroundColor: Colors.yellow,
      actions: [
        TextButton(
          onPressed: () => messenger.hideCurrentMaterialBanner(),
          child: const Text('Dismiss'),
        ),
      ],
    );
    messenger
      ..clearMaterialBanners()
      ..showMaterialBanner(banner);
  }
}
