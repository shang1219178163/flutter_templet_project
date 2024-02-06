fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios release

```sh
[bundle exec] fastlane ios release
```

打包 release 版本, to: pgy/fir/release

### ios releaseupload

```sh
[bundle exec] fastlane ios releaseupload
```

上传 release 版本, to: pgy/fir/release

### ios develop

```sh
[bundle exec] fastlane ios develop
```

打包 development 版本, to: pgy/fir

### ios developupload

```sh
[bundle exec] fastlane ios developupload
```

上传 develop 版本, to: pgy/fir

### ios test

```sh
[bundle exec] fastlane ios test
```

[通用]发布新版本到 AppStore

[通用]发布新版本到 AppStore

[通用]发布新版本到 fir

上传ipad 到 firim

上传ipad 到 Pgyer

更新BuildVersion

webhook 钉钉

推送通知到slack

测试

### ios archive

```sh
[bundle exec] fastlane ios archive
```

archive sign: develop/release, to: pgy/fir/release, target: A/B/C

### ios upload

```sh
[bundle exec] fastlane ios upload
```

upload sign: develop/release, to:pgy/fir/release, target: A/B/C

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
