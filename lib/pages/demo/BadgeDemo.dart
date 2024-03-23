

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_section_header.dart';
import 'package:flutter_templet_project/basicWidget/n_badge.dart';
import 'package:flutter_templet_project/basicWidget/n_text.dart';

class BadgeDemo extends StatefulWidget {

  BadgeDemo({
    super.key, 
    this.title
  });

  final String? title;

  @override
  State<BadgeDemo> createState() => _BadgeDemoState();
}

class _BadgeDemoState extends State<BadgeDemo> {

  final _scrollController = ScrollController();

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
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            NSectionHeader(
              title: "Badge",
              child: Badge(
                // offset: Offset(4, -6),
                backgroundColor: Colors.red,
                label: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: NText(
                    "99+",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                ),
              ),
            ),
            NSectionHeader(
              title: "NBadge",
              child: NBadge(
                value: 111,
                top: -8,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}