import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DismissibleDemo extends StatefulWidget {

  final String? title;

  const DismissibleDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _DismissibleDemoState createState() => _DismissibleDemoState();
}

class _DismissibleDemoState extends State<DismissibleDemo> {

  final List<Map> _list = List<Map>.generate(
    20,(i) => {'title': '标题$i', 'subTitle': '二级标题$i'},
  );

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _list[index];
        return Dismissible(
          key: Key(item.toString()),
          // crossAxisEndOffset: 1.0,
          // secondaryBackground: Container(color: Colors.pink),
          dragStartBehavior: DragStartBehavior.down,
          direction: DismissDirection.endToStart,
          background: Container(color: Colors.red),
          onDismissed: (direction) {
            _list.removeAt(index);
            debugPrint(_list.length.toString());
            setState(() {});
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('删除成功...'),
            ));
          },
          confirmDismiss: (direction) async {
            debugPrint(direction.toString());
            return true;
          },
          child: ListTile(
            title: Text(item['title']),
            subtitle: Text(item['subTitle']),
          ),
        );
      },
    );
  }
}