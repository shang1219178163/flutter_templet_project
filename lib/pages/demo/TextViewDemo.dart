//
//  TextViewDemo.dart
//  flutter_templet_project
//
//  Created by shang on 12/30/21 12:46 PM.
//  Copyright © 12/30/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextViewDemo extends StatefulWidget {

  final String? title;

  const TextViewDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _TextViewDemoState createState() => _TextViewDemoState();
}

class _TextViewDemoState extends State<TextViewDemo> {

  final messsage = "认识你自己，苏格拉底如是说。他老人家到底有没有说过这句话我们无从考证，也不甚重要，重要的是在两千多年后的当下，我们能够认识自己了吗？ 我们的大脑和意识是如何交互的？自由意志是否真实存在？人类为什么逃不过“复读机”的命运？那些迷惑行为要如何解释？如何在独处时面对自我？我们的焦虑、不安、迷茫和愤怒由何而来？ 人是如此复杂的生物，不管是古老的神学、哲学，还是现代的心理学等认知科学的发展，人类从来没有停下探索自己的脚步。 关注此文集，尝试着去重新认识自己，接纳自我，改善自我，拥抱真实的平静。";

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
    return Container(
      constraints: BoxConstraints(
        // minWidth: 100,
        // minHeight: 100,
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
}