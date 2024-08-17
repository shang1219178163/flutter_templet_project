import 'package:flutter/material.dart';

class SliverAnimatedListDemo extends StatefulWidget {
  const SliverAnimatedListDemo({Key? key}) : super(key: key);

  @override
  _SliverAnimatedListDemoState createState() => _SliverAnimatedListDemoState();
}

class _SliverAnimatedListDemoState extends State<SliverAnimatedListDemo> {
  final listKey = GlobalKey<SliverAnimatedListState>();
  final List<int> list = [0, 1, 2];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SliverAnimatedList'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: onInsert,
            iconSize: 32,
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: onRemove,
            iconSize: 32,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAnimatedList(
            key: listKey,
            initialItemCount: list.length,
            itemBuilder: _buildItem,
          ),
        ],
      ),
    );
  }

  // 创建item
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          title: Text(
            'Item $index',
          ),
        ),
      ),
    );
  }

  // 新增item
  onInsert() {
    final _index = list.length;
    list.insert(_index, _index);
    listKey.currentState!.insertItem(_index);
  }

  // 移除最后一个item
  onRemove() {
    if (list.isEmpty) {
      return;
    }
    final _index = list.length - 1;
    var item = list[_index];
    listKey.currentState!.removeItem(
        _index, (context, animation) => _buildItem(context, item, animation));
    list.removeAt(_index);
  }
}
