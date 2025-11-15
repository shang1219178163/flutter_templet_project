import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

class NotificationListenerDemo extends StatefulWidget {
  final String? title;

  const NotificationListenerDemo({Key? key, this.title}) : super(key: key);

  @override
  _NotificationListenerDemoState createState() => _NotificationListenerDemoState();
}

class _NotificationListenerDemoState extends State<NotificationListenerDemo> {
  final _scrollController = ScrollController();

  ValueNotifier<bool> isScrolling = ValueNotifier(false);

  ValueNotifier<double> progress = ValueNotifier(0.0);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: buildBody(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  buildBody() {
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("row_$index"),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  buildFloatingActionButton() {
    return ValueListenableBuilder(
      valueListenable: isScrolling,
      builder: (context, bool value, child) {
        debugPrint('Offstage value:$value');
        return Offstage(
          offstage: value,
          child: FloatingActionButton(
            tooltip: 'Increment',
            onPressed: () {
              if (progress.value >= 1.0) {
                _scrollController.jumpTo(0);
              } else {
                debugPrint('progress.value: ${progress.value.toStringAsFixed(2)}');
              }
            },
            child: ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, double value, child) {
                // print('isScrolling:${isScrolling.value} value: ${value.toString()}');
                final progressInfo = (value * 100).toInt();
                if (value >= 1.0) {
                  return Icon(Icons.arrow_upward);
                }
                return Text("$progressInfo%");
              },
            ),
          ),
        );
      },
    );
  }

  bool onNotification(ScrollNotification n) {
    // ScrollMetrics metrics = n.metrics;
    // var info = "atEdge: ${n.metrics.atEdge}, pixels: ${n.metrics.pixels}";
    // info = "isStart: ${n.metrics.isStart}, isEnd: ${n.metrics.isEnd}";
    // switch (n.runtimeType) {
    //   case ScrollStartNotification: print("开始滚动, $info"); break;
    //   case ScrollUpdateNotification: print("正在滚动, $info"); break;
    //   case ScrollEndNotification: print("滚动停止, $info"); break;
    //   case OverscrollNotification: print("滚动到边界, $info"); break;
    // }
    debugPrint("onNotification：${n.runtimeType}");

    if (n is ScrollUpdateNotification) {
      //当前滚动的位置和总长度
      final currentPixel = n.metrics.pixels;
      final totalPixel = n.metrics.maxScrollExtent;
      progress.value = currentPixel / totalPixel;
      // print("正在滚动：${currentPixel} - ${totalPixel}");
    }

    if (n is! UserScrollNotification) {
      isScrolling.value = n is! ScrollEndNotification;
      // print("onNotification：${isScrolling.value} - ${n.runtimeType}");
    }
    return false; //为 true，则事件会阻止向上冒泡，不推荐(除非有必要)
  }

  /// 监听尺寸改变
  _buildSizeChangedLayoutNotifier() {
    return NotificationListener<SizeChangedLayoutNotification>(
        onNotification: _onNotification,
        child: SizeChangedLayoutNotifier(
          // key: _filterBarChangeKey,
          child: Wrap(),
        ));
  }

  bool _onNotification(SizeChangedLayoutNotification notification) {
    // change height here
    // _filterBarChangeKey = GlobalKey();
    return false;
  }
}

class NotificationCustomDemo extends StatefulWidget {
  const NotificationCustomDemo({Key? key}) : super(key: key);

  @override
  NotificationCustomDemoState createState() {
    return NotificationCustomDemoState();
  }
}

class NotificationCustomDemoState extends State<NotificationCustomDemo> {
  final messageVN = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    //监听通知
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return NotificationListener<CustomNotification<String>>(
      onNotification: (n) {
        // DLog.d("onNotification: $n");
        messageVN.value += n.data;
        return true;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NText(
              "由于 dispatch() 需要节点的 context，而不是 build(BuildContext context) 中的根 context，所以需要使用 Builder，包裹一下节点 "
              "Widget，以获得该位置的 context。",
              style: TextStyle(fontSize: 12),
            ),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    //按钮点击时分发通知
                    CustomNotification("Hi").dispatch(context);
                  },
                  child: Text("Send Notification"),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: messageVN,
              builder: (context, value, child) {
                return Text(value);
              },
            ),
            Material()
          ].map((e) => Padding(padding: EdgeInsets.only(bottom: 8), child: e)).toList(),
        ),
      ),
    );
  }
}

/// 自定义通知
class CustomNotification<T> extends Notification {
  CustomNotification(this.data);
  final T data;
}
