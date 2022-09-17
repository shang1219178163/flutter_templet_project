import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extensions/ddlog.dart';

class SearchResultsListView extends StatefulWidget {

  Map<String, dynamic> map;
  String? hintText;
  TextEditingController? editingController;

  Widget Function(String key)? leadingBuilder;
  Widget Function(BuildContext context, int index, List searchResults)? itemBuilder;
  IndexedWidgetBuilder? separatorBuilder;

  void Function(String value)? searchCallback;
  void Function(dynamic obj) tap;

  SearchResultsListView({
    Key? key,
    this.map = const {},
    this.hintText = "搜索",
    this.editingController,
    this.leadingBuilder,
    this.itemBuilder,
    this.searchCallback,
    required this.tap,
    this.separatorBuilder,
  }) : super(key: key){
    editingController = editingController ?? TextEditingController();
  }

  @override
  _SearchResultsListViewState createState() => _SearchResultsListViewState();
}

class _SearchResultsListViewState extends State<SearchResultsListView> {

  var keys = [];
  var searchResults = [];

  @override
  void initState() {
    // TODO: implement initState
    keys = List.from(widget.map.keys);
    searchResults = List.from(widget.map.keys);

    widget.searchCallback = (value){
      widget.editingController?.text = value;
      _textfieldChanged(value);
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            child: _buildTextField(context),
            padding: EdgeInsets.all(10),
          ),
          Padding(
            child: Text("找到 ${searchResults.length} 条数据"),
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
    searchResults.sort((a, b) => "${a}".compareTo("${b}"));

    return CupertinoScrollbar(
      isAlwaysShown: false,
      child: ListView.separated(
        itemCount: searchResults.length,
        itemBuilder: (context, index) => widget.itemBuilder != null ? widget.itemBuilder!(context, index, searchResults) : _buildCell(context, index, searchResults),
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

  _buildCell(context, index, List searchResults) {
    final str = searchResults[index];
      return ListTile(
        leading: widget.leadingBuilder != null ? widget.leadingBuilder!(str) : Container(
          color: widget.map[str],
          width: 40,
          height: 40,
        ),
        title: Text("$str"),
        // subtitle: Text(subtitle),
        onTap: () {
          final value = "$str".split('.').last;
          widget.tap(widget.map[str]);
          if (widget.searchCallback == null) {
            widget.editingController?.text = value;
            _textfieldChanged(value);
            return;
          }
          widget.searchCallback?.call(value);
        },
      );
  }

  void _textfieldChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        searchResults = keys;
      } else {
        searchResults = keys.where((e) => "${e}".contains(value)).toList();
      }
      // ddlog("_changeValue:${value} searchResults:${searchResults}");
    });
  }
}