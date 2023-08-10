

import 'package:flutter_templet_project/network/base_request_api.dart';

/// 请求分页基类
class BasePageRequestApi extends BaseRequestAPI {

  BasePageRequestApi({
    this.pageNo = 1,
    this.pageSize = 30,
  });

  int pageNo;

  int pageSize;

}