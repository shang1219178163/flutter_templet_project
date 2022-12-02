import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/SectionHeader.dart';

class BoxConstraintsDemo extends StatefulWidget {

  final String? title;

  BoxConstraintsDemo({ Key? key, this.title}) : super(key: key);


  @override
  _BoxConstraintsDemoState createState() => _BoxConstraintsDemoState();
}

class _BoxConstraintsDemoState extends State<BoxConstraintsDemo> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: _buildBody()
    );
  }

  _buildBody() {
    return ListView(
      children: [
        Column(
          children: [
            SectionHeader.h4(title: 'ConstrainedBox',),
            ConstrainedBox(
              // BoxConstraints 构造
              constraints: BoxConstraints(
                // 最小高度 40
                minHeight: 40,
                // 最大高度 100
                maxHeight: 100,
                // 最小宽度 40
                minWidth: 40,
                // 最小宽度 300
                maxWidth: 300,
              ),
              child: _buildBox(),
            ),

            SectionHeader.h4(title: 'ConstrainedBox.expand（展开约束）',),
            ConstrainedBox(
              constraints: BoxConstraints.expand(width: 300, height: 100),
              child: _buildBox(),
            ),

            SectionHeader.h4(title: 'ConstrainedBox.loose（松约束）',),
            ConstrainedBox(
              constraints: BoxConstraints.loose(Size(300, 100)),
              child: _buildBox(),
            ),

            SectionHeader.h4(title: 'ConstrainedBox.tight（紧约束）',),
            ConstrainedBox(
              constraints: BoxConstraints.tight(Size(300, 100)),
              child: _buildBox(),
            ),

            SectionHeader.h4(title: 'BoxConstraints.tightForFinite（有限紧约束）',),
            ConstrainedBox(
              constraints: BoxConstraints.tightForFinite(height: 100),
              child: _buildBox(),
            ),

            SectionHeader.h4(title: '.loosen()',),
            ConstrainedBox(
              // BoxConstraints 构造,转换为松约束
              constraints: BoxConstraints(
                minHeight: 40,
                maxHeight: 100,
                minWidth: 40,
                maxWidth: 300,
              ).loosen(),
              child: _buildBox(),
            ),

            Divider(),

            Column(
              children: list.map((e) => SectionHeader.h5(title: e)).toList(),
            )
          ],
        )
      ],
    );
  }

  _buildBox({String text = 'ConstrainedBox 属性 ConstrainedBox'}) {
    return Container(
      color: Colors.lightBlue,
      child: Text(text),
    );
  }

  final list = [
    ".loosen()返回一个新的松约束；",
    " .flipped返回一个宽高调换的新约束；",
    ".normalize()返回一个 isNormalized 的新约束；",
    ".widthConstraints()返回一个仅有宽度约束的新约束；",
    ".heightConstraints()返回一个仅有高度约束的新约束；",
  ];

}