import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ExtendedImageDemo extends StatefulWidget {
  ExtendedImageDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ExtendedImageDemoState createState() => _ExtendedImageDemoState();
}

class _ExtendedImageDemoState extends State<ExtendedImageDemo> {
  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;
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
      body: Text(arguments.toString()),
    );
  }

  buildCardItem({
    required String url,
    BoxFit fit = BoxFit.fill,
    double? width,
    double? height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ExtendedImage.network(url, width: width, height: height, fit: fit, cache: true,
          // border: Border.all(color: Colors.red, width: 1.0),
          // borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //cancelToken: cancellationToken,
          loadStateChanged: (ExtendedImageState state) {
        if (state.extendedImageLoadState != LoadState.completed) {
          return Icon(
            Icons.photo,
            color: Colors.teal.shade100,
            size: 100,
          );
        }
        // debugPrint("Image width ${state.extendedImageInfo?.image.width} height : ${state.extendedImageInfo?.image.height}");
        var widget = ExtendedRawImage(
          image: state.extendedImageInfo?.image,
          width: width,
          height: height,
          fit: BoxFit.fill,
          // soucreRect: Rect.fromLTWH((state.extendedImageInfo?.image?.width-200)/2,(state.extendedImageInfo?.image?.height-200)/2, 200, 200),
        );
        debugPrint("Source Rect width ${widget.width} height : ${widget.height}");
        return widget;
      }),
    );
  }
}
