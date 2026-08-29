//
//	ExpandIconDemoNew.dart
//	MacTemplet
//
//	Created by Bin Shang on 2021/06/11 16:13
//	Copyright © 2021 Bin Shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';
import 'package:flutter_templet_project/util/dlog.dart';

class ExpandIconDemoNew extends StatefulWidget {
  const ExpandIconDemoNew({Key? key}) : super(key: key);

  @override
  ExpandIconDemoNewState createState() => ExpandIconDemoNewState();
}

class ExpandIconDemoNewState extends State<ExpandIconDemoNew> {
  late bool _isExpanded = false;

  late List<ExpandedItem<String>> _data;

  @override
  void initState() {
    _data = generateItems(3);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      // body: buildExpandIcon(context),
      // body: buildExpansionPanelList(context),
      body: SafeArea(
        child: Column(
          children: [
            // buildExpandIcon(),
            Expanded(child: buildExpansionPanelList()),
          ],
        ),
      ),
    );
  }

  Widget buildExpandIcon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.green,
          child: Row(
            children: <Widget>[
              SizedBox(width: 25),
              Expanded(
                child: Text('ExpandIcon Row', style: TextStyle(color: Colors.white, fontSize: 22)),
              ),
              ExpandIcon(
                isExpanded: _isExpanded,
                color: Colors.white,
                expandedColor: Colors.black,
                disabledColor: Colors.grey,
                onPressed: (isExpanded) {
                  setState(() {
                    _isExpanded = !isExpanded;
                    DLog.d(isExpanded);
                  });
                },
              ),
              SizedBox(width: 25),
            ],
          ),
        ),
        Visibility(
          visible: _isExpanded,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              '我被 ExpandIcon 控制显示状态',
              style: TextStyle(
                color: Colors.black,
                // decorationColor: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildExpansionPanelList() {
    return SingleChildScrollView(
      child: Container(
        child: ExpansionPanelList(
          dividerColor: Colors.red,
          // elevation: 4,
          materialGapSize: 0,
          expandedHeaderPadding: EdgeInsets.only(top: 0, bottom: 0),
          expansionCallback: (index, isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((item) {
            return ExpansionPanel(
              isExpanded: item.isExpanded,
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return CustomExpansionTile();
                // return ListTile(
                //   title: Text(item.headerValue),
                //   subtitle: Text("subtitle"),
                // );
              },
              body: buildExpansionPanelBody(item.index),
              // body: buildListTitle(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildExpansionPanelBody(int section) {
    final item = _data[section];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: item.items
          .map((e) => Column(
                children: [
                  ListTile(
                      title: Text("detail index: $e"),
                      subtitle: Text('To delete this panel, tap the trash can icon'),
                      trailing: Icon(Icons.delete),
                      onTap: () {
                        DLog.d("section_${section}_$e");
                        setState(() {});
                      }),
                  Divider(
                    color: Colors.blue,
                  ),
                ],
              ))
          .toList(),
    );
  }

  Widget buildListTitle(ExpandedItem item) {
    return ListTile(
        title: Text(item.expandedValue),
        subtitle: Text('To delete this panel, tap the trash can icon'),
        trailing: Icon(Icons.delete),
        onTap: () {
          setState(() {
            _data.removeWhere((currentItem) => item == currentItem);
          });
        });
  }

  List<ExpandedItem<String>> generateItems(int count) {
    return List<ExpandedItem<String>>.generate(count, (index) {
      return ExpandedItem<String>(
        index: index,
        headerValue: 'Panel $index',
        expandedValue: 'This is item number $index',
        items: List.generate(index, (index) => "$index"),
      );
    });
  }
}

// stores ExpansionPanel state information
class ExpandedItem<E> {

  ExpandedItem({
    required this.index,
    required this.expandedValue,
    required this.headerValue,
    required this.items,
    this.isExpanded = false,
  });
  int index;
  String expandedValue;
  String headerValue;
  bool isExpanded;

  List<E> items;
}

///自定义视图
class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({Key? key}) : super(key: key);

  @override
  State createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: ColorExt.random,
      leading: Icon(
        Icons.face,
        size: 36.0,
      ),
      title: Container(
        // Change header (which is a Container widget in this case) background colour here.
        color: isExpanded ? Colors.orange : Colors.green,
        child: Text(
          "HEADER HERE",
          style: TextStyle(
            color: isExpanded ? Colors.black : Colors.black,
          ),
        ),
      ),
      subtitle: Text("subtitle"),
      onExpansionChanged: (expanding) => setState(() => isExpanded = expanding),
      children: <Widget>[
        Text("Child Widget One"),
        Text("Child Widget Two"),
      ],
    );
  }
}
