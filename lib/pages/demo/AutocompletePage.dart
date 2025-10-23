import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_autocomplete_search.dart';
import 'package:flutter_templet_project/extension/map_ext.dart';
import 'package:flutter_templet_project/model/ProjectPubDepsModel.dart';
import 'package:flutter_templet_project/extension/dlog.dart';
import 'package:flutter_templet_project/pages/demo/data_type_demo.dart';

class AutocompletePage extends StatefulWidget {
  const AutocompletePage({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AutocompletePage> createState() => _AutocompletePageState();
}

class _AutocompletePageState extends State<AutocompletePage> {
  final scrollController = ScrollController();

  var rootModel = ProjectPubDepsModel();

  List<ProjectPackageModel> get packages => rootModel.packages ?? [];

  final packageVN = ValueNotifier<ProjectPackageModel?>(null);

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    updateUI();
  }

  Future<ProjectPubDepsModel> loadModel() async {
    final jsonStr = await rootBundle.loadString('assets/data/pub_deps.json');
    final Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    return ProjectPubDepsModel.fromJson(jsonMap);
  }

  void updateUI() {
    loadModel().then((v) {
      rootModel = v;
      DLog.d(packages.map((e) => e.name).toList());
      setState(() {});
    }).onError((e, stack) {
      DLog.d([e, stack]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$widget"),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(onPressed: updateUI, child: Text("loadModel")),
            Text("count: ${packages.map((e) => e.name).length.toString()}"),
            Container(
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.blue),
              // ),
              child: NAutocompleteSearch(
                controller: controller,
                items: packages,
                displayStringForOption: (option) {
                  return option.name ?? "";
                },
                optionsBuilder: (TextEditingValue textEditingValue) {
                  final query = textEditingValue.text;

                  final result =
                      packages.where((e) => (e.name ?? "").toLowerCase().contains(query.toLowerCase())).toList();
                  return result;
                },
                onSelected: (e) {
                  DLog.d(e);
                  packageVN.value = e;
                },
                onChanged: (v) {
                  DLog.d(v);
                },
              ),
            ),
            AnimatedBuilder(
              animation: Listenable.merge([
                controller,
                packageVN,
              ]),
              builder: (context, child) {
                final e = packageVN.value;
                if (e == null || controller.text.isEmpty) {
                  return SizedBox();
                }

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(e.toJson().convertByIndent()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
