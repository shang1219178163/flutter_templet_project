

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/pages/neomorphism/neomorphism_cards_screen.dart';
import 'package:flutter_templet_project/pages/neomorphism/neomorphism_login_screen.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class NeomorphismHomePage extends StatefulWidget {

  NeomorphismHomePage({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _NeomorphismHomePageState createState() => _NeomorphismHomePageState();
}

class _NeomorphismHomePageState extends State<NeomorphismHomePage> {

  final scrollController = ScrollController();

  final tuples = [
    Tuple2(NeomorphismLoginScreen(), "LoginScreen"),
    Tuple2(NeomorphismCardsScreen(), "CardsScreen"),

  ];

  @override
  Widget build(BuildContext context) {
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
      body: buildBoyd(),
    );
  }

  buildBoyd() {
    return Scrollbar(
      controller: scrollController,
      child: ListView.separated(
        controller: scrollController,
        itemCount: tuples.length,
        itemBuilder: (_, index){

          final e = tuples[index];
          return InkWell(
            onTap: (){
              Get.to(() => e.item1);
            },
            child: ListTile(
              title: Text(e.item2),
              trailing: Icon(Icons.arrow_forward_ios),
            )
          );
        },
        separatorBuilder: (_, index){
          return Divider(height: 1,);
        },
      ),
    );
  }



}