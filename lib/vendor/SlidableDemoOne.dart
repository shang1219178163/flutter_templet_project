

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableDemoOne extends StatefulWidget {

  SlidableDemoOne({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _SlidableDemoOneState createState() => _SlidableDemoOneState();
}

class _SlidableDemoOneState extends State<SlidableDemoOne> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

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
      body: ListView.separated(
        itemCount: 9,
        itemBuilder: (context, int index) {
            final content = ListTile(
              title: Text("item_$index"),
            );

            return buildSlidable(
              onPin: () async {
                debugPrint("onPin");
              },
              onDelete: () async {
                debugPrint("onDelete");
              },
              child: content,
            );
        },
        separatorBuilder: (context, int index) {
          return Divider(height: 1, color: Color(0xffe4e4e4),);
        },
      ),
    );
  }

  buildSlidable({
    required VoidCallback? onPin,
    required VoidCallback? onDelete,
    required Widget child,
  }) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) => onPin,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.push_pin,
            label: '置顶',
          ),
          SlidableAction(
            onPressed: (ctx) => onDelete,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          ),
        ],
      ),
      child: child,
    );
  }
}