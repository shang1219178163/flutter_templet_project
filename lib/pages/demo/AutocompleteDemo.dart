import 'package:flutter/material.dart';

class AutocompleteDemo extends StatefulWidget {

  final String? title;

  AutocompleteDemo({ Key? key, this.title}) : super(key: key);

  
  @override
  _AutocompleteDemoState createState() => _AutocompleteDemoState();
}

class _AutocompleteDemoState extends State<AutocompleteDemo> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
        ),
        body: Column(
          children: [
            Autocomplete(
              optionsBuilder: buildOptions,
              onSelected: onSelected,
            ),
          ],
        )
    );
  }

  Future<Iterable<String>> buildOptions( TextEditingValue textEditingValue ) async {
    if (textEditingValue.text == '') {
      return const Iterable<String>.empty();
    }
    return searchByArgs(textEditingValue.text);
  }

  Future<Iterable<String>> searchByArgs(String args) async{
    // 模拟网络请求
    await Future.delayed(const Duration(milliseconds: 200));
    const List<String> data =  [
      'toly', 'toly49', 'toly42', 'toly56',
      'card', 'ls', 'alex', 'fan sha',
    ];
    return data.where((String name) => name.contains(args));
  }

  void onSelected(val) {
    print('val:$val');
  }
}