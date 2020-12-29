import 'package:json_annotation/json_annotation.dart';

part 'find_user_to_do_task.g.dart';

@JsonSerializable()
class FindUserToDoTaskReq extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'processId')
  String processId;

  @JsonKey(name: 'processKey')
  String processKey;

  @JsonKey(name: 'processTitle')
  String processTitle;

  @JsonKey(name: 'sort')
  String sort;

  @JsonKey(name: 'startUser')
  String startUser;

  @JsonKey(name: 'taskId')
  String taskId;

  @JsonKey(name: 'taskName')
  String taskName;

  FindUserToDoTaskReq(
    this.page,
    this.pageSize,
    this.processId,
    this.processKey,
    this.processTitle,
    this.sort,
    this.startUser,
    this.taskId,
    this.taskName,
  );

  factory FindUserToDoTaskReq.fromJson(Map<String, dynamic> srcJson) =>
      _$FindUserToDoTaskReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FindUserToDoTaskReqToJson(this);
}

@JsonSerializable()
class FindUserToDoTaskResp extends Object {
  @JsonKey(name: 'page')
  int page;

  @JsonKey(name: 'pageSize')
  int pageSize;

  @JsonKey(name: 'sort')
  String sort;

  FindUserToDoTaskResp(
    this.page,
    this.pageSize,
    this.sort,
  );

  factory FindUserToDoTaskResp.fromJson(Map<String, dynamic> srcJson) =>
      _$FindUserToDoTaskRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FindUserToDoTaskRespToJson(this);
}
