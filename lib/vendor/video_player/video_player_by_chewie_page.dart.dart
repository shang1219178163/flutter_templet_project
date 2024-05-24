//
//  ChewiePlayerPage.dart
//  yl_ylgcp_app
//
//  Created by shang on 2023/9/19 11:32.
//  Copyright © 2023/9/19 shang. All rights reserved.
//

import 'package:flutter/material.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter_templet_project/basicWidget/upload/video_service.dart';
import 'package:flutter_templet_project/extension/string_ext.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerByChewiePage extends StatefulWidget {
  VideoPlayerByChewiePage({
    Key? key,
    this.onBack,
  }) : super(key: key);

  /// 返回事件
  final VoidCallback? onBack;

  @override
  _VideoPlayerByChewiePageState createState() =>
      _VideoPlayerByChewiePageState();
}

class _VideoPlayerByChewiePageState extends State<VideoPlayerByChewiePage> {
  Map arguments = Get.arguments;

  String get videoTitle => arguments["videoTitle"] ?? "";

  String get videoUrl => arguments["videoUrl"] ?? "";

  String get videoThumbUrl => arguments["videoThumbUrl"] ?? "";

  late final VoidCallback? onBackNew = widget.onBack ?? arguments["onBack"];
  late final bool hideDownload = arguments["hideDownload"] ?? false;

  final TargetPlatform? _platform = TargetPlatform.iOS;
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? bufferDelay = 0;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initPlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await _videoPlayerController.initialize();

    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      // additionalOptions: (context) {
      //   return <OptionItem>[
      //     OptionItem(
      //       onTap: toggleVideo,
      //       iconData: Icons.live_tv_sharp,
      //       title: 'Toggle Video Src',
      //     ),
      //   ];
      // },
      hideControlsTimer: const Duration(seconds: 1),
      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  Future<void> toggleVideo() async {
    await _videoPlayerController.pause();
    await initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(videoTitle),
        backgroundColor: Colors.transparent,
        // actions: ['done',].map((e) => TextButton(
        //   child: Text(e,
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   onPressed: () => debugPrint(e),)
        // ).toList(),
        leading: buildCircleButton(
            padding: const EdgeInsets.only(left: 16),
            onPressed: onBackNew,
            // icon: Icon(Icons.cancel,
            //     color: Colors.grey
            // ),
            icon: Image(
              image: "icon_cancel_round.png".toAssetImage(),
              width: 24,
              height: 24,
            )),
        leadingWidth: 48,
        actions: [
          if (!hideDownload)
            buildCircleButton(
              padding: const EdgeInsets.only(right: 16),
              radius: 16,
              icon: const Icon(Icons.save_alt, color: Colors.white),
              onPressed: () {
                debugPrint("save");
                VideoService.saveVideo(url: videoUrl);
              },
            ),
        ],
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCircleButton({
    EdgeInsets padding = EdgeInsets.zero,
    double? radius = 14,
    Widget icon = const Icon(
      Icons.arrow_back_ios_new_outlined,
      color: Colors.white,
    ),
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: padding,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black.withOpacity(0.3),
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onPressed ?? () => Navigator.maybePop(context),
          icon: icon,
        ),
      ),
    );
  }

// saveVideo({required String url}) async {
//   String? name;
//   try {
//     name = url.split("/").last;
//   } catch (e) {
//     debugPrint("saveVideo name: ${e.toString()}");
//   }
//
//   var cacheDir = await CacheAssetService().getDir();
//   String savePath = "${cacheDir.path}/$name";
//   await Dio().download(url, savePath);
//   final result = await ImageGallerySaver.saveFile(savePath);
//   debugPrint("saveFile: ${result} $url");
//
//   final isSuccess = result["isSuccess"];
//   final message = isSuccess ? "视频已保存到相册" : "操作失败";
//   if (isSuccess) {
//     EasyToast.showToast(message,);
//   }
// }
}
