import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/snack_bar_ext.dart';

class AnimatedListSample extends StatefulWidget {
  const AnimatedListSample({Key? key}) : super(key: key);

  @override
  _AnimatedListSampleState createState() => _AnimatedListSampleState();
}

class _AnimatedListSampleState extends State<AnimatedListSample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<int> _list;
  int? _selectedItem = 0;
  int _nextItem =
      0; // The next item inserted when the user presses the '+' button.
  ///
  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimatedList'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: _insert,
            tooltip: 'insert a new item',
          ),
          IconButton(
            icon: Icon(Icons.remove_circle),
            onPressed: _remove,
            tooltip: 'remove the selected item',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: AnimatedList(
          key: _listKey,
          initialItemCount: _list.length,
          itemBuilder: _buildItem,
        ),
      ),
    );
  }

  ///
  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    if (index == 0) {
      return Container();
    }
    final e = _list[index];
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == e,
      onTap: () {
        if (_selectedItem == e) {
          return;
        }
        setState(() {
          _selectedItem = e;
        });
      },
    );
  }

  Widget _buildRemovedItem(
      int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
      selected: false,
    );
  }

  _insert() {
    _list.insert(_list.length, _nextItem++);
  }

  _remove() {
    if (_list.length == 0) {
      showToast("暂无数据");
      return;
    }
    _list.removeAt(_list.length - 1);
  }

  showToast(String msg) {
    final snack = SnackBar(content: Text(msg));
    showSnackBar(snack);
  }
}

class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  ///
  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  ///
  AnimatedListState? get _animatedList => listKey.currentState;

  ///
  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList?.insertItem(index);
  }

  ///
  E removeAt(int index) {
    final removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList?.removeItem(
        index,
        (BuildContext context, Animation<double> animation) {
          return removedItemBuilder(removedItem, context, animation);
        },
      );
    }
    return removedItem;
  }

  ///
  int get length => _items.length;

  ///
  E operator [](int index) => _items[index];

  ///
  int indexOf(E item) => _items.indexOf(item);
}

class CardItem extends StatelessWidget {
  const CardItem(
      {Key? key,
      required this.animation,
      this.onTap,
      required this.item,
      this.selected = false})
      : assert(animation != null),
        assert(item != null && item >= 0),
        assert(selected != null),
        super(key: key);

  ///
  final Animation<double> animation;
  final VoidCallback? onTap;
  final int item;
  final bool selected;

  ///
  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.labelLarge;
    if (selected) {
      textStyle = textStyle?.copyWith(color: Colors.lightGreenAccent[400]);
    }
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: SizedBox(
            height: 60.0,
            child: Card(
              color: Colors.primaries[item % Colors.primaries.length],
              child: Center(
                child: Text('Item $item', style: textStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
