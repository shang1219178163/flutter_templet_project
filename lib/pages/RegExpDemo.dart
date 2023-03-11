import 'package:flutter/material.dart';

class RegExpDemo extends StatefulWidget {

  RegExpDemo({ Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RegExpDemoState createState() => _RegExpDemoState();
}

class _RegExpDemoState extends State<RegExpDemo> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? "$widget"),
          actions: ['done',].map((e) => TextButton(
            child: Text(e,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onPressed,)
          ).toList(),
        ),
        body: _buildBody(),
    );
  }

  _buildBody() {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return CustomScrollView(
      slivers: [
        Text(arguments.toString()),

      ].map((e) => SliverToBoxAdapter(child: e,)).toList(),
    );
  }

  onPressed(){
    testRegExpMatch();
  }

  testRegExpMatch(){
    final str = "streetAddressLine2";
    final reg = RegExp('[A-Z]');
    final matchs = reg.allMatches(str);
    for (final Match m in matchs) {
      String match = m[0]!;
      print("m: ${m.description}");
    }
    final seperators = matchs.map((e) => e[0] ?? "").toList();
    print("seperators: ${seperators}");
  }

}


extension MatchExt on Match{

  String get description {
    return """
   
      start ${this.start}
      end ${this.end}
      input ${this.input}
      pattern ${this.pattern}
      groupCount ${this.groupCount}
      """;
  }
}