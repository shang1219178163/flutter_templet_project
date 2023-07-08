
import 'package:flutter/material.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';


class NNetworkImage extends StatelessWidget {

  NNetworkImage({
  	Key? key,
  	this.title,
    required this.url,
    this.fit = BoxFit.fill,
    this.width,
    this.height,
    this.radius = 8,
    this.cache = true,
    this.mode = ExtendedImageMode.none,
  }) : super(key: key);

  String? title;

  String url;

  BoxFit? fit;

  double? width;

  double? height;

  double radius;

  bool cache;

  ExtendedImageMode mode;


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.startsWith("http") == false ? Image(
        image: "img_placehorder.png".toAssetImage(),
        width: width,
        height: height,
      ) : ExtendedImage.network(
        url,
        width: width,
        height: height,
        fit: fit,
        cache: cache,
        mode: mode,
        // border: Border.all(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(radius),
        //cancelToken: cancellationToken,
        loadStateChanged: (ExtendedImageState state) {
          if(state.extendedImageLoadState != LoadState.completed) {
            // return Icon(Icons.photo, color: Colors.teal.shade100, size: height,);
            return Image(
              image: "img_placehorder.png".toAssetImage(),
              width: width,
              height: height,
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
          // debugPrint("Source Rect width ${widget.width} height : ${widget.height}");
          return widget;
        }
      ),
    );
  }
}

// class NNetworkImage extends StatefulWidget {
//
//   NNetworkImage({
//     Key? key,
//     this.title
//   }) : super(key: key);
//
//   final String? title;
//
//   @override
//   _NNetworkImageState createState() => _NNetworkImageState();
// }
//
// class _NNetworkImageState extends State<NNetworkImage> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     dynamic arguments = ModalRoute.of(context)!.settings.arguments;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title ?? "$widget"),
//         actions: ['done',].map((e) => TextButton(
//           child: Text(e,
//             style: TextStyle(color: Colors.white),
//           ),
//           onPressed: () => print(e),)
//         ).toList(),
//       ),
//       body: Text(arguments.toString())
//     );
//   }
//
//   buildCardItem({
//     required String url,
//     BoxFit fit = BoxFit.fill,
//     double? width,
//     double? height,
//   }) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8.w),
//       child: ExtendedImage.network(
//         url,
//         width: width,
//         height: height,
//         fit: fit,
//         cache: true,
//         // border: Border.all(color: Colors.red, width: 1.0),
//         // borderRadius: BorderRadius.all(Radius.circular(30.0)),
//         //cancelToken: cancellationToken,
//         loadStateChanged: (ExtendedImageState state) {
//           if(state.extendedImageLoadState != LoadState.completed) {
//             return Icon(Icons.photo, color: Colors.teal.shade100, size: 100,);
//           }
//           // debugPrint("Image width ${state.extendedImageInfo?.image.width} height : ${state.extendedImageInfo?.image.height}");
//           var widget = ExtendedRawImage(
//             image: state.extendedImageInfo?.image,
//             width: width,
//             height: height,
//             fit: BoxFit.fill,
//             // soucreRect: Rect.fromLTWH((state.extendedImageInfo?.image?.width-200)/2,(state.extendedImageInfo?.image?.height-200)/2, 200, 200),
//           );
//           // debugPrint("Source Rect width ${widget.width} height : ${widget.height}");
//           return widget;
//         }
//       ),
//     );
//   }
// }