import 'package:flutter/material.dart';

class RegExpDemo extends StatefulWidget {
  const RegExpDemo({Key? key, this.title}) : super(key: key);

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
        actions: [
          'done',
        ]
            .map((e) => TextButton(
                  onPressed: onPressed,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white),
                  ),
                ))
            .toList(),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return CustomScrollView(
      slivers: [
        Text(arguments.toString()),
      ]
          .map((e) => SliverToBoxAdapter(
                child: e,
              ))
          .toList(),
    );
  }

  onPressed() {
    testRegExpMatch();
  }

  testRegExpMatch() {
    const str = "streetAddressLine2";
    final reg = RegExp('[A-Z]');
    final matchs = reg.allMatches(str);
    for (final Match m in matchs) {
      var match = m[0]!;
      debugPrint("m: ${m.description}");
    }
    final seperators = matchs.map((e) => e[0] ?? "").toList();
    debugPrint("seperators: $seperators");

    debugPrint("allMatchesOfString: ${reg.allMatchesOfString(str)}");
  }
}

extension MatchExt on Match {
  String get description {
    return """
      start $start
      end $end
      input $input
      pattern $pattern
      groupCount $groupCount
      """;
  }
}
