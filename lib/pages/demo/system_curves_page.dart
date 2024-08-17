import 'package:flutter/material.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';

class SystemCurvesPage extends StatefulWidget {
  SystemCurvesPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SystemCurvesPageState createState() => _SystemCurvesPageState();
}

class _SystemCurvesPageState extends State<SystemCurvesPage> {
  final _scollController = ScrollController();

  final items = <String>[
    "curve_bounce_in.gif",
    "curve_bounce_in_out.gif",
    "curve_bounce_out.gif",
    "curve_decelerate.gif",
    "curve_ease.gif",
    "curve_ease_in.gif",
    "curve_ease_in_back.gif",
    "curve_ease_in_circ.gif",
    "curve_ease_in_cubic.gif",
    "curve_ease_in_expo.gif",
    "curve_ease_in_out.gif",
    "curve_ease_in_out_back.gif",
    "curve_ease_in_out_circ.gif",
    "curve_ease_in_out_cubic.gif",
    "curve_ease_in_out_expo.gif",
    "curve_ease_in_out_quad.gif",
    "curve_ease_in_out_quart.gif",
    "curve_ease_in_out_quint.gif",
    "curve_ease_in_out_sine.gif",
    "curve_ease_in_quad.gif",
    "curve_ease_in_quart.gif",
    "curve_ease_in_quint.gif",
    "curve_ease_in_sine.gif",
    "curve_ease_out.gif",
    "curve_ease_out_back.gif",
    "curve_ease_out_circ.gif",
    "curve_ease_out_cubic.gif",
    "curve_ease_out_expo.gif",
    "curve_ease_out_quad.gif",
    "curve_ease_out_quart.gif",
    "curve_ease_out_quint.gif",
    "curve_ease_out_sine.gif",
    "curve_elastic_in.gif",
    "curve_elastic_in_out.gif",
    "curve_elastic_out.gif",
    "curve_fast_out_slow_in.gif",
    "curve_flipped.gif",
    "curve_interval.gif",
    "curve_linear.gif",
    "curve_sawtooth.gif",
    "curve_slow_middle.gif",
    "curve_threshold.gif",
  ];

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
      // body: buildBody(),
      body: buildBody(),
    );
  }

  buildBody() {
    return Scrollbar(
      controller: _scollController,
      child: SingleChildScrollView(
        controller: _scollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              final itemWidth = 470.0;

              // final direction = constraints.maxWidth > 480*2 ? Axis.horizontal : Axis.vertical;

              return Wrap(
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: items.map((e) {
                  return Container(
                    width: itemWidth,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      // border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.asset(
                            e.toPath("assets/images/curve"),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  // buildBody() {
  //   return Scrollbar(
  //     controller: _scollController,
  //     child: SingleChildScrollView(
  //       controller: _scollController,
  //       child: Column(
  //         children: items.map((e) {
  //
  //           return Container(
  //             decoration: BoxDecoration(
  //               color: Colors.transparent,
  //               // border: Border.all(color: Colors.blue),
  //               borderRadius: BorderRadius.all(Radius.circular(0)),
  //             ),
  //             child: Row(
  //               children: [
  //                 Image.asset(
  //                   e.toPath("assets/images/curve"),
  //                   // height: 100.0,
  //                   // width: 100.0,
  //                 ),
  //               ],
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //     ),
  //   );
  // }
  //
  // buildBodyNew() {
  //   return GridView.count(
  //     padding: EdgeInsets.all(15.0),
  //     crossAxisCount: 2,
  //     scrollDirection: Axis.vertical,
  //     crossAxisSpacing: 8,
  //     mainAxisSpacing: 8,
  //     childAspectRatio: 4 / 3,
  //     children: items.map((e) {
  //
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: Colors.transparent,
  //           // border: Border.all(color: Colors.blue),
  //           borderRadius: BorderRadius.all(Radius.circular(0)),
  //         ),
  //         child: Row(
  //           children: [
  //             Image.asset(
  //               e.toPath("assets/images/curve"),
  //               // height: 100.0,
  //               // width: 100.0,
  //             ),
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
}
