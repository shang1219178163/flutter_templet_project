import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter_templet_project/extension/ddlog.dart';


class FlutterFFiTest extends StatefulWidget {

  FlutterFFiTest({
    super.key,
    this.title
  });

  final String? title;

  @override
  State<FlutterFFiTest> createState() => _FlutterFFiTestState();
}

class _FlutterFFiTestState extends State<FlutterFFiTest> {

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => debugPrint(e),)
        ).toList(),
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

  onTest() {
    // Allocate and free some native memory with calloc and free.
    final pointer = calloc<Uint8>();
    pointer.value = 3;
    ddlog(pointer.value);
    calloc.free(pointer);

    // Use the Utf8 helper to encode zero-terminated UTF-8 strings in native memory.
    final String myString = '😎👿💬';
    final Pointer<Utf8> charPointer = myString.toNativeUtf8();
    ddlog('First byte is: ${charPointer.cast<Uint8>().value}');
    ddlog(charPointer.toDartString());
    calloc.free(charPointer);
  }
}