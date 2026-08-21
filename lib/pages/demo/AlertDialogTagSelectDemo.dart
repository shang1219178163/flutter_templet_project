import 'package:flutter/material.dart';
import 'package:flutter_templet_project/mixin/dialog_tag_select.dart';
import 'package:flutter_templet_project/model/selected_model.dart';

class AlertDialogTagSelectDemo extends StatefulWidget {
  AlertDialogTagSelectDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _AlertDialogTagSelectDemoState createState() =>
      _AlertDialogTagSelectDemoState();
}

class _AlertDialogTagSelectDemoState extends State<AlertDialogTagSelectDemo> {
  final items = List.generate(10, (i) => "$i");

  /// 标签列表
  late List<SelectModel> tags = items
      .map((e) => SelectModel(
            id: e.toString(),
            name: "标签_$e",
          ))
      .toList();

  /// 选择的标签
  List<SelectModel> selectTags = [];

  /// 临时选择的标签病列表
  List<SelectModel> selectTagsTmp = [];

  /// 已选择的标签
  List<String> get selectTagNames =>
      selectTags.map((e) => e.name ?? "-").toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    onPressed: onPressed,
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
        ),
        body: Column(
          children: [
            buildWrap(
              onTap: onTap,
            ),
          ],
        ));
  }

  Widget buildWrap({
    required ValueChanged<int> onTap,
  }) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.start,
      children: items.map((e) {
        final i = items.indexOf(e);
        return ActionChip(
          avatar: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(e),
          ),
          label: Text(e),
          onPressed: () => onTap.call(i),
        );
      }).toList(),
    );
  }

  onTap(int i) {
    debugPrint(i.toString());
  }

  onPressed() {
    DialogTagSelect().present(
      context: context,
      title: "标签",
      tags: tags,
      selectTagsTmp: selectTagsTmp,
      selectTags: selectTags,
      // isMuti: false,
      onCancel: () {},
      onConfirm: (List<SelectModel> selectedItems) {
        selectTags = selectedItems;

        debugPrint(selectTagNames.toString());
        setState(() {});
      },
      max: 3,
      onMax: () {
        showAboutDialog(
          context: context,
          applicationName: "最多选择 3 个",
        );
      },
    );
  }
}
