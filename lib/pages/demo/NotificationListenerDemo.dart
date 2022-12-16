import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/scrollMetrics_extension.dart';

class NotificationListenerDemo extends StatefulWidget {

  final String? title;

  NotificationListenerDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _NotificationListenerDemoState createState() => _NotificationListenerDemoState();
}

class _NotificationListenerDemoState extends State<NotificationListenerDemo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  _buildBody() {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        // ScrollMetrics metrics = n?.metrics;
        var info = "atEdge:${n.metrics.atEdge},pixels:${n.metrics.pixels}";
        info = "isStart:${n.metrics.isStart},isEnd:${n.metrics.isEnd}";
        switch (n.runtimeType) {
          case ScrollStartNotification: print("开始滚动,$info"); break;
          case ScrollUpdateNotification: print("正在滚动,$info"); break;
          case ScrollEndNotification: print("滚动停止,$info"); break;
          case OverscrollNotification: print("滚动到边界,$info"); break;
        }
        return false;//false 不阻止冒泡;true 阻止冒泡
      },
      child: ListView.separated(
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
      body: NotificationListener<MyNotification>(
        onNotification: (n) {
          setState(() {
            _msg += n.msg;
          });
          return true;
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
  //           ElevatedButton(
  //           onPressed: () => MyNotification("Hi").dispatch(context),
  //           child: Text("Send Notification"),
  //          ),
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
      ),
    );
  }
}

class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
}