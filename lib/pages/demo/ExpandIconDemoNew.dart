//
//	ExpandIconDemoNew.dart
//	MacTemplet
//
//	Created by Bin Shang on 2021/06/11 16:13
//	Copyright © 2021 Bin Shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/extension_local.dart';

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
    _data = _generateItems(3);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      // body: _buildExpandIcon(context),
      // body: _buildExpansionPanelList(context),
      body: SafeArea(
        child: Column(
          children: [
            // _buildExpandIcon(),
            Expanded(child: _buildExpansionPanelList()),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
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
                onPressed: (bool isExpanded) {
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

  Widget _buildExpansionPanelList() {
    return SingleChildScrollView(
      child: Container(
        child: ExpansionPanelList(
          dividerColor: Colors.red,
          // elevation: 4,
          materialGapSize: 0,
          expandedHeaderPadding: EdgeInsets.only(top: 0, bottom: 0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _data[index].isExpanded = !isExpanded;
            });
          },
          children: _data.map<ExpansionPanel>((item) {
            return ExpansionPanel(
              isExpanded: item.isExpanded,
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return CustomExpansionTile();
                return Container(
                  color: Colors.green,
                  child: ListTile(
                    title: Text(item.headerValue),
                    subtitle: Text("subtitle"),
                  ),
                );
                // return ListTile(
                //   title: Text(item.headerValue),
                //   subtitle: Text("subtitle"),
                // );
              },
              body: _buildExpansionPanelBody(item.index),
              // body: _buildListTitle(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExpansionPanelBody(int section) {
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

  _buildListTitle(ExpandedItem item) {
    return ListTile(
        title: Text(item.expandedValue),
        subtitle: Text('To delete this panel, tap the trash can icon'),
        trailing: Icon(Icons.delete),
        onTap: () {
          setState(() {
            _data.removeWhere((ExpandedItem currentItem) => item == currentItem);
          });
        });
  }

  List<ExpandedItem<String>> _generateItems(int count) {
    return List<ExpandedItem<String>>.generate(count, (int index) {
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
  int index;
  String expandedValue;
  String headerValue;
  bool isExpanded;

  List<E> items;

  ExpandedItem({
    required this.index,
    required this.expandedValue,
    required this.headerValue,
    required this.items,
    this.isExpanded = false,
  });
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
      onExpansionChanged: (bool expanding) => setState(() => isExpanded = expanding),
      children: <Widget>[
        Text("Child Widget One"),
        Text("Child Widget Two"),
      ],
    );
  }
}
