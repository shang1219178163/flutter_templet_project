/// flutter 打包模块：执行 `flutter build apk/ipa` 并返回产物路径。
library;

import 'dart:io';

import 'package:path/path.dart' as p;

import 'logger.dart';

/// 打包目标平台
enum BuildTarget {
  android('apk', 'Android'),
  ios('ipa', 'iOS');

  const BuildTarget(this.flag, this.label);

  /// flutter build 子命令
  final String flag;

  /// 展示名
  final String label;
}

/// flutter 打包结果
class BuildResult {
  BuildResult({required this.target, required this.outputPath});

  final BuildTarget target;

  /// 产物文件路径（APK 或 IPA）
  final String outputPath;
}

/// 打包执行器
class FlutterBuilder {
  FlutterBuilder({required this.rootDir, required this.logger});

  final String rootDir;
  final Logger logger;

  /// 执行 flutter build
  ///
  /// [envKey] 会作为 --dart-define=app_env=<envKey> 传入。
  /// [exportOptionsPlist] iOS 导出选项（可选，传了则走 exportOptionsPlist 导出）。
  Future<BuildResult> build({
    required BuildTarget target,
    required String envKey,
    String? exportOptionsPlist,
  }) async {
    final args = <String>[
      'build',
      target.flag,
      '--release',
      '--dart-define=app_env=$envKey',
    ];
    if (target == BuildTarget.ios && exportOptionsPlist != null) {
      args.add('--export-options-plist=$exportOptionsPlist');
    }

    logger.info('开始打包 ${target.label}：flutter ${args.join(' ')}');
    final exitCode = await _run(args);
    if (exitCode != 0) {
      throw ProcessException('flutter build ${target.flag}', args, '打包失败，退出码 $exitCode', exitCode);
    }
    return _resolveOutput(target);
  }

  /// 解析产物路径
  BuildResult _resolveOutput(BuildTarget target) {
    final buildRoot = p.join(rootDir, 'build');
    switch (target) {
      case BuildTarget.android:
        final apk = p.join(buildRoot, 'app', 'outputs', 'flutter-apk', 'app-release.apk');
        if (!File(apk).existsSync()) {
          throw FileSystemException('未找到 APK 产物: $apk');
        }
        return BuildResult(target: target, outputPath: apk);
      case BuildTarget.ios:
        return _resolveIpa(buildRoot);
    }
  }

  /// 定位 build/ios/ipa/ 下的 .ipa 产物
  BuildResult _resolveIpa(String buildRoot) {
    final ipaDir = p.join(buildRoot, 'ios', 'ipa');
    if (!Directory(ipaDir).existsSync()) {
      throw FileSystemException('未找到 iOS 产物目录: $ipaDir');
    }
    final ipas = Directory(ipaDir)
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.ipa'))
        .toList();
    if (ipas.isEmpty) {
      throw FileSystemException('未找到 .ipa 产物: $ipaDir');
    }
    final ipa = ipas.first.path;
    logger.success('iOS 产物: $ipa');
    return BuildResult(target: BuildTarget.ios, outputPath: ipa);
  }

  /// 运行 flutter 命令（透传 stdio，让用户看到打包进度）
  Future<int> _run(List<String> args) async {
    final cmd = _flutterCommand();
    logger.debug('执行命令: $cmd ${args.join(' ')}');
    final process = await Process.start(cmd, args, workingDirectory: rootDir);
    process.stdout.transform(const SystemEncoding().decoder).listen((s) => stdout.write(s));
    process.stderr.transform(const SystemEncoding().decoder).listen((s) => stderr.write(s));
    return process.exitCode;
  }

  /// 定位 flutter 可执行文件：优先 fvm，其次 PATH
  String _flutterCommand() {
    // fvm 场景：项目 .fvm/flutter_sdk/bin/flutter
    final fvmFlutter = p.join(rootDir, '.fvm', 'flutter_sdk', 'bin', 'flutter');
    if (File(fvmFlutter).existsSync()) {
      return fvmFlutter;
    }
    return 'flutter';
  }
}
