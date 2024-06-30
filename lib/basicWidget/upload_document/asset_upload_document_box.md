
# 文档上传选择器 - AssetUploadDocumentModel


## 使用

```
  /// 初始化数据
  var selectedModels = <AssetUploadDocumentModel>[];
  /// 获取链接数组
  List<String> urls = [];

  ......
  
  Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: AssetUploadDocumentBox(
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