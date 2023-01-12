//
//  LayoutBuilderDemo.dart
//  flutter_templet_project
//
//  Created by shang on 10/14/21 6:47 PM.
//  Copyright © 10/14/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/uti/R.dart';

class LayoutBuilderDemo extends StatefulWidget {

  final String? title;

  LayoutBuilderDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _LayoutBuilderDemoState createState() => _LayoutBuilderDemoState();
}

class _LayoutBuilderDemoState extends State<LayoutBuilderDemo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: Column(
        children: [
          buildBody(),
          buildBody(hasConstraints: true),
        ],
      ),
    );
  }


  Widget buildBody({bool hasConstraints = false}) {
    if (!hasConstraints) {
      return Center(
        child: Container(
          child: Column(
            children: <Widget>[
              _buildImage(),
              Text("图片"),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Container(
            child: Column(
              children: <Widget>[
                _buildImage(width: constraints.maxWidth),
                Text("图片"),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildImage({double? width}) {
    return FadeInImage(
      // placeholder: AssetImage("images/img_placeholder.png"),
      placeholder: R.image.placeholder(),
      image: NetworkImage(R.image.imgUrls[0]),
      fit: BoxFit.fill,
      width: width,
      height: 100,
    );
    return Image(
      image: NetworkImage(R.image.imgUrls[0]),
      fit: BoxFit.fill,
      width: width,
      height: 100,
      loadingBuilder: _buildLoadingBuilder,
    );
  }

   Widget _buildLoadingBuilder(BuildContext context, Widget child, ImageChunkEvent? loadingProgress,) {
     print("loadingProgress:${loadingProgress}");
     return Image.asset("images/img_placeholder.png", height: 100,);
     if (loadingProgress == null) {
       return SizedBox();
     }
     return Center(
       child: CircularProgressIndicator(
         value: loadingProgress.expectedTotalBytes != null
             ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
             : null,
       ),
     );
   }
}