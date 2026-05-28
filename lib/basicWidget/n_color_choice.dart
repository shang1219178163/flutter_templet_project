import 'package:flutter/material.dart';

/// 颜色选择
class NColorChoice extends StatefulWidget {
  const NColorChoice({
    super.key,
    this.colors = const [
      Colors.black,
      Colors.pink,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ],
    required this.selectedColorVN,
    this.onChanged,
  });

  final List<Color> colors;
  final ValueNotifier<Color> selectedColorVN;

  final ValueChanged<Color>? onChanged;

  @override
  State<NColorChoice> createState() => _NColorChoiceState();
}

class _NColorChoiceState extends State<NColorChoice> {
  @override
  void didUpdateWidget(covariant NColorChoice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.colors != widget.colors) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: widget.selectedColorVN.value,
          collapsedIconColor: widget.selectedColorVN.value,
        ),
      ),
      child: ExpansionTile(
        leading: Icon(
          Icons.color_lens,
          color: widget.selectedColorVN.value,
        ),
        title: Text(
          '颜色主题',
          style: TextStyle(color: widget.selectedColorVN.value),
        ),
        initiallyExpanded: false,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.colors.map((e) {
                return InkWell(
                  onTap: () {
                    widget.selectedColorVN.value = e;
                    setState(() {});
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    color: e,
                    child: widget.selectedColorVN.value == e
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
