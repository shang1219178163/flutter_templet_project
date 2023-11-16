//
//  DraggableScrollableSheetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/7/21 11:10 AM.
//  Copyright © 6/7/21 shang. All rights reserved.
//

// mac不支持


import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/build_context_ext.dart';
import 'package:flutter_templet_project/network/dio_upload_service.dart';
import 'package:flutter_templet_project/util/R.dart';

class DraggableScrollableSheetDemo extends StatefulWidget {

  final String? title;

  const DraggableScrollableSheetDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _DraggableScrollableSheetDemoState createState() => _DraggableScrollableSheetDemoState();
}

class _DraggableScrollableSheetDemoState extends State<DraggableScrollableSheetDemo> {




  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget", style: TextStyle(fontSize: 15),),
      ),
      body: buildBody(),
      // body: buildBody1(),
    );
  }

  Widget buildBody({double minChildSize = 0.3}) {
    final height = MediaQuery.of(context).size.height
        - MediaQuery.of(context).viewPadding.top
        - MediaQuery.of(context).viewPadding.bottom
        - kToolbarHeight;

    return SizedBox.expand(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: height * minChildSize,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    image: ExtendedNetworkImageProvider(R.image.urls[6],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: minChildSize,
            maxChildSize: 1,
            builder: (context, scrollController){

              return Container(
                color: Colors.green,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(title : Text('Item $index'),);
                  }
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildBody1() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        image: DecorationImage(
          image: ExtendedNetworkImageProvider(R.image.urls[6],
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox.expand(
        child: DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            );
          },
        ),
      ),
    );
  }

}
