
# 图片上传选择器 - AssetUploadBox（基于 wechat_assets_picker）


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