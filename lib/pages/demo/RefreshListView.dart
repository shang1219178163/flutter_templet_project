import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class RefreshListView extends StatefulWidget {
  RefreshListView({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RefreshListViewState createState() => _RefreshListViewState();
}

class _RefreshListViewState extends State<RefreshListView> {
  late final _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final items = ValueNotifier(<String>[]);

  @override
  void initState() {
    super.initState();

    final result = List<String>.generate(5, (i) => 'Item_$i');
    items.value = result;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshController.callRefresh();
    });
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
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _refreshController.callRefresh();
                  },
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return EasyRefresh.builder(
      controller: _refreshController,
      header: EmptyHeader(),
      onRefresh: onRefresh,
      onLoad: onLoad,
      childBuilder: (context, physics) {
        return ValueListenableBuilder<List<String>>(
          valueListenable: items,
          builder: (context, list, child) {
            return ListView.separated(
              physics: physics,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final e = list[index];
                return ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Text(e),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          },
        );
      },
    );
  }

  onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    final result = List<String>.generate(5, (i) => 'Item_$i');
    items.value = result;

    debugPrint("onRefresh");
    _refreshController.finishRefresh();
    // setState(() {});
  }

  onLoad() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    final result = List<String>.generate(5, (i) => 'Item_${items.value.length + i}');
    items.value = [...items.value, ...result];

    debugPrint("onLoad");
    _refreshController.finishLoad();
  }
}

class EmptyHeader extends Header {
  const EmptyHeader({
    bool clamping = true,
    IndicatorPosition position = IndicatorPosition.custom,
    FrictionFactor? frictionFactor,
    FrictionFactor? horizontalFrictionFactor,
    bool? hitOver,
    double maxOverOffset = double.infinity,
  }) : super(
          triggerOffset: 0,
          clamping: clamping,
          infiniteOffset: null,
          position: position,
          spring: null,
          horizontalSpring: null,
          frictionFactor: frictionFactor,
          horizontalFrictionFactor: horizontalFrictionFactor,
          processedDuration: const Duration(seconds: 0),
          hitOver: hitOver,
          maxOverOffset: maxOverOffset,
        );

  @override
  Widget build(BuildContext context, IndicatorState state) {
    // return const SizedBox();
    return Container(
      color: Colors.red,
      height: 50,
      width: 200,
    );
  }
}
