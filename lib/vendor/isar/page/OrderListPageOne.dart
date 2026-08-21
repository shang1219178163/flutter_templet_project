import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_choic_bottom_bar.dart';
import 'package:flutter_templet_project/basicWidget/n_placeholder.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';
import 'package:flutter_templet_project/vendor/isar/DBDialogMixin.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_order.dart';
import 'package:flutter_templet_project/vendor/isar/page/OrderItem.dart';
import 'package:flutter_templet_project/vendor/isar/provider/gex_controller/db_generic_controller.dart';
import 'package:get/get.dart';

/// DBGenericController<DBOrder> 示例
class OrderListPageOne extends StatefulWidget {
  OrderListPageOne({super.key, this.title});

  final String? title;

  @override
  State<OrderListPageOne> createState() => _OrderListPageOneState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _OrderListPageOneState extends State<OrderListPageOne> with DBDialogMixin {
  final _scrollController = ScrollController();

  final titleController = TextEditingController();

  bool isAllChoic = false;

  DBGenericController<DBOrder> get provider => DBManager.findController<DBOrder>();

  @override
  Widget build(BuildContext context) {
    final automaticallyImplyLeading = Get.currentRoute.toLowerCase() == "/$widget".toLowerCase();

    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("$widget"),
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: [
          IconButton(onPressed: onAddItemRandom, icon: Icon(Icons.add)),
        ],
      ),
      body: GetBuilder<DBGenericController<DBOrder>>(
        tag: DBManager.controllerTag,
        builder: (value) {
          final checkedItems = value.entities.where((e) => e.isSelected == true).toList();
          isAllChoic = value.entities.firstWhereOrNull((e) => e.isSelected == false) == null;

          final checkIcon = isAllChoic ? Icons.check_box : Icons.check_box_outline_blank;
          final checkDesc = "已选择 ${checkedItems.length}/${value.entities.length}";

          Widget content = NPlaceholder(
            onTap: () {
              provider.update();
            },
          );
          if (value.entities.isNotEmpty) {
            content = buildRefresh(
              onRefresh: () {
                provider.update();
              },
              child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: value.entities.length,
                  itemBuilder: (context, index) {
                    final model = value.entities.reversed.toList()[index];

                    onToggle() {
                      model.isSelected = !model.isSelected;
                      provider.put(model);
                    }

                    return InkWell(
                      onTap: onToggle,
                      child: OrderItem(
                        model: model,
                        onToggle: onToggle,
                        onEdit: () {
                          titleController.text = model.title;

                          presentDialog(
                              controller: titleController,
                              onSure: (val) {
                                model.title = val;
                                provider.put(model);
                              });
                        },
                        onDelete: () {
                          provider.delete(model.id);
                        },
                      ),
                    );
                  }),
            );
          }

          return Column(
            children: [
              Expanded(
                child: content,
              ),
              NChoicBottomBar(
                checkIcon: checkIcon,
                checkDesc: checkDesc,
                onCheck: () async {
                  DLog.d("isAllChoic TextButton: $isAllChoic");
                  for (var i = 0; i < value.entities.length; i++) {
                    final e = value.entities[i];
                    e.isSelected = !isAllChoic;
                  }
                  provider.putAll(value.entities);
                },
                onAdd: onAddItemRandom,
                onDelete: () async {
                  final choicItems = value.entities.where((e) => e.isSelected).map((e) => e.id).toList();
                  await provider.deleteAll(choicItems);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildRefresh({
    EasyRefreshController? controller,
    FutureOr Function()? onRefresh,
    FutureOr Function()? onLoad,
    required Widget? child,
  }) {
    return EasyRefresh(
      // refreshOnStart: true,
      canRefreshAfterNoMore: true,
      canLoadAfterNoMore: true,
      controller: controller,
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: child,
    );
  }

  onAddItemRandom() {
    titleController.text = "项目${IntExt.random(max: 999)}";
    addTodoItem(title: titleController.text);
  }

  addTodoItem({required String title}) {
    if (title.isEmpty) {
      return;
    }

    var todo = DBOrder(
      title: title,
      isSelected: false,
      createdDate: DateTime.now().toIso8601String(),
    );
    provider.put(todo);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>('titleController', titleController));
    properties.add(DiagnosticsProperty<bool>('isAllChoic', isAllChoic));
    properties.add(DiagnosticsProperty<DBGenericController<DBOrder>>('provider', provider));
  }
}
