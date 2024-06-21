//
//  OssAuthApi.dart
//  flutter_templet_project
//
//  Created by shang on 2024/6/21 21:54.
//  Copyright © 2024/6/21 shang. All rights reserved.
//

import 'package:flutter_templet_project/network/base_request_api.dart';

class OssAuthApi extends BaseRequestAPI {
  OssAuthApi();

  @override
  String get requestURI {
    const url = '*/oss/auth/sts';
    return url;
  }

  @override
  HttpMethod get requestType => HttpMethod.GET;
}
