# 一键发布 CLI

用 Dart 编写的发布工具：**命令编排 → 打包 → 蒲公英上传 → 钉钉/飞书通知**，单条命令跑完全流程。

## 目录结构

```text
scripts/publish/
├── pubspec.yaml          # 包依赖（独立于 Flutter 项目）
├── config.yaml.example   # 配置模板，复制为 config.yaml 使用
├── .gitignore            # 忽略含密钥的 config.yaml
├── bin/
│   └── publish.dart      # 主入口：参数解析 + 全流程编排
└── lib/
    ├── publish_cli.dart  # 公共导出
    └── src/
        ├── app_version.dart      # 解析 pubspec 版本
        ├── publish_config.dart   # 读取 config.yaml
        ├── flutter_builder.dart  # flutter build apk/ipa
        ├── pgyer_uploader.dart   # 蒲公英 v2 上传
        ├── dingtalk_notifier.dart# 钉钉 markdown 通知（含加签）
        ├── feishu_notifier.dart  # 飞书通知（含签名）
        └── logger.dart            # 彩色分级日志
```

## 首次使用

1. 安装依赖：

   ```bash
   cd scripts/publish
   dart pub get
   ```

2. 生成配置文件并填入密钥：

   ```bash
   cp config.yaml.example config.yaml
   # 编辑 config.yaml：蒲公英 api_key、钉钉/飞书 webhook、secret（按需）
   ```

## 用法

在项目根目录（含 pubspec.yaml）下执行：

```bash
# 默认打 Android 测试包（未指定 --env 时交互选择环境）
dart run scripts/publish/bin/publish.dart

# 指定环境 + 平台
dart run scripts/publish/bin/publish.dart --env test --target android
dart run scripts/publish/bin/publish.dart --env pre --target ios

# 同时打包 Android + iOS
dart run scripts/publish/bin/publish.dart --env prod --target all

# 跳过某一步（例如只发通知）
dart run scripts/publish/bin/publish.dart --skip-build --skip-upload --env test

# 自测：校验配置与参数、预览通知消息，不打包/上传/发送
dart run scripts/publish/bin/publish.dart --dry-run --env test --target all
```

### 参数

| 参数 | 说明 | 默认 |
| --- | --- | --- |
| `--env, -e` | 环境 key（config 中 `build.environments` 定义，如 test/pre/prod） | 交互选择 |
| `--target, -t` | 构建目标：`android` / `ios` / `all` | `android` |
| `--dry-run` | 自测模式：校验配置/参数并预览钉钉/飞书消息，不执行任何实际操作 | `false` |
| `--skip-build` | 跳过打包 | `false` |
| `--skip-upload` | 跳过蒲公英上传 | `false` |
| `--skip-notify` | 跳过钉钉/飞书通知 | `false` |
| `--help, -h` | 显示帮助 | — |

## 流程说明

1. **解析配置与版本**：读取 `scripts/publish/config.yaml`，从 `pubspec.yaml` 解析 `version`（`3.27.0+5` → versionName `3.27.0` / versionCode `5`）。
2. **打包**：执行 `flutter build apk --release --dart-define=app_env=<env>`（Android）或 `flutter build ipa --release`（iOS）。优先使用 `.fvm/flutter_sdk/bin/flutter`，否则用 PATH 中的 `flutter`。
3. **上传蒲公英**：调用 `https://www.pgyer.com/apiv2/app/upload`（v2），multipart 上传，返回下载短链。
4. **通知**：发送 markdown 卡片到钉钉与飞书（应用名/版本/环境/平台/下载链接/二维码），支持各自的加签/签名模式（配置 `secret`）。任一机器人未配置 webhook 时自动跳过。

## 依赖说明

- `args`：命令行参数解析
- `http`：蒲公英上传、钉钉/飞书通知
- `yaml` / `path`：配置与版本解析
- `crypto`：钉钉/飞书签名 HmacSHA256

> iOS 打包需要 macOS + Xcode（`flutter build ipa`）。
