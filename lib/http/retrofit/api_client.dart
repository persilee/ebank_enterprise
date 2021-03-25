

import 'package:dio/dio.dart';
import 'package:ebank_mobile/data/source/model/find_to_do_task_detail_model.dart';
import 'package:ebank_mobile/data/source/model/find_user_todo_task_model.dart';
import 'package:ebank_mobile/data/source/model/login.dart';
import 'package:ebank_mobile/http/retrofit/base_body.dart';
import 'package:retrofit/http.dart';

import 'base_dio.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'http://161.189.48.75:5040')
abstract class ApiClient {
  factory ApiClient({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  /// 登录
  @POST('/security/cutlogin')
  Future<LoginResp> login(@Body() BaseBody baseBody);

  /// 查询属于我的待办任务
  @POST('/wkfl/processTask/findUserTodoTask')
  Future<FindUserTodoTaskModel> findUserTodoTask(@Body() BaseBody baseBody);

  /// 根据流程id查询待办任务详细信息
  @POST('/wkfl/processTask/findToDoTaskDetail')
  Future<FindToDoTaskDetailModel> findToDoTaskDetail(@Body() BaseBody baseBody);


}
