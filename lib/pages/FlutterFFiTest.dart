import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

class FlutterFFiTest extends StatelessWidget {

  final String? title;

  const FlutterFFiTest({
  	Key? key,
  	this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? "$this"),
          actions: [
            TextButton(
              onPressed: () => _buildTest(),
              child: Text('done', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        body: Text(arguments.toString())
    );
  }
  
  _buildTest() {
    // Allocate and free some native memory with calloc and free.
    final pointer = calloc<Uint8>();
    pointer.value = 3;
    print(pointer.value);
    calloc.free(pointer);

    // Use the Utf8 helper to encode zero-terminated UTF-8 strings in native memory.
    final String myString = '😎👿💬';
    final Pointer<Utf8> charPointer = myString.toNativeUtf8();
    print('First byte is: ${charPointer.cast<Uint8>().value}');
    print(charPointer.toDartString());
    calloc.free(charPointer);
  }
}