import 'package:flutter/material.dart';

class ListViewDemo extends StatefulWidget {

  final String? title;

  ListViewDemo({ Key? key, this.title}) : super(key: key);


  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: _buildSection(),
    );
  }

  _buildSection() {
    return ListView(
      controller: _scrollController,
      children: List.generate(3, (index) => Column(
        children: [
          ListTile(
            leading: Text('Index: $index'),
          ),
          Divider(),
        ],
      )
      ),
      itemExtent: 75,
    );
  }

}