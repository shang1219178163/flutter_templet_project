

import 'package:flutter/material.dart';

import 'package:easy_refresh/easy_refresh.dart';

import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';


class ThirdPage extends StatefulWidget {

  final String? title;
  const ThirdPage({ Key? key, this.title}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  late EasyRefreshController _controller;
  late ScrollController _scrollController;

  var items = List<String>.generate(20, (i) => 'Item $i');

  var selectedIndex = 0;

  GlobalKey _globalKey(int index) {
    return GlobalKey(debugLabel: "$index");
  }

  @override
  void initState() {
    super.initState();

    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          onPressed: onDone,
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),)
        ).toList(),
      ),
      body: EasyRefresh(
        controller: _controller,
        onRefresh: () async {
          ddlog("onRefresh");
          await Future.delayed(Duration(seconds: 1), () {
            if (!mounted) {
              return;
            }
            items = List<String>.generate(3, (i) => 'Item ${items.length + i}');

            setState(() {});
            _controller.finishRefresh();
          });
        },
        onLoad: () async {
          ddlog("onLoad");
          await Future.delayed(Duration(seconds: 1), () {
            if (!mounted) { return; }
            items.addAll(List<String>.generate(
                20, (i) => 'Item ${items.length + i}')
            );
            _controller.finishLoad(items.length >= 80 ? IndicatorResult.noMore : IndicatorResult.success);
            setState(() {});
          });
        },
        child: buildListView(),
      ),
    );
  }

  onDone() {
    _controller.callRefresh();
  }

  Widget buildListView({canDelete = false}) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        final child = ListTile(
          title: Text(item),
          selected: (selectedIndex == index),
          // trailing: selectedIndex == index ? Icon(Icons.check) : null,
          trailing: selectedIndex == index ? Icon(Icons.check) : null,
          onTap: (){
            selectedIndex = index;
            setState(() {});
            ddlog([selectedIndex, index,]);
            ddlog([_globalKey(index).position(), _globalKey(index).size]);
          },
        );

        return Dismissible(
          key: Key(item),
          onDismissed: (direction) {
            setState(() {
              items.removeAt(index);
            });

            if (direction == DismissDirection.startToEnd) {
              ddlog("Add to favorite");
            } else {
              ddlog('Remove item');
            }
          },
          background: buildFavorite(context),
          secondaryBackground: buildDelete(context),
          confirmDismiss: (DismissDirection direction) async {
            return buildConfirmDismiss(context);
          },
          child: child,
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          height: .5,
          indent: 15,
          endIndent: 15,
          color: Color(0xFFDDDDDD),
        );
      },
    );
  }

  Widget buildFavorite(BuildContext context) {
    return
      Container(
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.favorite, color: Colors.white),
              Text('Move to favorites', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
  }

  Widget buildDelete(BuildContext context) {
    return
    Container(
      color: Colors.red,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
            Text('Move to trash', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<bool?> buildConfirmDismiss(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete")
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}