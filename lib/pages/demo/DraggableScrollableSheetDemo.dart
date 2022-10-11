//
//  DraggableScrollableSheetDemo.dart
//  flutter_templet_project
//
//  Created by shang on 6/7/21 11:10 AM.
//  Copyright © 6/7/21 shang. All rights reserved.
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DraggableScrollableSheetDemo extends StatefulWidget {

  final String? title;

  DraggableScrollableSheetDemo({ Key? key, this.title}) : super(key: key);

  
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
        body: SizedBox.expand(
          // child: buildDraggableScrollableSheet(context),
          child: buildBody(context),

        )
    );
  }

    Widget buildBody(BuildContext context) {
    return Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Color.fromARGB(100, 100, 100, 100),
              child: Image.network(
                'https://www.kindacode.com/wp-content/uploads/2020/12/dog-png.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.8,
            minChildSize: 0.3,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController){
              return Container(
                color: Colors.white,
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(title : Text('Item $index'),);
                    }),
              );
            },
          )
        ],
      );
    }

    Widget buildDraggableScrollableSheet(BuildContext context) {
    return DraggableScrollableSheet(
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
    );
  }
}
