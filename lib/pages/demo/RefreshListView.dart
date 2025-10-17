import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_textfield.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';

class RefreshListView extends StatefulWidget {
  RefreshListView({Key? key, this.title}) : super(key: key);

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
    super.initState();

    final result = List<String>.generate(5, (i) => 'Item_$i');
    items.value = result;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _easyRefreshController.callRefresh();
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
                    _easyRefreshController.callRefresh();
                  },
                ))
            .toList(),
      ),
      // body: buildEasyRefresh(),
      body: buildRefresh(),
    );
  }

  Widget buildEasyRefresh() {
    return EasyRefresh.builder(
      controller: _easyRefreshController,
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
              itemBuilder: (BuildContext context, int index) {
                final e = list[index];
                return ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Text(e),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
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
    _isFirstLoad = false;
    _easyRefreshController.finishRefresh();
    // setState(() {});
  }

  onLoad() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    final result = List<String>.generate(5, (i) => 'Item_${items.value.length + i}');
    items.value = [...items.value, ...result];

    debugPrint("onLoad");
    _easyRefreshController.finishLoad();
  }

  Widget buildRefresh() {
    return EasyRefresh(
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: ValueListenableBuilder<List<String>>(
        valueListenable: items,
        builder: (context, list, child) {
          return ListView.separated(
            // physics: physics,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final e = list[index];

              final controller = TextEditingController();
              controller.text =
                  """主流程业务涵盖了用户在使用我们的系统购买机票、酒店等各类产品时所接触的所有页面。这些页面的 UI 复杂度极高，开发过程中，从 UI 编写到最终验收，需要不断地调整细节，这个过程既繁琐又耗时。其次，C 端业务涉及的客户端类型多样，包括 APP 端、小程序、PC 端和 H5 等。这些不同的客户端都需要我们去适配和开发，进一步增加了工作的复杂性。
                营销活动的页面的 UI 复杂度也很高，并且很多页面涉及到复杂交互设计，如秒杀、砍价等。在开发这些营销活动时，我们遇到的痛点主要有两个：一是时间紧迫，比如五一、十一等节日活动，节前必须上线；二是活动量巨大，尽管我们已有低代码平台来解决部分问题，但活动形式的不断更新，使得我们的开发工作量依然巨大。
                B 端业务主要指的是我们公司内部使用的各类后台管理系统。这些页面以大量的表单和表格为特征，信息密度极高，内容丰富。随着公司业务的增长，人力资源变得紧张，大量的需求积压。因此，我们开展这项代码生成工作的首要目标是提升前端开发效率。""";
              return Column(
                children: [
                  ListTile(leading: Icon(Icons.ac_unit), title: Text(e)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: NTextField(
                      key: ObjectKey(e),
                      // controller: controller,
                      value: controller.text,
                      // scrollPhysics: const ClampingScrollPhysics(),//避免触发下拉刷新
                      minLines: 10,
                      maxLines: 10,
                      onChanged: (v) {
                        DLog.d("index: $index: $v");
                      },
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(color: AppColor.lineColor, width: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          );
        },
      ),
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
