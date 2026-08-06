//
//  LocalImagePage.dart
//  flutter_templet_project
//
//  Created by shang on 12/10/21 5:25 PM.
//  Copyright © 12/10/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/generated/assets.dart';

class LocalImagePage extends StatelessWidget {
  final String? title;

  LocalImagePage({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "$this"),
      ),
      body: buildGridView(),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      padding: EdgeInsets.all(15.0),
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 4 / 3,
      children: imageNames
          .map((e) => GridTile(
                footer: Container(
                    color: Colors.green,
                    height: 25,
                    child: Center(
                      child: FittedBox(fit: BoxFit.fitWidth, child: Text(e)),
                    )),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image(image: AssetImage(e), fit: BoxFit.contain),
                ]),
              ))
          .toList(),
    );
  }

    final List<String> imageNames = <String>[
    Assets.imagesAvatar,
    Assets.imagesIconAppbarBack,
    Assets.imagesIconAppbarBackWhite,
    Assets.imagesIconHomeDelete,
    Assets.imagesImgPlaceholderEmpty,
    Assets.imagesImgPlaceholderEmptyOne,
    Assets.imagesImgPlaceholderOffonline,
    Assets.imagesImgPlaceholderSearch,
    Assets.imagesImgUpdate,
    Assets.imagesImgUploadPlaceholder,
    Assets.imagesIconDelete,
  ];
  // var imageNames = [
  //   Image.asset("avatar.png", fit: BoxFit.fill),
  //   Image.asset("icon_appbar_back.png", fit: BoxFit.fill),
  //   Image.asset("icon_appbar_back_white.png", fit: BoxFit.fill),
  //   Image.asset("icon_home_delete.png", fit: BoxFit.fill),
  //   Image.asset("img_placeholder_empty.png", fit: BoxFit.fill),
  //   Image.asset("img_placeholder_empty_one.png", fit: BoxFit.fill),
  //   Image.asset("img_placeholder_offonline.png", fit: BoxFit.fill),
  //   Image.asset("img_placeholder_search.png", fit: BoxFit.fill),
  //   Image.asset("img_update.png", fit: BoxFit.fill),
  //   Image.asset(" img_upload_placeholder.png", fit: BoxFit.fill),
  // ];
}
