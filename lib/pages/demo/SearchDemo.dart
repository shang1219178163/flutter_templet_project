

import 'package:flutter/material.dart';

class SearchDemo extends StatefulWidget {

  SearchDemo({
    Key? key,
    this.title
  }) : super(key: key);

  final String? title;

  @override
  _SearchDemoState createState() => _SearchDemoState();
}

class _SearchDemoState extends State<SearchDemo> {


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
      body: buildBody()
    );
  }

  buildBody() {
    return Column(
      children: [
        buildSearchAnchor(),
      ],
    );
  }

  Widget buildSearchAnchor() {
    return SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            // controller.openView();
          },
          leading: const Icon(Icons.search),
          trailing: <Widget>[
            Tooltip(
              message: 'Change brightness mode',
              child: IconButton(
                isSelected: false,
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.wb_sunny_outlined),
                selectedIcon: const Icon(Icons.brightness_2_outlined),
              ),
            )
          ],
        );
      },
      suggestionsBuilder: (context, controller) {
        return List<ListTile>.generate(5, (int index) {
          final item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              controller.closeView(item);
              setState(() {});
            },
          );
        });
      }
    );
  }
}