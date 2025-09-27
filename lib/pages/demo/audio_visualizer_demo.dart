//
//  AudioVisualizerDemo.dart
//  flutter_templet_project
//
//  Created by shang on 2025/3/6 14:14.
//  Copyright © 2025/3/6 shang. All rights reserved.
//

import 'dart:async';
import 'dart:io';

import 'package:audio_visualizer/audio_visualizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// 音频动画效果
class AudioVisualizerDemo extends StatefulWidget {
  const AudioVisualizerDemo({
    super.key,
    this.arguments,
  });

  final Map<String, dynamic>? arguments;

  @override
  State<AudioVisualizerDemo> createState() => _AudioVisualizerDemoState();
}

class _AudioVisualizerDemoState extends State<AudioVisualizerDemo> {
  bool get hideApp => "$widget".toLowerCase().endsWith(Get.currentRoute.toLowerCase());

  final scrollController = ScrollController();

  final pcmVisualizer = PCMVisualizer();
  final audioPlayer = VisualizerPlayer();
  final record = AudioRecorder();
  bool isRecording = false;
  StreamSubscription? _micData;

  AudioVisualizer get source {
    return isRecording ? pcmVisualizer : audioPlayer;
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    pcmVisualizer.reset();
    await audioPlayer.initialize();
  }

  @override
  void dispose() {
    _micData?.cancel();
    pcmVisualizer.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AudioVisualizerDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hideApp
          ? null
          : AppBar(
              title: Text("音频可视化"),
            ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRecording ? Colors.deepOrangeAccent : null,
                    ),
                    onPressed: onMic,
                    child: const Text('Mic'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.setDataSource(
                        "https://files.testfile.org/AUDIO/C/M4A/sample1.m4a",
                      );
                    },
                    child: const Text('HTTP'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final path = await downloadFile(
                        "https://files.testfile.org/anime.mp3",
                        "anime.mp3",
                      );
                      audioPlayer.setDataSource("file://$path");
                    },
                    child: const Text('File'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        // audioPlayer.setDataSource(
                        //   "asset://assets/sample.mp3",
                        // );
                        audioPlayer.setDataSource(
                          "asset://assets/avicii-waiting for love.mp3",
                        );
                      } catch (e) {
                        debugPrint("$this $e");
                      }
                    },
                    child: const Text('Asset'),
                  ),
                ]
                    .map((e) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: e,
                        ))
                    .toList(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.play();
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.pause();
                    },
                    child: const Icon(Icons.pause),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      audioPlayer.stop();
                    },
                    child: const Icon(Icons.stop),
                  ),
                ]
                    .map((e) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: e,
                        ))
                    .toList(),
              ),
              ListenableBuilder(
                listenable: audioPlayer,
                builder: (context, child) {
                  final value = audioPlayer.value;
                  final positionStr = "${value.position}".split(".").firstOrNull ?? "";
                  final durationStr = "${value.duration}".split(".").firstOrNull ?? "";

                  return Text(
                    "${value.status} ($positionStr/$durationStr)",
                    textAlign: TextAlign.center,
                  );
                },
              ),
              ListenableBuilder(
                listenable: source,
                builder: (context, child) {
                  return GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    shrinkWrap: true,
                    children: [
                      const Center(child: Text("Wave")),
                      const Center(child: Text("Frequency")),
                      BarVisualizer(
                        input: source.value.waveform,
                        color: Colors.greenAccent,
                        backgroundColor: Colors.transparent,
                        gap: 2,
                      ),
                      BarVisualizer(
                        input: getMagnitudes(source.value.fft),
                        color: Colors.greenAccent,
                        backgroundColor: Colors.transparent,
                        gap: 2,
                      ),
                      CircularBarVisualizer(
                        color: Colors.greenAccent,
                        input: source.value.waveform,
                        backgroundColor: Colors.transparent,
                        gap: 2,
                      ),

                      // CircularBarVisualizer(
                      //   color: Colors.yellowAccent,
                      //   input: getMagnitudes(source.value.fft).take(128).toList(),
                      //   backgroundColor: Colors.transparent,
                      //   gap: 2,
                      // ),
                      // MultiWaveVisualizer(
                      //   color: Colors.blueAccent,
                      //   input: source.value.waveform,
                      //   backgroundColor: Colors.black,
                      // ),
                      // MultiWaveVisualizer(
                      //   color: Colors.yellowAccent,
                      //   input: getMagnitudes(source.value.fft),
                      //   backgroundColor: Colors.black,
                      // ),

                      LineBarVisualizer(
                        color: Colors.blueAccent,
                        input: source.value.waveform,
                        backgroundColor: Colors.transparent,
                      ),

                      // LineBarVisualizer(
                      //   color: Colors.yellowAccent,
                      //   input: getMagnitudes(source.value.fft).take(128).toList(),
                      //   backgroundColor: Colors.black,
                      // ),
                    ],
                  );
                },
              ),
            ]
                .map((e) => Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: e,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  Future<void> onMic() async {
    if (await record.isRecording()) {
      _micData?.cancel();
      record.stop();
      setState(() {
        isRecording = false;
      });
      return;
    }
    final stream = await record.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        autoGain: true,
        echoCancel: true,
        noiseSuppress: true,
        sampleRate: 44100,
        numChannels: 1,
      ),
    );
    _micData = stream.listen((data) {
      pcmVisualizer.feed(data);
    });
    setState(() {
      isRecording = true;
    });
  }
}

Future<String> downloadFile(String url, String filename) async {
  // Make HTTP request with streaming
  final response = await http.Client().send(http.Request('GET', Uri.parse(url)));

  if (response.statusCode != 200) {
    throw Exception('Failed to download file: ${response.statusCode}');
  }
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/$filename';
  final file = File(filePath);

  // Create file and write chunks
  final sink = file.openWrite();
  await response.stream.forEach((chunk) {
    sink.add(chunk);
  });

  await sink.close();
  return filePath;
}
