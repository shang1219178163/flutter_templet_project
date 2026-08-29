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
  var _showRouteList = false;
  final _searchController = TextEditingController();

  List<GetPage> _sortedRoutes = [];

  @override
  void initState() {
    super.initState();
    refreshRoutes();
    AppRouter.lazyLoadRoutes().then((_) {
      if (mounted) {
        refreshRoutes();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void refreshRoutes() {
    _sortedRoutes = List<GetPage>.of(Get.routeTree.routes);
    _sortedRoutes.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hideAppBar ? null : AppBar(title: Text(widget.title ?? "$widget")),
      body: Column(
        children: [
          buildExpandMenu(),
          NAutocompleteSearch<String>(
            controller: _searchController,
            fieldViewBuilder: _useFieldViewBuilder ? buildFieldView : null,
            displayStringForOption: (e) => e,
            optionsBuilder: (v) {
              final query = v.text.trim().toLowerCase();
              if (query.isEmpty) {
                return const <String>[];
              }
              return _sortedRoutes
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
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _searchController,
            child: buildRouteList(),
            builder: (context, value, child) {
              final showList = _showRouteList && value.text.isEmpty;
              if (!showList) {
                return const SizedBox.shrink();
              }
              return Expanded(child: child!);
            },
          ),
        ],
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
            dense: true,
            title: Text('fieldViewBuilder', style: TextStyle(color: colorScheme.onSurface)),
            value: _useFieldViewBuilder,
            onChanged: (v) {
              _useFieldViewBuilder = v;
              setState(() {});
            },
          ),
          SwitchListTile(
            dense: true,
            title: Text('展示路由列表', style: TextStyle(color: colorScheme.onSurface)),
            value: _showRouteList,
            onChanged: (v) {
              _showRouteList = v;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget buildRouteList() {
    final routes = _sortedRoutes;
    return ListView.separated(
      itemCount: routes.length,
      separatorBuilder: (context, index) => Divider(indent: 16),
      itemBuilder: (context, index) {
        final e = routes[index];
        final title = e.title ?? e.name.split('/').last;
        return ListTile(
          dense: true,
          title: Text(e.name),
          subtitle: title == e.name ? null : Text(title),
          onTap: () => Get.toNamed(e.name),
        );
      },
    );
  }

  Widget buildFieldView(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
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
