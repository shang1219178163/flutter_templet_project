import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_templet_project/extension/buildContext_extension.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


class ThirdPage extends StatefulWidget {

  final String? title;
  ThirdPage({ Key? key, this.title}) : super(key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  late EasyRefreshController _controller;
  late ScrollController _scrollController;

  var items = List<String>.generate(20, (i) => 'Item ${i}');

  var selectedIndex = 0;

  GlobalKey _globalKey(int index) {
    return GlobalKey(debugLabel: "$index");
  }

  @override
  void initState() {
    super.initState();

    _controller = EasyRefreshController();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: onDone,)
        ).toList(),
      ),
      body: EasyRefresh(
        controller: _controller,
        child: buildListView(),
        onRefresh: () async {
          ddlog("onRefresh");
          await Future.delayed(Duration(seconds: 1), () {
            if (!mounted) {
              return;
            }
            setState(() {
              items = List<String>.generate(3, (i) => 'Item ${items.length + i}');
            });
            _controller.finishRefresh();
          });
        },
        onLoad: () async {
          ddlog("onLoad");
          await Future.delayed(Duration(seconds: 1), () {
            if (!mounted) {
              return;
            }
            setState(() {
              items.addAll(List<String>.generate(
                  20, (i) => 'Item ${items.length + i}'));
            });
            _controller.finishLoad(noMore: (items.length >= 80));
          });
        },
      ),
    );
  }

  onDone() {
    print("onDone");
    _controller.callRefresh();
  }

  Widget buildListView({canDelete: false}) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        final child = ListTile(
          title: Text("$item"),
          selected: (selectedIndex == index),
          // trailing: selectedIndex == index ? Icon(Icons.check) : null,
          trailing: selectedIndex == index ? Icon(Icons.check) : null,
          onTap: (){
            setState(() {
              selectedIndex = index;
            });
            ddlog([selectedIndex, index,]);
            ddlog([_globalKey(index).position(), _globalKey(index).size]);
          },
        );

        return Dismissible(
          key: Key(item),
          child: child,
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