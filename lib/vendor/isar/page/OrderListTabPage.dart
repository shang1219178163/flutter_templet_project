

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_page_view.dart';
import 'package:flutter_templet_project/vendor/isar/page/OrderListPage.dart';
import 'package:flutter_templet_project/vendor/isar/page/OrderListPageOne.dart';
import 'package:tuple/tuple.dart';

class OrderListTabPage extends StatefulWidget {

  OrderListTabPage({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<OrderListTabPage> createState() => _OrderListTabPageState();
}

class _OrderListTabPageState extends State<OrderListTabPage> {

  final _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return NPageView(
      needSafeArea: false,
      items: items,
      onPageChanged: (index) {

      },
    );
  }

  List<Tuple2<String, Widget>> items = [
    Tuple2('DBGenericProvider', OrderListPage()),
    Tuple2('GenericProvider<DBOrder>', OrderListPageOne()),
  ];
}