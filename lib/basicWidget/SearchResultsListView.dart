import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

class SearchResultsListView extends StatefulWidget {

  Map<String, dynamic> map;
  List keys;
  List searchResults;
  String? hintText;
  TextEditingController? editingController;

  Widget Function(BuildContext context, int index, List searchResults)? itemBuilder;
  // IndexedWidgetBuilder? itemBuilder;
  IndexedWidgetBuilder? separatorBuilder;

  void Function(String value)? tapCallback;

  SearchResultsListView({
    Key? key,
    this.map = const {},
    this.keys = const [],
    this.searchResults = const [],
    this.hintText = "搜索",
    this.editingController,
    this.itemBuilder,
    this.tapCallback,
    this.separatorBuilder,
  }) : super(key: key){
    editingController = editingController ?? TextEditingController();
  }

  @override
  _SearchResultsListViewState createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {
  // TextEditingController editingController = widget.editingController ??
  //     TextEditingController();

  @override
  Widget build(BuildContext context) {
    widget.tapCallback = (value){
      widget.editingController?.text = value;
      _textfieldChanged(value);
    };

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            child: _buildTextField(context),
            padding: EdgeInsets.all(10),
          ),
          Padding(
            child: Text("找到 ${widget.searchResults.length} 条数据"),
            padding: EdgeInsets.only(left: 10, right: 10),
          ),
          Expanded(
            child: _buildListView(context),
            flex: 1,
          )
        ],
      ),
    );
  }

  TextField _buildTextField(BuildContext context) {
    return TextField(
      onChanged: _textfieldChanged,
      //   onChanged: (value) {
      //   ddlog(value);
      // },
      controller: widget.editingController,
      decoration: InputDecoration(
        icon: Icon(Icons.search),
        // labelText: "Search",
        hintText: widget.hintText,
        // prefixIcon: Icon(Icons.search),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(25.0))
        // ),
      ),
    );
  }

  _buildListView(BuildContext context) {
    widget.searchResults.sort((a, b) => "${a}".compareTo("${b}"));

    return CupertinoScrollbar(
      isAlwaysShown: false,
      child: ListView.separated(
        itemCount: widget.searchResults.length,
        itemBuilder:  (context, index) => widget.itemBuilder != null ? widget.itemBuilder!(context, index, widget.searchResults) : _buildCell(context, index),
        separatorBuilder: widget.separatorBuilder ?? (context, index) {
          return Divider(
            height: .5,
            indent: 15,
            endIndent: 15,
            color: Color(0xFFDDDDDD),
          );
        },
      ),
    );
  }

  _buildCell(context, index) {
      final str = widget.searchResults[index];
      return ListTile(
        leading: Container(
          color: widget.map[str],
          width: 40,
          height: 40,
        ),
        title: Text("$str"),
        // subtitle: Text(subtitle),
        onTap: () {
          final value = "$str".split('.').last;
          widget.tapCallback?.call(value);
        },
      );
  }

  void _textfieldChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        widget.searchResults = widget.keys;
      } else {
        widget.searchResults = widget.keys.where((e) => "${e}".contains(value)).toList();
      }
      // ddlog("_changeValue:${value} searchResults:${widget.searchResults}");
    });
  }
}