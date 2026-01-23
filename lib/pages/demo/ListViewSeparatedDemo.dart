import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_list_view_separated.dart';
import 'package:get/get.dart';

class ListViewSeparatedDemo extends StatefulWidget {
  const ListViewSeparatedDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<ListViewSeparatedDemo> createState() => _ListViewSeparatedDemoState();
}

class _ListViewSeparatedDemoState extends State<ListViewSeparatedDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  Map<String, dynamic> arguments = Get.arguments ?? <String, dynamic>{};

  /// id
  late final id = arguments["id"];

  @override
  void didUpdateWidget(covariant ListViewSeparatedDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("$widget"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final list = List.generate(20, (i) => 'Item $i');
    return Scrollbar(
      controller: scrollController,
      child: NListViewSeparated(
        controller: scrollController,
        header: buildHeader(),
        footer: buildFooter(),
        itemCount: list.length,
        itemBuilder: (_, i) => ListTile(title: Text(list[i])),
        separatorBuilder: (_, __) => const Divider(indent: 15, endIndent: 15),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Text('Header'),
    );
  }

  Widget buildFooter() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Text('Footer'),
    );
  }
}
