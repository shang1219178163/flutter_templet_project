

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/im_textfield_bar.dart';

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

  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: ['done',].map((e) =>
              TextButton(
                child: Text(e,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => debugPrint(e),)
          ).toList(),
        ),
        // bottomSheet: buildInputBar(),
        // bottomSheet: buildTextfieldBar(),
        bottomSheet: buildInputView(),
        body: Column(
            children: [
              Expanded(
                  child: ListView(
                    children: List.generate(20, (i) {
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

  buildTextfieldBar() {
    return IMTextfieldBar(
      onSubmitted: (String value) {
        debugPrint("onSubmitted:$value");
      },
    );
  }


  buildInputView() {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      padding: EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        bottom: max(12, bottom),
      ),
      child: TextField(
        controller: _inputController,
        minLines: 1,
        maxLines: 4,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.keyboard_alt_outlined),
          suffixIcon: IconButton(
            onPressed: () {
              if (_inputController.text.isNotEmpty) {
                _onSend();
              }
            },
            icon: Icon(_inputController.text.isNotEmpty
                ? Icons.send
                : Icons.keyboard_voice_outlined),
          ),
        ),
        onSubmitted: (_) => _onSend(),
      ),
    );
  }

  _onSend(){

  }
}