import 'package:flutter/material.dart';

class ErrorCustomWidget extends StatelessWidget {

  const ErrorCustomWidget({
  	Key? key,
  	required this.details,
  }) : super(key: key);

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Error Info'),
        ),
        body: Center(
          // child: Text("Flutter 走神了"),
          child: Container(
            color: Colors.red.shade400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 44,),
                Text(details.toString(),
                  style: TextStyle(fontSize: 16.0, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
    );
  }
}