import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_autocomplete_search.dart';
import 'package:flutter_templet_project/routes/AppRouter.dart';
import 'package:get/get.dart';

class RouteNameSearchPage extends StatefulWidget {
  RouteNameSearchPage({
    Key? key,
    this.title,
    this.hideAppBar = false,
  }) : super(key: key);

  final String? title;

  final bool hideAppBar;

  @override
  _RouteNameSearchPageState createState() => _RouteNameSearchPageState();
}

class _RouteNameSearchPageState extends State<RouteNameSearchPage> {
  var _useFieldViewBuilder = false;

  @override
  void initState() {
    super.initState();
    AppRouter.lazyLoadRoutes().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hideAppBar ? null : AppBar(title: Text(widget.title ?? "$widget")),
      body: CustomScrollView(
        slivers: [
          buildExpandMenu(),
          NAutocompleteSearch<String>(
            fieldViewBuilder: _useFieldViewBuilder ? buildFieldView : null,
            displayStringForOption: (e) => e,
            optionsBuilder: (v) {
              final query = v.text.trim().toLowerCase();
              if (query.isEmpty) {
                return const <String>[];
              }
              return Get.routeTree.routes
                  .where((e) {
                    final name = e.name.toLowerCase();
                    final title = (e.title ?? e.name.split('/').last).toLowerCase();
                    return name.contains(query) || title.contains(query);
                  })
                  .map((e) => e.name)
                  .toList();
            },
            onSelected: (e) => Get.toNamed(e),
          ),
        ].map((e) => SliverToBoxAdapter(child: e)).toList(),
      ),
    );
  }

  Widget buildExpandMenu() {
    final colorScheme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 10),
        collapsedTextColor: colorScheme.onSurface,
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.primary,
        collapsedIconColor: colorScheme.primary,
        leading: Icon(Icons.ac_unit, color: colorScheme.primary),
        title: Text('配置', style: TextStyle(color: colorScheme.onSurface)),
        initiallyExpanded: false,
        children: [
          SwitchListTile(
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.black.withValues(alpha: 0.1),
            title: Text('fieldViewBuilder', style: TextStyle(color: colorScheme.onSurface)),
            value: _useFieldViewBuilder,
            onChanged: (v) {
              _useFieldViewBuilder = v;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget buildFieldView(context, controller, focusNode, onFieldSubmitted) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: (v) => onFieldSubmitted(),
      decoration: InputDecoration(
        hintText: '请输入关键词',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}
