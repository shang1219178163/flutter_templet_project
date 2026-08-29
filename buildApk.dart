#!/usr/bin/env dart
// ignore_for_file: file_names

import 'dart:io';

Future<void> main() async {
  final yaml = File('pubspec.yaml');
  if (!yaml.existsSync()) {
    stderr.writeln('错误: 找不到 pubspec.yaml 文件');
    exit(1);
  }
  final version = RegExp(r'^version:\s*(\S+)', multiLine: true).firstMatch(yaml.readAsStringSync())?.group(1);
  if (version == null || !version.contains('+')) {
    stderr.writeln('错误: 无法提取版本信息');
    exit(1);
  }
  final parts = version.split('+');
  const envs = {'1': 'test', '2': 'pre', '0': 'prod'};
  String? env;
  while (env == null) {
    stdout.write('请选择环境: 1:test  2:pre  0:prod\n');
    env = envs[stdin.readLineSync()?.trim()];
    if (env == null) {
      stdout.writeln('请输入有效的选项 (1 或 2 或 0)');
    }
  }

  const dir = 'build/app/outputs/flutter-apk';
  const appPrefix = 'kbisai';
  final timestamp = DateTime.now().toString().substring(0, 16).replaceAll(RegExp(r'[ :]'), '-');
  final name = '$appPrefix-${parts[0]}_${parts[1]}_${timestamp}_$env.apk';
  final build = await Process.start(
    'flutter',
    ['build', 'apk', '--release', '--dart-define=app_env=$env'],
    mode: ProcessStartMode.inheritStdio,
  );
  if (await build.exitCode != 0) {
    stderr.writeln('错误: APK 构建失败');
    exit(1);
  }
  await File('$dir/app-release.apk').copy('$dir/$name');
  stdout.writeln('\n在编辑器中打开文件目录 (Cmd + 单击)');
  stdout.writeln('\x1B[35m${Directory(dir).absolute.path}\x1B[0m');
}
