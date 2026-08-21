import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/vendor/isar/DBManager.dart';
import 'package:flutter_templet_project/vendor/isar/model/db_order.dart';
import 'package:flutter_templet_project/vendor/isar/page/OrderListPage.dart';
import 'package:flutter_templet_project/vendor/isar/page/OrderListPageOne.dart';
import 'package:flutter_templet_project/vendor/isar/provider/change_notifier/db_generic_provider.dart';
import 'package:provider/provider.dart';

class OrderListTabPage extends StatefulWidget {
  OrderListTabPage({super.key, this.title});

  final String? title;

  @override
  State<OrderListTabPage> createState() => _OrderListTabPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _OrderListTabPageState extends State<OrderListTabPage> {
  late final items = <(String, Widget)>[
    ('DBGenericProvider', OrderListPage()),
    ('GenericProvider<DBOrder>', OrderListPageOne()),
  ];

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
                  onPressed: () => debugPrint(e),
                ))
            .toList(),
      ),
      body: NPageView(
        needSafeArea: false,
        items: items,
        onPageChanged: _onPageChanged,
      ),
    );
  }

  void _onPageChanged(int index) {
    switch (index) {
      case 0:
        context.read<DBGenericProvider<DBOrder>>().notify();
      case 1:
        DBManager.findController<DBOrder>().notify();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<(String, Widget)>('items', items));
  }
}
