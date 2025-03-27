//
//  SystemIconsPage.dart
//  flutter_templet_project
//
//  Created by shang on 2022/9/17 14:57.
//  Copyright © 2022/9/17 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/dlog.dart';

import 'package:flutter_templet_project/util/icons_map.dart';

class SystemIconsPage extends StatefulWidget {
  const SystemIconsPage({Key? key}) : super(key: key);

  @override
  _SystemIconsPageState createState() => _SystemIconsPageState();
}

class _SystemIconsPageState extends State<SystemIconsPage> {
  TextEditingController editingController = TextEditingController();

  var list = List.from(kIConDic.keys);
  var searchResults = List.from(kIConDic.keys);

  bool isGrid = false;

  String get actionTitle => isGrid ? 'List' : 'Grid';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("fluttefr 系统 Icons"),
        actions: [
          TextButton(
            onPressed: () {
              isGrid = !isGrid;
              setState(() {});
            },
            child: Text(
              actionTitle,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text("https://fonts.google.com/icons"),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: buildTextField(
                controller: editingController,
                onChanged: onChanged,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text("找到 ${searchResults.length} 条数据"),
            ),
            Expanded(
              child: isGrid ? _buildGridView() : _buildListView(),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }

  TextField buildTextField({
    TextEditingController? controller,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(Icons.search),
        // labelText: "Search",
        hintText: "Search",
        // prefixIcon: Icon(Icons.search),
        suffixIcon: InkWell(
          onTap: () {
            controller?.clear();
            onChanged("");
          },
          child: Icon(
            Icons.cancel,
            color: Colors.grey,
          ),
        ),

        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(25.0))
        // ),
      ),
    );
  }

  _buildListView() {
    searchResults.sort((a, b) => a.compareTo(b));
    return CupertinoScrollbar(
        thumbVisibility: false,
        child: ListView.separated(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final item = searchResults[index];
            return ListTile(
              leading: Icon(kIConDic[item]),
              title: Text("$item"),
              // subtitle: Text(array[0]),
              onTap: () {
                DLog.d(item);
                // Clipboard.setData(ClipboardData(text: "$item"));
                editingController.text = item.split('.').last;
                onChanged(editingController.text);
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
        ));
  }

  _buildGridView() {
    searchResults.sort((a, b) => a.compareTo(b));
    return GridView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        final item = searchResults[index];
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            // color: index % 2 == 0 ? Colors.green : Colors.white,
            border: Border(
              top: BorderSide(color: index > 2 ? Colors.transparent : Color(0xffe4e4e4)),
              right: BorderSide(color: index % 3 == 2 ? Colors.transparent : Color(0xffe4e4e4)),
              bottom: BorderSide(color: Color(0xffe4e4e4)),
            ),
          ),
          child: GridTile(
            footer: Text(
              "$item",
            ),
            child: Icon(kIConDic[item]),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, //每行三列
        childAspectRatio: 1.0, //显示区域宽高相等
      ),
    );
  }

  onChanged(String value) {
    if (value.isEmpty) {
      searchResults = list;
    } else {
      searchResults = list.where((e) => e.contains(value)).toList();
      DLog.d(searchResults.length);
    }
    setState(() {});
  }
}
