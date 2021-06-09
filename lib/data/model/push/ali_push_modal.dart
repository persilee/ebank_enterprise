import 'package:json_annotation/json_annotation.dart';

part 'ali_push_modal.g.dart';

/// 推送key设置取消的入参
@JsonSerializable()
class ParametersReq {
  /// 1 account 2 tags 3 alias
  @JsonKey(name: 'type')
  int type;

  /// 设置的值，统一为字符串数组，除了tags其他只能传一个元素，多余的参数不处理
  /// 需要取消的值，统一为字符串数组，除了tags其他只能传一个元素，多余的参数不处理（account不用传，alias传空则会取消设备绑定的所有别名）
  @JsonKey(name: 'parameters')
  List<String> parameters;

  ParametersReq(
    this.type,
    this.parameters,
  );

  factory ParametersReq.fromJson(Map<String, dynamic> srcJson) =>
      _$ParametersReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ParametersReqToJson(this);
}

/// 推送key设置取消的回参，暂时没有解析，只取了success值
@JsonSerializable()
class ParametersResp {
  /// 是否成功
  @JsonKey(name: 'success')
  bool success;

  ParametersResp(
    this.success,
  );

  factory ParametersResp.fromJson(Map<String, dynamic> srcJson) =>
      _$ParametersRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ParametersRespToJson(this);
}

/// 推送接受消息的回调入参，没有入参
@JsonSerializable()
class MessageReq {
  MessageReq();

  factory MessageReq.fromJson(Map<String, dynamic> srcJson) =>
      _$MessageReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MessageReqToJson(this);
}

/// 推送接受消息的回调回参
@JsonSerializable()
class MessageResp {
  /// 消息类型
  @JsonKey(name: 'messageType')
  bool messageType;

  /// 标题
  @JsonKey(name: 'title')
  bool title;

  /// 内容
  @JsonKey(name: 'body')
  bool body;

  MessageResp(
    this.messageType,
    this.title,
    this.body,
  );

  factory MessageResp.fromJson(Map<String, dynamic> srcJson) =>
      _$MessageRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MessageRespToJson(this);
}

/// 推送接受通知的回调入参，没有入参
@JsonSerializable()
class NotificationReq {
  NotificationReq();

  factory NotificationReq.fromJson(Map<String, dynamic> srcJson) =>
      _$NotificationReqFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NotificationReqToJson(this);
}

/// 推送接受通知的回调回参
@JsonSerializable()
class NotificationResp {
  /// 通知时间
  @JsonKey(name: 'noticeDate')
  String noticeDate;

  /// 标题
  @JsonKey(name: 'title')
  String title;

  /// 副标题
  @JsonKey(name: 'subtitle')
  String subtitle;

  /// 内容
  @JsonKey(name: 'body')
  String body;

  /// 角标
  @JsonKey(name: 'badge')
  int badge;

  /// 整个内容
  @JsonKey(name: 'userInfo')
  Map userInfo;

  NotificationResp(
    this.noticeDate,
    this.title,
    this.subtitle,
    this.body,
    this.badge,
    this.userInfo,
  );

  factory NotificationResp.fromJson(Map<String, dynamic> srcJson) =>
      _$NotificationRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$NotificationRespToJson(this);
}
