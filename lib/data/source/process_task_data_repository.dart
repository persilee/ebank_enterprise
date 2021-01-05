/// Copyright (c) 2020 深圳高阳寰球科技有限公司
///
/// Author: wangluyao
/// Date: 2020-12-25

import 'package:ebank_mobile/http/hsg_http.dart';

import 'model/find_user_to_do_task.dart';

class ProcessTaskDataRepository {
  Future<FindUserToDoTaskResp> findUserToDoTask(
      FindUserToDoTaskReq req, String tag) {
    return request('/firmWkfl/processTask/findUserTodoTask', req, tag,
        (data) => FindUserToDoTaskResp.fromJson(data));
  }
}
