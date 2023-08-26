
# 图片上传选择器 - AssetUploadBox（基于 wechat_assets_picker）


```涉及第三方库
// 图片选择
wechat_assets_picker

// 图片压缩
flutter_image_compress

// 负责缓存文件清理
path_provider

// 图片上传
dio

// 网络图片显示
extended_image

// 网络图片预览
photo_view

// 网络图片保存到相册
image_gallery_saver
```

## 使用

```
  /// 初始化数据
  var selectedModels = <AssetUploadModel>[];
  /// 获取图片链接数组
  List<String> urls = [];

  ......
  
  Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: AssetUploadBox(
      items: selectedModels,
      // showFileSize: true,
      onChanged: (items){
        selectedModels = items.where((e) => e.url?.startsWith("http") == true).toList();
        urls = selected.map((e) => e.url ?? "").toList();
      },
    ),
  ),
```


支持断网重连，删除；默认执行压缩；