import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_templet_project/basicWidget/n_button_confirm.dart';
import 'package:flutter_templet_project/network/oss/oss_util.dart';
import 'package:flutter_templet_project/util/theme/app_color.dart';
import 'package:flutter_templet_project/vendor/toast_util.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

/// 签名
class SchemeSignPage extends StatefulWidget {
  const SchemeSignPage({Key? key}) : super(key: key);

  @override
  SchemeSignPageState createState() => SchemeSignPageState();
}

class SchemeSignPageState extends State<SchemeSignPage> {
  // 画板监听
  final signatureController = SignatureController(
    penStrokeWidth: 5,
  );

  // 是否绘制
  bool isEmpty = true;

  @override
  void initState() {
    super.initState();

    // 监听画板
    signatureController.addListener(() {
      var tmpIsEmpty = signatureController.value.isEmpty;
      if (isEmpty != tmpIsEmpty) {
        if (mounted) {
          isEmpty = tmpIsEmpty;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RotatedBox(
        quarterTurns: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Signature(
              controller: signatureController,
              width: MediaQuery.of(context).size.height,
              height: Get.width,
              backgroundColor: Colors.white,
            ),
            Positioned(
              left: Platform.isAndroid ? 28 : 40,
              top: 8,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColor.fontColor,
                  size: 24,
                ),
              ),
            ),
            // 暂无签名
            Offstage(
              offstage: !isEmpty,
              child: const Text(
                '请在空白处手写签名',
                style: TextStyle(
                  fontSize: 36,
                  color: Color(0xff999999),
                ),
              ),
            ),
            // 橡皮 & 完成 按钮
            Positioned(
              bottom: 16,
              right: 48,
              child: Row(
                children: [
                  // 清除
                  Offstage(
                    offstage: isEmpty,
                    child: TextButton(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 24,
                        ),
                        child: const Text(
                          '清除',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff999999),
                          ),
                        ),
                      ),
                      onPressed: () => signatureController.clear(),
                    ),
                  ),
                  // 确认签署
                  Offstage(
                    offstage: isEmpty,
                    child: NButtonConfirm(
                      title: '采用',
                      width: 132,
                      onPressed: onConfirm,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onConfirm() async {
    var bytes = await signatureController.toPngBytes();
    // 获取文件夹
    Directory? tempDir = await getTemporaryDirectory();
    String? storagePath = '${tempDir.path}/signature.png';
    var file = File(storagePath);
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsBytesSync(bytes!);
    onSubmit(file.path);
  }

  // 上传签名&&提交签名至方案
  onSubmit(String path) async {
    ToastUtil.loading('正在上传...');
    var url = await uploadFile(path: path);
    ToastUtil.hideLoading();
    ToastUtil.success('签名成功');
    Get.back(result: {"url": url});
  }

  Future<String?> uploadFile({
    required String path,
    ValueNotifier<double>? percentVN,
  }) async {
    var res = await OssUtil.upload(
      filePath: path,
      onSendProgress: (int count, int total) {
        final percent = (count / total);
        if (percent >= 0.99) {
          percentVN?.value = 0.99;
        } else {
          percentVN?.value = percent;
        }
      },
      onReceiveProgress: (int count, int total) {
        percentVN?.value = 1;
      },
    );
    if (res != null) {
      debugPrint("res: $res");
      return res;
    }
    return null;
  }
}
