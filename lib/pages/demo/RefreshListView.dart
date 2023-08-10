

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

class RefreshListView extends StatefulWidget {

  RefreshListView({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _RefreshListViewState createState() => _RefreshListViewState();
}

class _RefreshListViewState extends State<RefreshListView> {

  late final _easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final items = ValueNotifier(<String>[]);

  /// 首次加载
  var _isFirstLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // final result = List<String>.generate(5, (i) => 'Item_$i');
    // items.value = result;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _easyRefreshController?.callRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _easyRefreshController?.callRefresh();

          },)
        ).toList(),
      ),
      body: buildEasyRefresh(),
    );
  }

  buildEasyRefresh() {
    return EasyRefresh.builder(
      controller: _easyRefreshController,
      header: EmptyHeader(),
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 1500), () {});
        final result = List<String>.generate(5, (i) => 'Item_$i');
        items.value = result;

        debugPrint("onRefresh");
        _isFirstLoad = false;
        _easyRefreshController.finishRefresh();
        setState(() {});
      },
      onLoad: () async {
        await Future.delayed(const Duration(milliseconds: 1500), () {});
        final result = List<String>.generate(5, (i) => 'Item_${items.value.length + i}');
        items.value = [...items.value, ...result];

        debugPrint("onLoad");
        _easyRefreshController.finishLoad();
      },
      childBuilder: (context, physics) {

        return ValueListenableBuilder<List<String>>(
           valueListenable: items,
           builder: (context, list, child){

            return ListView.separated(
              physics: physics,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                final e = list[index];
                return ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Text("$e"),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },

            );
          }
        );
      },
    );
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
// class EmptyHeader extends CustomHeader {
//
//   const EmptyHeader({
//     required super.triggerOffset,
//     required super.clamping,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title ?? "$this"),
//         actions: ['done',].map((e) => TextButton(
//           child: Text(e,
//             style: TextStyle(color: Colors.white),
//           ),
//           onPressed: () => debugPrint(e),
//         )).toList(),
//       ),
//       body: Text(arguments.toString());
//     );
//   }
// }