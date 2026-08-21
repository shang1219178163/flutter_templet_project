import 'package:flutter/material.dart';

class NFutureBuilder<T> extends StatelessWidget {
  const NFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.errorBuilder,
    this.loadingBuilder,
  });

  final Future<T>? future;
  final Widget Function(T data) builder;
  final Widget Function(Object? error)? errorBuilder;
  final Widget Function()? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return errorBuilder?.call(snapshot.error) ?? const Placeholder();
          }
          return builder(snapshot.data);
          // // 请求成功，显示数据
          // final response = snapshot.data/(1024 *1024);
          // final desc = response.toStringAsFixed(2) + "MB";
          // return Text(desc);
        }
        final indicator = FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          child: CircularProgressIndicator(),
        );
        return loadingBuilder?.call() ?? indicator;
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Future<T>?>('future', future));
    properties.add(ObjectFlagProperty<Widget Function(T data)>.has('builder', builder));
    properties.add(ObjectFlagProperty<Widget Function(Object? error)?>.has('errorBuilder', errorBuilder));
    properties.add(ObjectFlagProperty<Widget Function()?>.has('loadingBuilder', loadingBuilder));
  }
}
