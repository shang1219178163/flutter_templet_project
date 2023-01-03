import 'package:flutter/material.dart';

class IntrinsicHeightDemo extends StatefulWidget {

  IntrinsicHeightDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _IntrinsicHeightDemoState createState() => _IntrinsicHeightDemoState();
}

class _IntrinsicHeightDemoState extends State<IntrinsicHeightDemo> {

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  flag = !flag;
                });
              },
              child: Icon(Icons.change_circle_outlined,
                color: Colors.white,
              )
            ),
          ],
        ),
        body: flag ? _buildBody() : _buildRow()
    );
  }

  _buildBody() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Container(
            width: 50,
            color: Colors.red,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 28,
            height: 50,
            color: Colors.red,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 50,
            height: 150,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  _buildRow() {
    return IntrinsicHeight(
      child: Container(
        child: Row(
          children: [
            Container(
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://tenfei02.cfp.cn/creative/vcg/800/new/VCG21409037867.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text('title', style: TextStyle(fontWeight: FontWeight.w600),),
                  Text('subtitle', style: TextStyle(fontWeight: FontWeight.w400),),
                  Text('description', style: TextStyle(fontWeight: FontWeight.w400),),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }

}