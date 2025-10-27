import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_network_image.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/util/AppRes.dart';

class SearchDemo extends StatefulWidget {
  SearchDemo({Key? key, this.title}) : super(key: key);

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
          actions: [
            'done',
          ]
              .map((e) => TextButton(
                    child: Text(
                      e,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => debugPrint(e),
                  ))
              .toList(),
        ),
        body: buildBody());
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
      viewConstraints: BoxConstraints.loose(Size.fromHeight(200)),
      builder: (context, controller) {
        final isSelected = ValueNotifier(true);
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
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
              child: ValueListenableBuilder(
                valueListenable: isSelected,
                builder: (context, value, child) {
                  DLog.d("isSelected: ${isSelected.value}");

                  final icon = value ? const Icon(Icons.brightness_2_outlined) : const Icon(Icons.wb_sunny_outlined);
                  return IconButton(
                    onPressed: () {
                      isSelected.value = !isSelected.value;
                    },
                    icon: icon,
                  );
                },
              ),
            )
          ],
        );
      },
      suggestionsBuilder: (context, controller) {
        return List<Widget>.generate(
          5,
          (int i) {
            final item = 'item $i';
            return buildItem(
                url: AppRes.image.urls[i],
                title: item,
                onTap: () {
                  controller.closeView(item);
                  setState(() {});
                });
          },
        );
      },
      viewBuilder: (suggestions) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text("${suggestions.length}"),
            ),
            ...suggestions.toList(),
            Expanded(child: SizedBox()),
          ],
        );
      },
    );
  }

  Widget buildItem({required String url, required String title, VoidCallback? onTap}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: NNetworkImage(
          url: url,
          width: 45,
        ),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
