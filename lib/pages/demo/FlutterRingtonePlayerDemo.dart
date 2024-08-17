//
//  FlutterRingtonePlayerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2024/1/17 17:18.
//  Copyright © 2024/1/17 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class FlutterRingtonePlayerDemo extends StatefulWidget {
  FlutterRingtonePlayerDemo({super.key, this.title});

  final String? title;

  @override
  State<FlutterRingtonePlayerDemo> createState() =>
      _FlutterRingtonePlayerDemoState();
}

class _FlutterRingtonePlayerDemoState extends State<FlutterRingtonePlayerDemo> {
  final _scrollController = ScrollController();

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
            Text("$widget"),
          ],
        ),
      ),
    );
  }

  // Widget buildRingtonePlayerBox() {
  //   return Column(
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: ElevatedButton(
  //           child: const Text('playAlarm'),
  //           onPressed: () {
  //             FlutterRingtonePlayer().playAlarm();
  //           },
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: ElevatedButton(
  //           child: const Text('playAlarm asAlarm: false'),
  //           onPressed: () {
  //             FlutterRingtonePlayer().playAlarm(asAlarm: false);
  //           },
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: ElevatedButton(
  //           child: const Text('playNotification'),
  //           onPressed: () {
  //             FlutterRingtonePlayer().playNotification();
  //           },
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: ElevatedButton(
  //           child: const Text('playRingtone'),
  //           onPressed: () {
  //             FlutterRingtonePlayer().playRingtone();
  //           },
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: ElevatedButton(
  //           child: const Text('Play from asset (iphone.mp3)'),
  //           onPressed: () {
  //             FlutterRingtonePlayer()
  //                 .play(fromAsset: "assets/iphone.mp3");
  //           },
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: ElevatedButton(
  //           child: const Text('Play from asset (android.wav)'),
  //           onPressed: () {
  //             FlutterRingtonePlayer()
  //                 .play(fromAsset: "assets/android.wav");
  //           },
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: ElevatedButton(
  //           child: const Text('play'),
  //           onPressed: () {
  //             FlutterRingtonePlayer().play(
  //               android: AndroidSounds.notification,
  //               ios: IosSounds.glass,
  //               looping: true,
  //               volume: 1.0,
  //             );
  //           },
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8),
  //         child: ElevatedButton(
  //           child: const Text('stop'),
  //           onPressed: () {
  //             FlutterRingtonePlayer().stop();
  //           },
  //         ),
  //       ),
  //
  //       Wrap(
  //         spacing: 8,
  //         runSpacing: 8,
  //         children: iosSoundList().map((e) {
  //
  //           return ElevatedButton(
  //             child:  Text("IosSound_${e.value}"),
  //             onPressed: () {
  //               // FlutterRingtonePlayer().stop();
  //               FlutterRingtonePlayer().play(
  //                 android: AndroidSounds.notification,
  //                 ios: e,
  //                 looping: true,
  //                 volume: 1.0,
  //               );
  //             },
  //           );
  //         }).toList(),
  //
  //       )
  //     ],
  //   );
  // }
  //
  // List<IosSound> iosSoundList() {
  //   return <IosSound>[
  //     IosSound(1000),
  //     IosSound(1001),
  //     IosSound(1002),
  //     IosSound(1003),
  //     IosSound(1004),
  //     IosSound(1005),
  //     IosSound(1006),
  //     IosSound(1007),
  //     IosSound(1008),
  //     IosSound(1009),
  //     IosSound(1010),
  //     IosSound(1013),
  //     IosSound(1014),
  //   ];
  // }
}
