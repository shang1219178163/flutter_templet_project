import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/scroll_controller_ext.dart';
import 'package:flutter_templet_project/extension/scroll_metrics_ext.dart';

class NotificationListenerDemo extends StatefulWidget {

  final String? title;

  const NotificationListenerDemo({ Key? key, this.title}) : super(key: key);

  
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
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  _buildBody() {
    return NotificationListener<ScrollNotification>(
      onNotification: onNotification,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: 100,
        itemBuilder: (context, index) {
          return ListTile(title: Text("row_$index"),);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  _buildFloatingActionButton() {
    return ValueListenableBuilder(
      valueListenable: isScrolling,
      builder: (context, bool value, child) {
        print('Offstage value:$value');
        return Offstage(
          offstage: value,
          child: FloatingActionButton(
            tooltip: 'Increment',
            onPressed: () {
              if (progress.value >= 1.0) {
                _scrollController.jumpTo(0);
              } else {
                print('progress.value: ${progress.value.toStringAsFixed(2)}');
              }
            },
            child: ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, double value, child) {
                // print('isScrolling:${isScrolling.value} value: ${value.toString()}');
                final progressInfo = (value*100).toInt();
                if (value >= 1.0) {
                  return Icon(Icons.arrow_upward);
                }
                return Text("${progressInfo}%");
              }
            ),
          ),
        );
      }
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
    print("onNotification：${n.runtimeType}");

    if(n is ScrollUpdateNotification){
      //当前滚动的位置和总长度
      final currentPixel = n.metrics.pixels;
      final totalPixel = n.metrics.maxScrollExtent;
      progress.value = currentPixel/totalPixel;
      // print("正在滚动：${currentPixel} - ${totalPixel}");
    }

    if (n is! UserScrollNotification) {
      isScrolling.value = n is! ScrollEndNotification;
      // print("onNotification：${isScrolling.value} - ${n.runtimeType}");
    }
    return false;//为 true，则事件会阻止向上冒泡，不推荐(除非有必要)
  }

  /// 监听尺寸改变
  _buildSizeChangedLayoutNotifier() {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: _onNotification,
      child: SizeChangedLayoutNotifier(
        // key: _filterBarChangeKey,
        child: Wrap(),
      )
    );
  }

  bool _onNotification(SizeChangedLayoutNotification notification) {
    // change height here
    // _filterBarChangeKey = GlobalKey();
    return false;
  }
}



class NotificationCustomDemo extends StatefulWidget {
  @override
  NotificationCustomDemoState createState() {
    return NotificationCustomDemoState();
  }
}

class NotificationCustomDemoState extends State<NotificationCustomDemo> {
  String _msg = "";

  @override
  Widget build(BuildContext context) {
    //监听通知  
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
    ),
      body: StatefulBuilder(
          builder: (context, setStates) {
          return NotificationListener<MyNotification>(
            onNotification: (n) {
              _msg += n.msg;

              // setState(() {});
              Future.delayed(Duration(milliseconds: 100), () {
                setStates(() {});
              });//如果太过频繁会被冲掉,需要延迟才会触发 StatefulBuilder的builder
              return true;
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        //按钮点击时分发通知
                        onPressed: () => MyNotification("Hi").dispatch(context),
                        child: Text("Send Notification"),
                      );
                    },
                  ),
                  Text(_msg),
                  Material()
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
}