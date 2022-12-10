import 'package:flutter/cupertino.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: ListView(
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
              ),

              Divider(),
              SectionHeader.h4(title: 'buildTextView',),
              buildTextView()
            ],
          )
        ],
      ),
    );
  }

  buildTextView() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 300,
        maxHeight: 120,
      ),
      color: Colors.black12,
      child: CupertinoScrollbar(
          child: SingleChildScrollView(
              child: Text(messsage,)
          )
      ),
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

  final messsage = "认识你自己，苏格拉底如是说。他老人家到底有没有说过这句话我们无从考证，也不甚重要，重要的是在两千多年后的当下，我们能够认识自己了吗？ 我们的大脑和意识是如何交互的？自由意志是否真实存在？人类为什么逃不过“复读机”的命运？那些迷惑行为要如何解释？如何在独处时面对自我？我们的焦虑、不安、迷茫和愤怒由何而来？ 人是如此复杂的生物，不管是古老的神学、哲学，还是现代的心理学等认知科学的发展，人类从来没有停下探索自己的脚步。 关注此文集，尝试着去重新认识自己，接纳自我，改善自我，拥抱真实的平静。";

}