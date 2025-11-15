import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/color_ext.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/extension/src/num_ext.dart';
import 'package:flutter_templet_project/routes/AppRouteObserver.dart';

class ThirdPage extends StatefulWidget {
  final String? title;
  const ThirdPage({Key? key, this.title}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> with RouteAware {
  late final _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  late final _scrollController = ScrollController();

  final offsetY = ValueNotifier(0.0);

  var items = List<String>.generate(3, (i) => 'Item $i');

  var selectedIndex = 0;

  GlobalKey _globalKey(int index) {
    return GlobalKey(debugLabel: "$index");
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      offsetY.value = _scrollController.position.pixels;
    });
  }

  @override
  void dispose() {
    AppRouteObserver().routeObserver.unsubscribe(this); //取消订阅
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    AppRouteObserver().routeObserver.subscribe(this, ModalRoute.of(context)!); //订阅
    super.didChangeDependencies();
  }

  @override
  void didPush() {
    debugPrint("------> $widget didPush");
    super.didPush();
  }

  @override
  void didPop() {
    debugPrint("------> $widget didPop");
    super.didPop();
  }

  @override
  void didPushNext() {
    debugPrint("------> $widget didPushNext");
    super.didPushNext();
  }

  @override
  void didPopNext() {
    debugPrint("------> $widget didPopNext");
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onDone,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildRefresh(
        child: buildListView(
          controller: _scrollController,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        },
        label: ValueListenableBuilder<double>(
            valueListenable: offsetY,
            builder: (context, value, child) {
              if (value == 0) {
                return Text("偏移量");
              }
              // return Text("datadata");
              final maxScrollExtent = _scrollController.position.maxScrollExtent.toStringAsFixed(0);
              debugPrint("maxScrollExtent: $maxScrollExtent");
              return Container(
                child: Text("${value.toStringAsFixed(0)}/$maxScrollExtent"),
              );
            }),
      ),
    );
  }

  onDone() {
    _easyRefreshController.callRefresh();
  }

  Widget buildRefresh({
    required Widget child,
  }) {
    return EasyRefresh(
      controller: _easyRefreshController,
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: child,
    );
  }

  onRefresh() async {
    DLog.d("onRefresh");
    await Future.delayed(Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
      items = List<String>.generate(3, (i) => 'Item ${items.length + i}');

      setState(() {});
      _easyRefreshController.finishRefresh();
    });
  }

  onLoad() async {
    DLog.d("onLoad");
    await Future.delayed(Duration(seconds: 1), () {
      if (!mounted) {
        return;
      }
      items.addAll(List<String>.generate(20, (i) => 'Item ${items.length + i}'));
      _easyRefreshController.finishLoad(items.length >= 60 ? IndicatorResult.noMore : IndicatorResult.success);
      setState(() {});
    });
  }

  Widget buildListView({
    ScrollController? controller,
    canDelete = false,
  }) {
    return Scrollbar(
      controller: controller,
      child: ListView.builder(
        controller: controller,
        reverse: true,
        // physics: BottomBouncingScrollPhysics(),
        // physics: MyScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          final child = ListTile(
            title: Text(item),
            selected: (selectedIndex == index),
            // trailing: selectedIndex == index ? Icon(Icons.check) : null,
            trailing: selectedIndex == index ? Icon(Icons.check) : null,
            onTap: () {
              selectedIndex = index;
              setState(() {});
              DLog.d([
                selectedIndex,
                index,
              ]);
              DLog.d([_globalKey(index).currentContext?.frame]);
            },
          );

          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                items.removeAt(index);
              });

              if (direction == DismissDirection.startToEnd) {
                DLog.d("Add to favorite");
              } else {
                DLog.d('Remove item');
              }
            },
            background: buildFavorite(context),
            secondaryBackground: buildDelete(context),
            confirmDismiss: (DismissDirection direction) async {
              return buildConfirmDismiss(context);
            },
            child: Container(height: IntExt.random(max: 100, min: 45).toDouble(), color: ColorExt.random, child: child),
          );
        },
        // separatorBuilder: (context, index) {
        //   return Divider(
        //     height: .5,
        //     indent: 15,
        //     endIndent: 15,
        //     color: Color(0xFFDDDDDD),
        //   );
        // },
      ),
    );
  }

  Widget buildFavorite(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.favorite, color: Colors.white),
            Text('Move to favorites', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget buildDelete(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
            Text('Move to trash', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<bool?> buildConfirmDismiss(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Delete")),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
