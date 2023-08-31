

import 'package:flutter/material.dart';

class ScaffoldBottomSheet extends StatefulWidget {

  ScaffoldBottomSheet({
    Key? key, 
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _ScaffoldBottomSheetState createState() => _ScaffoldBottomSheetState();
}

class _ScaffoldBottomSheetState extends State<ScaffoldBottomSheet> {


  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
      ),
      bottomSheet: buildInputBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: List.generate(20, (i){
                return ListTile(title: Text("item_$i"),);
              }).toList(),
            )
          )
        ]
      )
    );
  }

  Widget buildInputBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: '请输入',
        ),
      ),
    );
  }
}