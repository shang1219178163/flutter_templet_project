import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/snack_bar_state_ext.dart';


class RefreshIndicatorDemoOne extends StatefulWidget {

  const RefreshIndicatorDemoOne({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _RefreshIndicatorDemoOneState createState() => _RefreshIndicatorDemoOneState();
}

class _RefreshIndicatorDemoOneState extends State<RefreshIndicatorDemoOne> {
  var list = <String>[];

  int _pageIndex = 1;

  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    //初始化加载数据
    loadData(_pageIndex);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: () => debugPrint(e.toString()),
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show refresh indicator programmatically on button tap.
          _refreshIndicatorKey.currentState?.show();
        },
        icon: const Icon(Icons.refresh),
        label: const Text('Show Indicator'),
      ),
      body: buildBody(),
    );
  }


  Widget buildBody() {
    return NotificationListener(
      onNotification: (ScrollNotification n) {
        /// 判断滑动距离【小于等于400 】和 滚动方向
        final needRefresh = n.metrics.pixels >= (n.metrics.maxScrollExtent - 400) &&
            n.metrics.axis == Axis.vertical;
        if (needRefresh) {
          _pageIndex += 1;
          loadData(_pageIndex);
        }
        return true;
      },
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () async {
          _pageIndex = 1;
          loadData(_pageIndex);
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        // Pull from top to show refresh indicator.
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('Item $index'),
            );
          },
        ),
      ),
    );
  }

  /// 请求列表数据
  loadData(int pageIndex) async {

    try {
      Future<void>.delayed(const Duration(seconds: 2));

      var items = List.generate(20, (index) => "item_$index").toList();
      if (pageIndex == 1) {
        list = items;
      } else {
        list.addAll(items);
      }
      showSnackBar(SnackBar(content: Text("${list.length} items",)));
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    } finally {

    }
  }
}

