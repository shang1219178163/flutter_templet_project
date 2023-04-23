

import 'package:flutter/material.dart';

class NExpansionTile extends StatefulWidget {

  NExpansionTile({
    Key? key,
    required this.children,
    this.title = "NExpansionTile",
    this.titleWidget,
    this.themeColor = Colors.blueAccent,

  }) : super(key: key);

  String title;

  Widget? titleWidget;

  Color themeColor;

  List<Widget> children;

  @override
  _NExpansionTileState createState() => _NExpansionTileState();
}

class _NExpansionTileState extends State<NExpansionTile> {
  final _isExpanded = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return ExpansionTile(
      // childrenPadding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      // iconColor: Colors.green,
      onExpansionChanged: (value) {
        _isExpanded.value = value;
      },
      title: widget.titleWidget ?? Text(
        widget.title,
        style: TextStyle(
          color: Color(0xff181818),
          // letterSpacing: -1,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: ValueListenableBuilder<bool>(
        valueListenable: _isExpanded,
        builder:  ( context, value,  child) {
          return _buildCustomBtn(isExpand: value, color: widget.themeColor);
        }
      ),
      children: widget.children,
    );
  }

  _buildCustomBtn({
    bool isExpand = true,
    Color color = Colors.blueAccent,
    VoidCallback? cb,
  }) {
    final title = isExpand ? "收起" : "展开";
    final icon = isExpand ? Icon(Icons.expand_less, size: 24, color: color,) :
    Icon(Icons.expand_more, size: 24, color: color,);

    return Container(
      width: 66,
      height: 30,
      // color: Colors.red,
      padding: EdgeInsets.only(left: 8, right: 4, top: 2, bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Text(title,
            style: TextStyle(
                color: color
            ),
          ),
          SizedBox(width: 0,),
          icon,
        ],
      ),
    );
  }
}